import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nephosx/widgets/brightness_selector.dart';

import '../blocs/authentication/authentication_bloc.dart';
import 'user_list_tile.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final StatefulNavigationShell? navigationShell;
  final bool hasLogout;

  const TopBar({
    super.key,
    required this.title,
    this.height = 80.0,
    this.navigationShell,
    this.hasLogout = false, // Default custom height
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
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        // color: Theme.of(context).colorScheme.surfaceContainer,
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
              // Image.asset('assets/images/nephosx2/nephosx.png', height: 70),
              Text(
                "NephosX",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user!.canSeeUsers) ...[
                    navigationShell?.currentIndex == 0
                        ? FilledButton(
                            onPressed: () {
                              navigationShell?.goBranch(0);
                            },
                            child: const Text("Users"),
                          )
                        : TextButton(
                            onPressed: () {
                              navigationShell?.goBranch(0);
                            },
                            child: const Text("Users"),
                          ),
                  ],

                  if (user!.canSeeCompanies) ...[
                    navigationShell?.currentIndex == 1
                        ? FilledButton(
                            onPressed: () {
                              navigationShell?.goBranch(1);
                            },
                            child: const Text("Companies"),
                          )
                        : TextButton(
                            onPressed: () {
                              navigationShell?.goBranch(1);
                            },
                            child: const Text("Companies"),
                          ),
                  ],
                  if (user!.canSeeDatacenters) ...[
                    navigationShell?.currentIndex == 2
                        ? FilledButton(
                            onPressed: () {
                              navigationShell?.goBranch(2);
                            },
                            child: const Text("Datacenters"),
                          )
                        : TextButton(
                            onPressed: () {
                              navigationShell?.goBranch(2);
                            },
                            child: const Text("Datacenters"),
                          ),
                  ],
                  if (user!.canSeeGpuClusters) ...[
                    navigationShell?.currentIndex == 3
                        ? FilledButton(
                            onPressed: () {
                              navigationShell?.goBranch(3);
                            },
                            child: const Text("GPU Clusters"),
                          )
                        : TextButton(
                            onPressed: () {
                              navigationShell?.goBranch(3);
                            },
                            child: const Text("GPU Clusters"),
                          ),
                  ],
                  if (user!.canSeeMarketplace) ...[
                    navigationShell?.currentIndex == 4
                        ? FilledButton(
                            onPressed: () {
                              navigationShell?.goBranch(4);
                            },
                            child: const Text("Market"),
                          )
                        : TextButton(
                            onPressed: () {
                              navigationShell?.goBranch(4);
                            },
                            child: const Text("Market"),
                          ),
                  ],
                  if (user!.canSeeSettings) ...[
                    navigationShell?.currentIndex == 5
                        ? FilledButton(
                            onPressed: () {
                              navigationShell?.goBranch(5);
                            },
                            child: const Text("Settings"),
                          )
                        : TextButton(
                            onPressed: () {
                              navigationShell?.goBranch(5);
                            },
                            child: const Text("Settings"),
                          ),
                  ],
                  if (user.canSeeTransactions) ...[
                    navigationShell?.currentIndex == 6
                        ? FilledButton(
                            onPressed: () {
                              navigationShell?.goBranch(6);
                            },
                            child: const Text("Transactions"),
                          )
                        : TextButton(
                            onPressed: () {
                              navigationShell?.goBranch(6);
                            },
                            child: const Text("Transactions"),
                          ),
                  ],
                  if (user.canSeeAdmin) ...[
                    navigationShell?.currentIndex == 7
                        ? FilledButton(
                            onPressed: () {
                              navigationShell?.goBranch(7);
                            },
                            child: const Text("Admin"),
                          )
                        : TextButton(
                            onPressed: () {
                              navigationShell?.goBranch(7);
                            },
                            child: const Text("Admin"),
                          ),
                  ],
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BrightnessSelector(shouldPop: false, narrow: true),
                  if (hasLogout)
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(
                          context,
                        ).add(AuthenticationEventSignOut());
                      },
                    ),
                ],
              ),
              // if (user != null)
              //   SizedBox(
              //     width: 300,
              //     child: UserListTile(
              //       user: user,
              //       alignment: UserListTileAlignment.right,
              //       // trailing: user.company == null
              //       //     ? null
              //       //     : Chip(label: Text(user.company!.name)),
              //     ),
              //   ),
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
