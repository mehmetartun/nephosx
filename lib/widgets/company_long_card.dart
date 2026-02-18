import 'package:flutter/material.dart';

import '../model/company.dart';

class CompanyLongCard extends StatelessWidget {
  const CompanyLongCard({super.key, required this.company});
  final Company company;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: [
            Text(company.name),
            Text(company.domain ?? ''),
            Text(company.confirmationEmail ?? ''),
          ],
        ),
      ),
    );
  }
}
