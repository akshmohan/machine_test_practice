import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:machine_test_practice/models/posts_model.dart';

class PostsRepository {
  Future<List<PostModel>> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
      if (response.statusCode == 200) {
        List<PostModel> fetchedPosts = (json.decode(response.body) as List)
            .map((post) => PostModel.fromJson(post))
            .toList();
        return fetchedPosts;
      } else {
        throw Exception(
            "---------------FAILED TO FETCH POSTS : ${response.statusCode}------------------");
      }
    } catch (e) {
      throw Exception(
          "----------------AN EXCEPTION OCCURRED : $e---------------- ");
    }
  }
}
