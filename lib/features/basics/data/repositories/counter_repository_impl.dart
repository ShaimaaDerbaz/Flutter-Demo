import '../../domain/repositories/counter_repository.dart';

class CounterRepositoryImpl implements CounterRepository {
  int _count = 0;

  @override
  int increment() => ++_count;

  @override
  int decrement() {
    if (_count > 0) _count--;
    return _count;
  }

  @override
  int reset() {
    _count = 0;
    return 0;
  }
}
