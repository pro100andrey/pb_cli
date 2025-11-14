class Dependencies {
  final Map<(Type, String?), dynamic Function()> _factories = {};
  final Map<(Type, String?), dynamic> _singletons = {};
  final Map<(Type, String?), void Function()> _disposeCallbacks = {};

  void register<T>(
    dynamic Function() factory, {
    String? key,
    bool singleton = false,
    void Function(T instance)? dispose,
  }) {
    final id = (T, key);

    if (singleton) {
      final instance = factory();
      _singletons[id] = instance;

      if (dispose != null) {
        _disposeCallbacks[id] = () => dispose(instance);
      }
    } else {
      _factories[id] = factory;
    }
  }

  T get<T>({String? key}) {
    final id = (T, key);

    if (_singletons.containsKey(id)) {
      return _singletons[id] as T;
    }

    if (_factories.containsKey(id)) {
      return _factories[id]!() as T;
    }

    throw Exception('No provider registered for $T (key: $key)');
  }

  void dispose<T>({String? key}) {
    final id = (T, key);

    if (_singletons.containsKey(id)) {
      _disposeCallbacks[id]?.call();
      _disposeCallbacks.remove(id);
      _singletons.remove(id);
    }
  }

  void disposeAll() {
    for (final cb in _disposeCallbacks.values) {
      cb();
    }
    _disposeCallbacks.clear();
    _singletons.clear();
  }
}
