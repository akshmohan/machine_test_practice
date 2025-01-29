// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_practice/config/routes.dart';
import 'package:machine_test_practice/core/custom_dialog.dart';
import 'package:machine_test_practice/core/snackbar.dart';
import 'package:machine_test_practice/viewModels/auth_viewModel.dart';
import 'package:machine_test_practice/viewModels/posts_viewModel.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final postsViewModel = ref.watch(postProvider);
    final authViewModel = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    title: "Logout",
                    content: "Are you sure you want to logout?",
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Perform logout
                          await ref.read(authProvider.notifier).logout();

                          // Close the dialog
                          Navigator.of(context).pop();

                          showSnackBar(context, "Logged out successfully");

                          // Navigate to LoginPage
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.loginPage, (route) => false);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: currentIndex == 0
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            "Username: ${ref.watch(authProvider).username}"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            "AccessToken: ${ref.watch(authProvider).accessToken}"),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : postsViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: postsViewModel.posts.length,
                  itemBuilder: (context, index) {
                    final post = postsViewModel.posts[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                      child: ListTile(
                        title: Text(post.title.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        subtitle: Text(post.body.toString(),
                            style: TextStyle(fontSize: 16)),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Text(post.id.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(currentIndexProvider.notifier).update((state) => index);
          if (index == 1) {
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
