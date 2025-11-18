import '../../actions/action.dart';

final class SelectManagedCollectionsAction extends AppAction {
  @override
  AppState? reduce() {
    final collectionsNames = select.collectionNamesWithoutSystem.toList(
      growable: false,
    );

    final selected = logger.chooseAny<String>(
      'Select collections to synchronize:',
      choices: collectionsNames,
      defaultValues: [],
    );

    return state.copyWith.schema(managedCollections: selected);
  }
}
