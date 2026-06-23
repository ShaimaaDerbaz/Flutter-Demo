import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

abstract class PostsRemoteDatasource {
  Future<List<PostModel>> getPosts();
}

class PostsRemoteDatasourceImpl implements PostsRemoteDatasource {
  final http.Client client;
  PostsRemoteDatasourceImpl(this.client);

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }
    final List<dynamic> json = jsonDecode(response.body) as List;
    return json
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
