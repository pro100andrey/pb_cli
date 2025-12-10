import 'package:cli_utils/cli_utils.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../../common.dart';

final class DownloadFilesAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    throw UnimplementedError();
  }

  /// Downloads all files for the given collection and records
  Future<void> downloadCollectionFiles({
    required PocketBase pb,
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
      (record) =>
          fields.any((field) => record.getStringValue(field.name).isNotEmpty),
    );

    if (recordsWithFiles.isEmpty) {
      return;
    }

    for (final field in fields) {
      switch (field.maxSelect) {
        case 1:
          await _downloadSingleFieldFiles(
            pb: pb,
            field: field,
            records: recordsWithFiles,
            collectionId: collection.id,
            baseDir: baseDir,
          );
        case > 1:
          await _downloadMultipleFieldFiles(
            pb: pb,
            field: field,
            records: recordsWithFiles,
            collectionId: collection.id,
            baseDir: baseDir,
          );
        case 0:
          throw UnimplementedError('maxSelect = 0 is not supported');
      }
    }

    logger.info('');
  }

  /// Downloads a single file from the given URL and saves it to the
  /// specified path.
  Future<String> _downloadFile(
    String url,
    String collectionName,
  ) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download file: ${response.statusCode} '
          '${response.reasonPhrase}',
        );
      }

      final file = FilePath(collectionName)
        ..create(recursive: true)
        ..writeAsBytes(response.bodyBytes);

      return file.path;
    } on Exception catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  /// Downloads files for a single field that can contain one file
  Future<void> _downloadSingleFieldFiles({
    required PocketBase pb,
    required CollectionField field,
    required Iterable<RecordModel> records,
    required String collectionId,
    required DirectoryPath baseDir,
  }) async {
    final downloadProgress = logger.progress(
      'Downloading files for field ${field.name}',
    );

    for (final record in records) {
      final fileName = record.getStringValue(field.name);
      if (fileName.isEmpty) {
        continue;
      }

      final downloadUrl = pb.files.getURL(record, fileName);

      final filePath = baseDir
          .join('storage/$collectionId/${record.id}')
          .joinFile(fileName)
          .path;

      await _downloadFile(downloadUrl.toString(), filePath);
    }

    downloadProgress.complete('Downloaded files for field ${field.name}');
  }

  /// Downloads files for a single field that can contain multiple files
  Future<void> _downloadMultipleFieldFiles({
    required PocketBase pb,
    required CollectionField field,
    required Iterable<RecordModel> records,
    required String collectionId,
    required DirectoryPath baseDir,
  }) async {
    for (final record in records) {
      final downloadProgress = logger.progress(
        'Downloading files for record ${record.id}, field ${field.name}',
      );

      final filesNames = record.getListValue<String>(field.name);
      if (filesNames.isEmpty) {
        downloadProgress.complete('No files to download');
        continue;
      }

      var downloadedCount = 0;
      for (final fileName in filesNames) {
        final downloadUrl = pb.files.getURL(record, fileName);

        final filePath = baseDir
            .join('storage/$collectionId/${record.id}')
            .joinFile(fileName)
            .path;

        await _downloadFile(downloadUrl.toString(), filePath);

        downloadedCount++;
      }

      downloadProgress.complete(
        'Downloaded $downloadedCount files for record ${record.id}, '
        'field ${field.name}',
      );
    }
  }
}

extension CollectionModelFields on CollectionField {
  bool get isFile => type == 'file';

  int get maxSelect => get<int>('maxSelect');
}
