import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nephosx/widgets/brightness_selector.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../model/enums.dart';
import 'user_avatar.dart';

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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image.asset('assets/images/nephosx2/nephosx.png', height: 70),
              Text(
                "NephosX",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  // fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  child: OverflowBar(
                    // mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      // if (user!.canSeeUsers) ...[
                      //   navigationShell?.currentIndex == 0
                      //       ? FilledButton(
                      //           onPressed: () {
                      //             navigationShell?.goBranch(0);
                      //           },
                      //           child: const Text("Users"),
                      //         )
                      //       : TextButton(
                      //           onPressed: () {
                      //             navigationShell?.goBranch(0);
                      //           },
                      //           child: const Text("Users"),
                      //         ),
                      // ],

                      // if (user!.canSeeCompanies) ...[
                      //   navigationShell?.currentIndex == 1
                      //       ? FilledButton(
                      //           onPressed: () {
                      //             navigationShell?.goBranch(1);
                      //           },
                      //           child: const Text("Companies"),
                      //         )
                      //       : TextButton(
                      //           onPressed: () {
                      //             navigationShell?.goBranch(1);
                      //           },
                      //           child: const Text("Companies"),
                      //         ),
                      // ],
                      // if (user!.canSeeDatacenters) ...[
                      //   navigationShell?.currentIndex == 2
                      //       ? FilledButton(
                      //           onPressed: () {
                      //             navigationShell?.goBranch(2);
                      //           },
                      //           child: const Text("Datacenters"),
                      //         )
                      //       : TextButton(
                      //           onPressed: () {
                      //             navigationShell?.goBranch(2);
                      //           },
                      //           child: const Text("Datacenters"),
                      //         ),
                      // ],
                      // if (user!.canSeeGpuClusters) ...[
                      //   navigationShell?.currentIndex == 3
                      //       ? FilledButton(
                      //           onPressed: () {
                      //             navigationShell?.goBranch(3);
                      //           },
                      //           child: const Text("GPU Clusters"),
                      //         )
                      //       : TextButton(
                      //           onPressed: () {
                      //             navigationShell?.goBranch(3);
                      //           },
                      //           child: const Text("GPU Clusters"),
                      //         ),
                      // ],
                      if (user!.canSeeMarketplace) ...[
                        navigationShell?.currentIndex == 4
                            ? FilledButton.icon(
                                onPressed: () {
                                  navigationShell?.goBranch(4);
                                },
                                icon: Icon(Icons.shopping_cart),
                                label: const Text("Market"),
                              )
                            : TextButton.icon(
                                onPressed: () {
                                  navigationShell?.goBranch(4);
                                },
                                icon: Icon(Icons.shopping_cart),
                                label: const Text("Market"),
                              ),
                      ],
                      if (user.canSeeCorporateAdmin) ...[
                        navigationShell?.currentIndex == 9
                            ? FilledButton.icon(
                                onPressed: () {
                                  // navigationShell?.goBranch(7);
                                  // context.go("/admin/data");
                                },
                                icon: Icon(Icons.developer_board),
                                label: const Text("My GPUs"),
                              )
                            : TextButton.icon(
                                onPressed: () {
                                  context.goNamed("listing");
                                  // navigationShell?.goBranch(7);
                                },
                                icon: Icon(Icons.developer_board),
                                label: const Text("My GPUs"),
                              ),
                      ],

                      if (user.type == UserType.public) ...[
                        navigationShell?.currentIndex == 1
                            ? FilledButton(
                                onPressed: () {
                                  // navigationShell?.goBranch(1);
                                },
                                child: const Text("Company"),
                              )
                            : TextButton(
                                onPressed: () {
                                  navigationShell?.goBranch(1);
                                },
                                child: const Text("Company"),
                              ),
                      ],

                      if (user.canSeeTransactions) ...[
                        navigationShell?.currentIndex == 6
                            ? FilledButton.icon(
                                onPressed: () {
                                  navigationShell?.goBranch(6);
                                },
                                icon: Icon(Icons.text_snippet),
                                label: const Text("Transactions"),
                              )
                            : TextButton.icon(
                                onPressed: () {
                                  navigationShell?.goBranch(6);
                                },
                                icon: Icon(Icons.text_snippet),
                                label: const Text("Transactions"),
                              ),
                      ],
                      if (user.canSeeAdmin) ...[
                        navigationShell?.currentIndex == 7
                            ? FilledButton.icon(
                                onPressed: () {
                                  // navigationShell?.goBranch(7);
                                  // context.go("/admin/data");
                                },
                                icon: Icon(Icons.star),
                                label: const Text("Admin"),
                              )
                            : TextButton.icon(
                                onPressed: () {
                                  context.go("/admin/data");
                                  // navigationShell?.goBranch(7);
                                },
                                icon: Icon(Icons.star),
                                label: const Text("Admin"),
                              ),
                      ],
                      if (user.canSeeCorporateAdmin) ...[
                        navigationShell?.currentIndex == 8
                            ? FilledButton.icon(
                                onPressed: () {
                                  // navigationShell?.goBranch(7);
                                  // context.go("/admin/data");
                                },
                                icon: Icon(Icons.star),
                                label: const Text("Admin"),
                              )
                            : TextButton.icon(
                                onPressed: () {
                                  context.goNamed("corp_admin_users");
                                  // navigationShell?.goBranch(7);
                                },
                                icon: Icon(Icons.star),
                                label: const Text("Admin"),
                              ),
                      ],
                      // if (user.canSeeSettings) ...[
                      //   navigationShell?.currentIndex == 5
                      //       ? FilledButton(
                      //           onPressed: () {
                      //             navigationShell?.goBranch(5);
                      //           },
                      //           child: const Text("Settings"),
                      //         )
                      //       : user.emailVerified == false
                      //       ? TextButton.icon(
                      //           icon: Icon(
                      //             Icons.warning,
                      //             color: Theme.of(context).colorScheme.error,
                      //           ),
                      //           onPressed: () {
                      //             navigationShell?.goBranch(5);
                      //           },
                      //           label: const Text("Settings"),
                      //         )
                      //       : TextButton(
                      //           onPressed: () {
                      //             navigationShell?.goBranch(5);
                      //           },
                      //           child: const Text("Settings"),
                      //         ),
                      // ],
                    ],
                  ),
                ),
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ActionChip(
                    avatar: Icon(Icons.refresh),
                    label: Text('Last update 5s Ago'),
                    onPressed: () {},
                  ),
                  SizedBox(width: 10),
                  // if (user.canSeeSettings && navigationShell?.currentIndex == 5)
                  //   IconButton.filled(
                  //     icon: const Icon(Icons.settings),
                  //     onPressed: () {
                  //       navigationShell?.goBranch(5);
                  //     },
                  //   ),
                  // if (user.canSeeSettings && navigationShell?.currentIndex != 5)
                  //
                  if (user.canSeeSettings)
                    Stack(
                      children: [
                        IconButton.outlined(
                          icon: const Icon(Icons.settings),
                          style: IconButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                          onPressed: () {
                            navigationShell?.goBranch(5);
                          },
                        ),
                        // if (!user.emailVerified)
                        //   Positioned(
                        //     right: 3,
                        //     bottom: 6,
                        //     child: Icon(
                        //       Icons.warning,
                        //       color: Theme.of(context).colorScheme.error,
                        //       size: 12,
                        //     ),
                        //   ),
                      ],
                    ),
                  SizedBox(width: 10),
                  BrightnessSelector(shouldPop: false, narrow: true),
                  SizedBox(width: 10),
                  PopupMenuButton<String>(
                    tooltip: user.email ?? "User Menu",
                    offset: Offset(0, 50),
                    // This defines the look of the trigger
                    child: UserAvatar(user: user),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // This defines what happens when an item is selected
                    onSelected: (String value) {
                      switch (value) {
                        case 'profile':
                          // Navigate to settings
                          navigationShell?.goBranch(5);
                          break;
                        case 'logout':
                          AuthenticationBloc authenticationBloc =
                              BlocProvider.of<AuthenticationBloc>(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Confirm Logout"),
                                content: const Text(
                                  "Are you sure you want to log out?",
                                ),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      authenticationBloc.add(
                                        AuthenticationEventSignOut(),
                                      );
                                    },
                                    child: const Text("Logout"),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              );
                            },
                          );
                          break;
                      }
                    },
                    // This builds the actual menu items
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'profile',
                        child: ListTile(
                          leading: Icon(Icons.person_outline),
                          title: Text('Profile'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),

                  // if (hasLogout)
                  //   Stack(
                  //     children: [
                  //       IconButton(
                  //         icon: const Icon(Icons.logout),
                  //         onPressed: () {
                  //           AuthenticationBloc authenticationBloc =
                  //               BlocProvider.of<AuthenticationBloc>(context);
                  //           showDialog(
                  //             context: context,
                  //             builder: (context) {
                  //               return AlertDialog(
                  //                 title: const Text("Confirm Logout"),
                  //                 content: const Text(
                  //                   "Are you sure you want to log out?",
                  //                 ),
                  //                 actions: [
                  //                   OutlinedButton(
                  //                     onPressed: () {
                  //                       Navigator.of(context).pop();
                  //                       authenticationBloc.add(
                  //                         AuthenticationEventSignOut(),
                  //                       );
                  //                     },
                  //                     child: const Text("Logout"),
                  //                   ),
                  //                   FilledButton(
                  //                     onPressed: () {
                  //                       Navigator.of(context).pop();
                  //                     },
                  //                     child: const Text("Cancel"),
                  //                   ),
                  //                 ],
                  //               );
                  //             },
                  //           );
                  //         },
                  //       ),
                  //     ],
                  //   ),
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
