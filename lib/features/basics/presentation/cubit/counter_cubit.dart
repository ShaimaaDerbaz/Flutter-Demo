import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/increment_counter.dart';
import '../../domain/usecases/decrement_counter.dart';
import '../../domain/usecases/reset_counter.dart';

class CounterCubit extends Cubit<int> {
  final IncrementCounter _increment;
  final DecrementCounter _decrement;
  final ResetCounter _reset;

  CounterCubit({
    required this._increment,
    required this._decrement,
    required this._reset,
  }) : super(0);

  void increment() => emit(_increment());
  void decrement() => emit(_decrement());
  void reset() => emit(_reset());
}
