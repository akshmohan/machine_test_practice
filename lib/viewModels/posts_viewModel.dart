// ignore_for_file: file_names, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_practice/models/posts_model.dart';
import 'package:machine_test_practice/repositories/posts_repository.dart';

class PostViewmodel with ChangeNotifier {
  final PostsRepository _postsRepository;
  PostViewmodel(this._postsRepository);

  List<PostModel> _posts = [];
  bool _isLoading = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> getAllPosts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _posts = await _postsRepository.fetchPosts();
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

final postProvider = ChangeNotifierProvider<PostViewmodel>((ref) {
  final postsRepository = PostsRepository();
  return PostViewmodel(postsRepository);
});
