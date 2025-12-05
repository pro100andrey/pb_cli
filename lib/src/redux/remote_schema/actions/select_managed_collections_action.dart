import '../../common/app_action.dart';
import '../../types/config.dart';

final class SelectManagedCollectionsAction extends AppAction {
  @override
  AppState? reduce() {
    final collectionsNames = select.remoteCollectionNamesWithoutSystem.toList(
      growable: false,
    );

    final currentManagedCollections = select.managedCollections;

    final selected = logger.chooseAny<String>(
      'Select collections to synchronize:',
      choices: collectionsNames,
      defaultValues: currentManagedCollections,
    );

    final managedCollectionsChanged =
        selected.toSet() != currentManagedCollections.toSet();

    if (!managedCollectionsChanged) {
      logger.info('Managed collections are already up to date.');
      return null;
    }

    final newData = ConfigData.data({
      ConfigKey.managedCollections: selected,
      ConfigKey.credentialsSource: select.credentialsSource.key,
    });

    return state.copyWith.config(data: newData);
  }
}
