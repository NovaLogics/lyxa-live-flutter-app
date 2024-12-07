import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/assets/app_fonts.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';
import 'package:lyxa_live/src/shared/widgets/user_tile_unit.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';

class FollowerScreen extends StatelessWidget {
  final List<String> _followers;
  final List<String> _following;

  const FollowerScreen({
    super.key,
    required List<String> followers,
    required List<String> following,
  })  : _following = following,
        _followers = followers;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ConstrainedScaffold(
        appBar: _buildAppBar(context),
        body: TabBarView(
          children: [
            UserListView(
              userIds: _followers,
              emptyMessage: AppStrings.noFollowersMessage,
            ),
            UserListView(
              userIds: _following,
              emptyMessage: AppStrings.noFollowingMessage,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      centerTitle: true,
      title: SizedBox(
        width: AppDimens.containerSize400,
        child: _buildCustomTabBar(context),
      ),
    );
  }

  Widget _buildCustomTabBar(BuildContext context) {
    return SizedBox(
      width: AppDimens.size280,
      height: AppDimens.size96,
      child: TabBar(
        dividerColor: Colors.transparent,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        indicatorColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.outline,
        labelStyle: AppStyles.textAppBarStatic.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          letterSpacing: AppDimens.letterSpacingPT05,
          fontSize: AppDimens.fontSizeXL20,
          fontFamily: AppFonts.elMessiri,
        ),
        tabs: const [
          Tab(text: AppStrings.followersTabTitle),
          Tab(text: AppStrings.followingTabTitle),
        ],
      ),
    );
  }
}

class UserListView extends StatelessWidget {
  final List<String> userIds;
  final String emptyMessage;

  const UserListView({
    super.key,
    required this.userIds,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (userIds.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: AppStyles.textMessageStatic.copyWith(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: userIds.length,
      itemBuilder: (context, index) {
        final uid = userIds[index];
        return FutureBuilder(
          future: getIt<ProfileCubit>().getUserProfileById(userId: uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ListTile(title: Text(AppStrings.loadingMessage));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return UserTileUnit(user: user);
            } else {
              return const ListTile(
                title: Text(
                  AppStrings.userNotFoundMessage,
                ),
              );
            }
          },
        );
      },
    );
  }
}
