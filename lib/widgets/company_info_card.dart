import 'package:flutter/material.dart';
import 'package:nephosx/model/company.dart';
import 'package:nephosx/widgets/company_onboarding_status.dart';
import 'package:nephosx/widgets/dialogs/add_edit_company_dialog.dart';

import '../model/light_label.dart';
import 'dialogs/edit_company_dialog.dart';

class CompanyInfoCard extends StatelessWidget {
  const CompanyInfoCard({
    super.key,
    required this.company,
    // this.onUpdateCompany,
  });
  final Company company;
  // final void Function(Company)? onUpdateCompany;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (onUpdateCompany != null)
        //
        LightLabel(text: "Name*"),
        Text(company.name, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 10),
        LightLabel(text: "Business Tax ID*"),
        Text(
          company.businessTaxId ?? "--",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 10),
        LightLabel(text: "Business DUNS Number*"),
        Text(
          company.businessTaxId ?? "--",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 10),
        LightLabel(text: "Confirmation Email*"),
        Text(
          company.confirmationEmail ?? "--",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 10),
        LightLabel(text: "Status"),
        Row(
          children: [
            Text(
              "Buyer: ${company.isBuyer ?? 'Unknown'}  Seller: ${company.isSeller ?? 'Unknown'} ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        SizedBox(height: 10),
        CompanyOnboardingStatus(company: company),
        // if (company.hasAddress) ...[
        //   SizedBox(height: 10),
        //   Text("City", style: Theme.of(context).textTheme.labelSmall),
        //   Text(
        //     company.addresses[0].city,
        //     style: Theme.of(context).textTheme.bodyMedium,
        //   ),
        //   SizedBox(height: 10),
        //   Text("Country", style: Theme.of(context).textTheme.labelSmall),
        //   Text(
        //     company.addresses[0].country.description,
        //     style: Theme.of(context).textTheme.bodyMedium,
        //   ),
        // ],
      ],
    );
  }
}
