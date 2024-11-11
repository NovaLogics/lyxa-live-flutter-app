import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:lyxa_live/features/profile/presentation/components/bio_box_unit.dart';
import 'package:lyxa_live/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:lyxa_live/features/profile/presentation/cubits/profile_state.dart';
import 'package:lyxa_live/features/profile/presentation/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // Current user
  late AppUser? currentUser = authCubit.currentUser;

  // On Startup
  @override
  void initState() {
    super.initState();

    // Load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // Loaded
        if (state is ProfileLoaded) {
          final user = state.profileUser;
          if (kDebugMode) {
            print(user);
          }

          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text(user.name)),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                                  user: user,
                                ))),
                    icon: const Icon(
                      Icons.settings,
                    ))
              ],
            ),
            body: Column(
              children: [
                Center(
                  child: Text(
                    user.email,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 25),
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  // Loading
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  // Error -> Failed to load
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  errorListener: (value) => ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value.toString()))),

                  // Loaded
                  imageBuilder: (context, imageProvider) => Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        'Bio',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                BioBoxUnit(
                  text: user.bio,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25.0),
                  child: Row(
                    children: [
                      Text(
                        'Posts',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        // Loading
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Other conditions
        else {
          return const Center(
            child: Text("No profile found..."),
          );
        }
      },
    );
  }
}
