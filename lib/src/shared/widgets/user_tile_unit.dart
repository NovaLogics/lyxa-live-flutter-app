import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/profile_screen.dart';

class UserTileUnit extends StatelessWidget {
  final ProfileUser user;

  const UserTileUnit({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        user.name,
        style: AppStyles.textStylePost.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        user.email,
        style: AppStyles.subtitlePrimary.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
          fontWeight: FontWeight.bold,
          fontFamily: FONT_MONTSERRAT,
          fontSize: AppDimens.fontSizeSM12,
          shadows: AppStyles.shadowStyle2,
        ),
      ),
      leading: Icon(
        Icons.person_rounded,
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
