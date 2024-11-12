import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/profile/presentation/components/user_tile_unit.dart';
import 'package:lyxa_live/src/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/presentation/screens/profile_screen.dart';
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
        //App Bar
        appBar: AppBar(
          // Tab Bar
          bottom: TabBar(
              dividerColor: Colors.transparent,
              labelColor: Theme.of(context).colorScheme.inversePrimary,
              tabs: const [
                Tab(text: 'Followers'),
                Tab(text: 'Following'),
              ]),
        ),

        // Tab Bar View
        body: TabBarView(children: [
          _buildUserList(followers, "No followers", context),
          _buildUserList(following, "No following", context),
        ]),
      ),
    );
  }

  // Build user list, given a list of profile uids
  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(
            child: Text(emptyMessage),
          )
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              // Get each uid
              final uid = uids[index];

              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  // User loaded
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return UserTileUnit(user: user);
                  }
                  // Loading
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  // Not found
                  else {
                    return ListTile(
                      title: Text('User not found...'),
                    );
                  }
                },
              );
            },
          );
  }
}
