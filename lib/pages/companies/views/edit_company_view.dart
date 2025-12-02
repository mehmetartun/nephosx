import 'package:flutter/material.dart';
import 'package:nephosx/widgets/company_info_card.dart';
import 'package:nephosx/widgets/dialogs/add_edit_address_dialog.dart';
import 'package:nephosx/widgets/formfields/address_form_field.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/address.dart';
import '../../../model/company.dart';
import '../../../model/user.dart';
import '../../../widgets/dialogs/add_edit_company_dialog.dart';
import '../../../widgets/property_badge.dart';

class EditCompanyView extends StatefulWidget {
  final Company company;
  final List<User> users;
  final void Function(Company company) onUpdateCompany;
  final void Function(Company, Address, int)? onAddressUpdate;
  final void Function(Company, Address)? onAddressAdd;
  final void Function(User user)? setPrimaryContact;
  const EditCompanyView({
    super.key,
    required this.company,
    required this.onUpdateCompany,
    this.onAddressUpdate,
    this.onAddressAdd,
    required this.users,
    this.setPrimaryContact,
  });

  @override
  _EditCompanyViewState createState() => _EditCompanyViewState();
}

class _EditCompanyViewState extends State<EditCompanyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar(title: const Text("Edit Company")),
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverToBoxAdapter(
              child: MaxWidthBox(
                alignment: Alignment.topLeft,
                maxWidth: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "${widget.company.name}",
                    //   style: Theme.of(context).textTheme.headlineMedium,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Company Information",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        TextButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AddEditCompanyDialog(
                                  company: widget.company,
                                  onUpdateCompany: widget.onUpdateCompany,
                                );
                              },
                            );
                          },
                          child: Text("Update"),
                        ),
                      ],
                    ),
                    CompanyInfoCard(company: widget.company),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Addresses",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => MaxWidthBox(
                                maxWidth: 500,
                                child: AddEditAddressDialog(
                                  onAddAddress: (address) {
                                    widget.onAddressAdd!(
                                      widget.company,
                                      address,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          label: Text("Add"),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.company.addresses.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.company.addresses[index].toString()),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => MaxWidthBox(
                                    maxWidth: 500,
                                    child: AddEditAddressDialog(
                                      onUpdateAddress: (address) {
                                        widget.onAddressUpdate!(
                                          widget.company,
                                          address,
                                          index,
                                        );
                                      },
                                      address: widget.company.addresses[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Users",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(widget.users[index].displayName ?? "--"),
                          subtitle: Text(widget.users[index].email ?? "--"),
                          trailing:
                              widget.users[index].uid ==
                                  widget.company.primaryContactId
                              ? const PropertyBadge(text: "Primary")
                              : widget.setPrimaryContact != null
                              ? FilledButton.tonal(
                                  child: Text("Set"),
                                  onPressed: () {
                                    widget.setPrimaryContact!(
                                      widget.users[index],
                                    );
                                  },
                                )
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
