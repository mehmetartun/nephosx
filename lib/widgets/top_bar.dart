import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/widgets/brightness_selector.dart';

import '../blocs/authentication/authentication_bloc.dart';
import 'user_list_tile.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  const TopBar({
    super.key,
    required this.title,
    this.height = 80.0, // Default custom height
  });

  // 2. Override the preferredSize getter
  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // 3. Build your custom UI
    final user = BlocProvider.of<AuthenticationBloc>(context).user;
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        // Example: A nice gradient background
        // gradient: LinearGradient(
        //   colors: [Colors.indigo, Colors.black],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        // boxShadow: [
        //   BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2)),
        // ],
        // borderRadius: BorderRadius.vertical(
        //   bottom: Radius.circular(20), // Curved bottom edges
        // ),
      ),
      child: SafeArea(
        // SafeArea is crucial to avoid the notch/status bar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/nephosx2/nephosx.png', height: 70),
              if (user != null)
                SizedBox(
                  width: 300,
                  child: UserListTile(
                    user: user,
                    alignment: UserListTileAlignment.right,
                    // trailing: user.company == null
                    //     ? null
                    //     : Chip(label: Text(user.company!.name)),
                  ),
                ),
              // BrightnessSelector(shouldPop: false),
              // IconButton(
              //   icon: const Icon(Icons.menu, color: Colors.white),
              //   onPressed: () {},
              // ),
              // Text(
              //   title,
              //   style: const TextStyle(
              //     color: Colors.white,
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // IconButton(
              //   icon: const Icon(Icons.search, color: Colors.white),
              //   onPressed: () {},
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
