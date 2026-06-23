import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_posts.dart';
import 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final GetPosts _getPosts;

  PostsCubit(this._getPosts) : super(PostsInitial());

  Future<void> loadPosts() async {
    emit(PostsLoading());
    try {
      final posts = await _getPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }
}
