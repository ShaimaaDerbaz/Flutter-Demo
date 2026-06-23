import '../entities/post.dart';
import '../repositories/posts_repository.dart';

class GetPosts {
  final PostsRepository repository;
  const GetPosts(this.repository);

  Future<List<Post>> call() => repository.getPosts();
}
