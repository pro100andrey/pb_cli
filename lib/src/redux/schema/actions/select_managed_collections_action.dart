import '../../common/app_action.dart';

final class SelectManagedCollectionsAction extends AppAction {
  @override
  AppState? reduce() {
    final collectionsNames = select.collectionNamesWithoutSystem.toList(
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

    return state.copyWith.config(managedCollections: selected);
  }
}
