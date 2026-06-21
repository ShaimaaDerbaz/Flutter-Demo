import 'package:flutter_bloc/flutter_bloc.dart';

/// مثال بسيط على Cubit - أبسط نسخة من BLoC
/// مطابق تماماً لفكرة:
/// class CounterViewModel : ViewModel() {
///   private val _count = MutableStateFlow(0)
///   val count = _count.asStateFlow()
///   fun increment() { _count.value++ }
/// }
class CounterCubit extends Cubit<int> {
  // super(0) = القيمة الابتدائية للـ state، زي MutableStateFlow(0)
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1); // emit = تحديث الـ state الجديد (زي _count.value++)
  }

  void decrement() {
    if (state > 0) emit(state - 1);
  }

  void reset() {
    emit(0);
  }
}
