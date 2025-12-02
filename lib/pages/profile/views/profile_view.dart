import 'package:nephosx/blocs/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
// import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

import '../../../model/address.dart';
import '../../../model/user.dart';
import '../../../widgets/dialogs/add_edit_address_dialog.dart';
import '../../../widgets/user_card.dart';

class ProfileView extends StatelessWidget {
  final User user;
  final void Function() editProfile;
  const ProfileView({
    super.key,
    required this.user,
    required this.editProfile,
    required this.onAddressUpdate,
  });
  final void Function(User, Address) onAddressUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: const Text('Profile'),
      //   actions: [
      //     IconButton(icon: const Icon(Icons.edit), onPressed: editProfile),
      //     IconButton(
      //       icon: const Icon(Icons.logout),
      //       onPressed: () {
      //         BlocProvider.of<AuthenticationBloc>(
      //           context,
      //         ).add(AuthenticationEventSignOut());
      //       },
      //     ),
      //   ],
      // ),
      body: MaxWidthBox(
        maxWidth: 400,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Profile',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: editProfile,
                ),
              ],
            ),
            UserCard(user: user, minRadius: 70),
            SizedBox(height: 20),
            Text('Address', style: Theme.of(context).textTheme.headlineSmall),
            user.address == null
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => MaxWidthBox(
                          maxWidth: 500,
                          child: AddEditAddressDialog(
                            onUpdateAddress: (address) {
                              onAddressUpdate(user, address);
                            },
                            onAddAddress: (address) {
                              onAddressUpdate(user, address);
                            },
                            address: user.address,
                          ),
                        ),
                      );
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(user.address!.toString()),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => MaxWidthBox(
                              maxWidth: 500,
                              child: AddEditAddressDialog(
                                onUpdateAddress: (address) {
                                  onAddressUpdate(user, address);
                                },
                                address: user.address,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
