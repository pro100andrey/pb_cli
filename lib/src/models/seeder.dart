import 'package:pocketbase/pocketbase.dart';

import '../extensions/string_buffer.dart';

extension type SeederView(RecordModel record) implements RecordModel {
  Map<String, dynamic> get info => record.data['info'];

  Map<String, dynamic> get muscleGroups => info['muscle_groups'];
  Map<String, dynamic> get equipments => info['equipments'];
  Map<String, dynamic> get recordingTypes => info['recording_types'];
  Map<String, dynamic> get systemExercises => info['system_exercises'];

  SeederCollectionInfo get muscleGroupsInfo =>
      SeederCollectionInfo(muscleGroups);

  SeederCollectionInfo get equipmentsInfo => SeederCollectionInfo(equipments);

  SeederCollectionInfo get recordingTypesInfo =>
      SeederCollectionInfo(recordingTypes);

  SeederCollectionInfo get systemExercisesInfo =>
      SeederCollectionInfo(systemExercises);

  String printInfo() {
    final buffer = StringBuffer()..writeNestedMapInfo('SeederView:', info);
    final output = buffer.toString().trim();

    return output;
  }
}

extension type SeederCollectionInfo(Map<String, dynamic> info) {
  int get count => info['count'] as int;
  String get saveTo => info['saveTo'] as String;
}
