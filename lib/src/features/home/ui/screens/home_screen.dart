import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/assets/app_fonts.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/home/ui/components/drawer_unit.dart';
import 'package:lyxa_live/src/features/home/ui/components/refresh_button_unit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/widgets/post_tile/post_tile_unit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/post/ui/screens/upload_post_screen.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PostCubit _postCubit;
  ProfileUser _currentUser = ProfileUser.getGuestUser();

  @override
  void initState() {
    super.initState();
    _postCubit = getIt<PostCubit>();
    _initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: _buildAppBar(context),
      drawer: _buildAppDrawer(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoaded) {
            return _buildPostList(state.posts);
          } else if (state is PostError) {
            return _buildDisplayMsgScreen(message: state.message);
          } else {
            return _buildDisplayMsgScreen();
          }
        },
      ),
    );
  }

  void _fetchAllPosts() {
    _postCubit.getAllPosts();
  }

  void _deletePost(Post post) {
    _postCubit.deletePost(post: post);
    //_fetchAllPosts();
  }

  void _initScreen() async {
    final profileUser = await _postCubit.getCurrentUser();

    setState(() {
      _currentUser = profileUser;
    });
    _fetchAllPosts();
  }

  void _navigateToUploadPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadPostScreen(profileUser: _currentUser),
      ),
    );
  }

  Widget _buildAppDrawer() {
    return DrawerUnit(user: _currentUser);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: AppDimens.size32),
          child: Text(
            AppStrings.homeTitle,
            style: AppStyles.textAppBarStatic.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              letterSpacing: AppDimens.letterSpacingPT01,
              fontSize: AppDimens.fontSizeXXL28,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.elMessiri,
            ),
          ),
        ),
      ),
      actions: [
        RefreshButtonUnit(
          onRefresh: _fetchAllPosts,
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppDimens.size2),
          child: IconButton(
            onPressed: _navigateToUploadPostScreen,
            icon: const Icon(Icons.add_box_outlined),
            tooltip: AppStrings.addNewPost,
          ),
        ),
      ],
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return (posts.isEmpty)
        ? _buildDisplayMsgScreen(
            message: AppStrings.noPostAvailableError,
          )
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostTileUnit(
                post: post,
                currentUser: _currentUser,
                onDeletePressed: () => _deletePost(post),
              );
            },
          );
  }

  Widget _buildDisplayMsgScreen({String? message = ''}) {
    Logger.logDebug(message.toString());
    return Center(
      child: Text(
        message ?? '',
        style: AppStyles.titleSecondary.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
