import '../../action.dart';

final class SelectManagedCollectionsAction extends AppAction {
  @override
  AppState? reduce() {
    final collectionsNames = select.collectionNamesWithoutSystem.toList(
      growable: false,
    );

    final managedCollections = select.managedCollections;

    final selected = logger.chooseAny<String>(
      'Select collections to synchronize:',
      choices: collectionsNames,
      defaultValues: managedCollections,
    );


    final managedCollectionsChanged = managedCollections
        .toSet()
        .difference(select.managedCollections.toSet())
        .isNotEmpty;


    if (!managedCollectionsChanged) {
      logger.info('Managed collections are already up to date.');
      return null;
    }


    return state.copyWith.schema(managedCollections: selected);
  }
}
