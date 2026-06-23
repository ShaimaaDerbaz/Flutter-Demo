import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDatasource datasource;
  PostsRepositoryImpl(this.datasource);

  @override
  Future<List<Post>> getPosts() => datasource.getPosts();
}
