import 'package:cli_utils/cli_utils.dart';
import 'package:http/http.dart' as http;
import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../client/pb_client.dart';
import '../failure/failure.dart';
import '../models/result.dart';

class FilesDownloaderService {
  const FilesDownloaderService({required Logger logger}) : _logger = logger;

  final Logger _logger;

  /// Downloads a single file from the given URL and saves it to the
  /// specified path
  Future<Result<String, Failure>> downloadFile(
    String url,
    String savePath,
  ) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        return Result.failure(
          Failure.io(
            message:
                'Failed to download file: ${response.statusCode} '
                '${response.reasonPhrase}',
          ),
        );
      }

      final file = FilePath(savePath)
        ..create(recursive: true)
        ..writeAsBytes(response.bodyBytes);

      return Result.success(file.path);
    } on Exception catch (e) {
      return Result.failure(
        Failure.io(message: 'Failed to download file: $e'),
      );
    }
  }

  /// Downloads files for a single field that can contain one file
  Future<void> downloadSingleFieldFiles({
    required PbClient pbClient,
    required CollectionField field,
    required Iterable<RecordModel> records,
    required String collectionId,
    required DirectoryPath baseDir,
  }) async {
    final downloadProgress = _logger.progress(
      'Downloading files for field ${field.name}',
    );

    for (final record in records) {
      final fileName = record.getStringValue(field.name);
      if (fileName.isEmpty) {
        continue;
      }

      final downloadUrl = pbClient.fileUri(
        record: record,
        fileName: fileName,
      );

      final filePath = baseDir
          .join('storage/$collectionId/${record.id}')
          .joinFile(fileName)
          .path;

      final result = await downloadFile(downloadUrl.toString(), filePath);
      if (result case Result(:final error?)) {
        downloadProgress.fail(
          'Failed to download file for record ${record.id}, '
          'field ${field.name}: ${error.message}',
        );
        continue;
      }
    }

    downloadProgress.complete(
      'Downloaded files for field ${field.name}',
    );
  }

  /// Downloads files for a single field that can contain multiple files
  Future<void> downloadMultipleFieldFiles({
    required PbClient pbClient,
    required CollectionField field,
    required Iterable<RecordModel> records,
    required String collectionId,
    required DirectoryPath baseDir,
  }) async {
    for (final record in records) {
      final downloadProgress = _logger.progress(
        'Downloading files for record ${record.id}, field ${field.name}',
      );

      final filesNames = record.getListValue<String>(field.name);
      if (filesNames.isEmpty) {
        downloadProgress.complete('No files to download');
        continue;
      }

      var downloadedCount = 0;
      for (final fileName in filesNames) {
        final downloadUrl = pbClient.fileUri(
          record: record,
          fileName: fileName,
        );

        final filePath = baseDir
            .join('storage/$collectionId/${record.id}')
            .joinFile(fileName)
            .path;

        final result = await downloadFile(downloadUrl.toString(), filePath);
        if (result case Result(:final error?)) {
          downloadProgress.fail(
            'Failed to download file for record ${record.id}, '
            'field ${field.name}: ${error.message}',
          );
          continue;
        }
        downloadedCount++;
      }

      downloadProgress.complete(
        'Downloaded $downloadedCount files for record ${record.id}, '
        'field ${field.name}',
      );
    }
  }

  /// Downloads all files for the given collection and records
  Future<void> downloadCollectionFiles({
    required PbClient pbClient,
    required CollectionModel collection,
    required List<RecordModel> records,
    required DirectoryPath baseDir,
  }) async {
    // Get file fields
    final fields = collection.fields.where((e) => e.isFile);

    if (fields.isEmpty) {
      return;
    }

    final recordsWithFiles = records.where(
      (record) => fields.any(
        (field) => record.getStringValue(field.name).isNotEmpty,
      ),
    );

    if (recordsWithFiles.isEmpty) {
      return;
    }

    for (final field in fields) {
      switch (field.maxSelect) {
        case 1:
          await downloadSingleFieldFiles(
            pbClient: pbClient,
            field: field,
            records: recordsWithFiles,
            collectionId: collection.id,
            baseDir: baseDir,
          );
        case > 1:
          await downloadMultipleFieldFiles(
            pbClient: pbClient,
            field: field,
            records: recordsWithFiles,
            collectionId: collection.id,
            baseDir: baseDir,
          );
        case 0:
          throw UnimplementedError('maxSelect = 0 is not supported');
      }
    }

    _logger.info('');
  }
}

extension CollectionModelFields on CollectionField {
  bool get isFile => type == 'file';

  int get maxSelect => get<int>('maxSelect');
}
