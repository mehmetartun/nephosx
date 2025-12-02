import 'package:flutter/material.dart';
import 'package:nephosx/model/company.dart';

class CompanyListTile extends StatelessWidget {
  const CompanyListTile({super.key, required this.company});
  final Company company;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.domain),
      title: Text(company.name),
      subtitle: company.hasAddress
          ? Text(
              "${company.addresses[0].city}, ${company.addresses[0].country.description}",
            )
          : null,
    );
  }
}
