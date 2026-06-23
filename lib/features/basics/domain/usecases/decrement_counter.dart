import '../repositories/counter_repository.dart';

class DecrementCounter {
  final CounterRepository repository;
  const DecrementCounter(this.repository);
  int call() => repository.decrement();
}
