import '../repositories/counter_repository.dart';

class IncrementCounter {
  final CounterRepository repository;
  const IncrementCounter(this.repository);
  int call() => repository.increment();
}
