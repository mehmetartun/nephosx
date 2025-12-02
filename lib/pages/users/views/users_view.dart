import 'package:flutter/material.dart';
import 'package:nephosx/widgets/dialogs/update_user_company_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/company.dart';
import '../../../model/enums.dart';
import '../../../model/user.dart';
import '../../../widgets/user_list_tile.dart';

class UsersView extends StatelessWidget {
  const UsersView({
    Key? key,
    required this.users,
    required this.companies,
    required this.onUpdateUser,
  }) : super(key: key);
  final List<User> users;
  final List<Company> companies;
  final void Function(Company, User) onUpdateUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MaxWidthBox(
          alignment: Alignment.topLeft,
          maxWidth: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Users",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Expanded(
                child: ListView(
                  children: users
                      .map(
                        (user) => UserListTile(
                          user: user,
                          trailing: user.type == UserType.admin
                              ? null
                              : user.getCompany(companies) == null
                              ? FilledButton(
                                  child: Text("Add"),
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return UpdateUserCompanyDialog(
                                          onUpdateUser: onUpdateUser,
                                          user: user,
                                          companies: companies,
                                        );
                                      },
                                    );
                                  },
                                )
                              : Text(
                                  user
                                          .getCompany(companies)
                                          ?.name
                                          .toUpperCase() ??
                                      "COMPANY",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
