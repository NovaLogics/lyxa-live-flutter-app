import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lyxa_live/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/features/profile/presentation/screens/profile_screen.dart';

class UserTileUnit extends StatelessWidget {
  final ProfileUser user;

  const UserTileUnit({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      subtitleTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.normal,
      ),
      leading: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.primary,
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(uid: user.uid),
          )),
    );
  }
}
