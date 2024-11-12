import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/constants/app_strings.dart';
import 'package:lyxa_live/src/features/home/presentation/components/drawer_unit.dart';
import 'package:lyxa_live/src/features/post/presentation/components/post_tile_unit.dart';
import 'package:lyxa_live/src/features/post/presentation/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/presentation/cubits/post_state.dart';
import 'package:lyxa_live/src/features/post/presentation/screens/upload_post_screen.dart';
import 'package:lyxa_live/src/responsive/constrained_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      // App bar
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          AppStrings.appName,
        ),
        actions: [
          // Upload new post button
          IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadPostScreen(),
                )),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      // Drawer
      drawer: const DrawerUnit(),
      // Body
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // Loading
          if (state is PostLoading && state is PostUploading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          // Loaded
          else if (state is PostLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(
                child: Text("No posts available"),
              );
            }

            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                // Get individual post
                final post = allPosts[index];

                // Image
                return PostTileUnit(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),
                );
              },
            );
          }
          // Error
          else if (state is PostError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
