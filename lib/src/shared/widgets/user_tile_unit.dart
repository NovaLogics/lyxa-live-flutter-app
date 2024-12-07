import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/features/profile/presentation/screens/profile_screen.dart';

class UserTileUnit extends StatelessWidget {
  final ProfileUserEntity user;

  const UserTileUnit({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        user.name,
        style: AppStyles.textTitlePost.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: AppDimens.letterSpacingPT03,
        ),
      ),
      subtitle: Text(
        user.email,
        style: AppStyles.labelPrimary.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      leading: Icon(
        Icons.person_pin,
        color: Theme.of(context).colorScheme.onSecondary,
        size: AppDimens.size36,
      ),
      // leading: CircleAvatar(
      //   backgroundImage: NetworkImage(user.profileImageUrl ?? ''),
      // ),
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.onPrimary,
      ),

      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(displayUserId: user.uid),
        ),
      ),
    );
  }
}
