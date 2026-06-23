import '../repositories/counter_repository.dart';

class ResetCounter {
  final CounterRepository repository;
  const ResetCounter(this.repository);
  int call() => repository.reset();
}
