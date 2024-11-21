import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/shared/widgets/user_tile_unit.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';


class FollowerScreen extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerScreen({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ConstrainedScaffold(
        appBar: _buildAppBar(context),
        body: TabBarView(
          children: [
            UserListView(
              uids: followers,
              emptyMessage: AppStrings.noFollowersMessage,
            ),
            UserListView(
              uids: following,
              emptyMessage: AppStrings.noFollowingMessage,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(AppDimens.size72), 
      child: AppBar(
        centerTitle: true, 
        automaticallyImplyLeading:
            false, 
        title: SizedBox(
          width: AppDimens.containerSize430, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimens.size24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_outlined,
                      size: AppDimens.size16,
                    ),
                  ),
                ],
              ),
              _buildCustomTabBar(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a custom TabBar
  Widget _buildCustomTabBar(BuildContext context) {
    return TabBar(
      dividerColor: Colors.transparent,
      labelColor: Theme.of(context).colorScheme.inversePrimary,
      indicatorColor: Theme.of(context).colorScheme.primary,
      tabs: const [
        Tab(text: AppStrings.followersTabTitle),
        Tab(text: AppStrings.followingTabTitle),
      ],
    );
  }
}

/// Displays a list of users with support for empty states and loading states
class UserListView extends StatelessWidget {
  final List<String> uids;
  final String emptyMessage;

  const UserListView({
    super.key,
    required this.uids,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (uids.isEmpty) {
      return Center(
        child: Text(emptyMessage),
      );
    }

    return ListView.builder(
      itemCount: uids.length,
      itemBuilder: (context, index) {
        final uid = uids[index];
        return FutureBuilder(
          future: context.read<ProfileCubit>().getUserProfile(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ListTile(title: Text(AppStrings.loadingMessage));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return UserTileUnit(user: user);
            } else {
              return const ListTile(title: Text(AppStrings.userNotFoundMessage));
            }
          },
        );
      },
    );
  }
}
