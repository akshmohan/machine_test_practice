// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_practice/viewModels/auth_viewModel.dart';
import 'package:machine_test_practice/viewModels/posts_viewModel.dart';
import 'package:machine_test_practice/views/login_page.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final postsViewModel = ref.watch(postProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No")),
                          TextButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).logout();
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginPage(),));
                            },
                            child: const Text("Yes"),
                          )
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: currentIndex == 0
          ? const Center(child: Text("Profile"))
          : postsViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: postsViewModel.posts.length,
                  itemBuilder: (context, index) {
                    final post = postsViewModel.posts[index];
                    return ListTile(
                      title: Text(post.title.toString()),
                      subtitle: Text(post.body.toString()),
                      leading: CircleAvatar(
                        child: Text(post.id.toString()),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(currentIndexProvider.notifier).update((state) => index);
          if(index == 1) {
         ref.read(postProvider.notifier).getAllPosts();
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Posts"),
        ],
      ),
    );
  }
}