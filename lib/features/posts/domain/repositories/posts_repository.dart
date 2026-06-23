import '../entities/post.dart';

abstract class PostsRepository {
  Future<List<Post>> getPosts();
}
