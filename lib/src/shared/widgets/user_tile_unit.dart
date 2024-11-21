import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/styles/app_text_styles.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
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
        style: AppTextStyles.textStylePost.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        user.email,
        style: AppTextStyles.subtitlePrimary.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.bold,
          fontFamily: FONT_MONTSERRAT,
          fontSize: AppDimens.textSizeSm12,
          shadows: AppTextStyles.shadowStyle2,
        ),
      ),
      subtitleTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.normal,
      ),
      leading: Icon(
        Icons.person_rounded,
        color: Theme.of(context).colorScheme.onPrimary,
        size: AppDimens.size36,
      ),
      // leading: CircleAvatar(
      //   backgroundImage: NetworkImage(user.profileImageUrl ?? ''),
      // ),
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(displayUserId: user.uid),
          )),
    );
  }
}
