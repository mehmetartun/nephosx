import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/model/enums.dart';
import 'package:nephosx/widgets/dialogs/add_edit_company_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/request.dart';
import '../../../widgets/dialogs/admin_add_company_dialog.dart';

class AdminOnboardingRequestView extends StatefulWidget {
  const AdminOnboardingRequestView({
    super.key,
    required this.request,
    required this.onAddCompany,
    required this.onRejectRequest,
    required this.onCancel,
    this.error,
  });
  final Request request;
  final void Function({
    required String companyName,
    required String companyDomain,
    required String confirmationEmail,
    required String userId,
  })
  onAddCompany;
  final void Function() onRejectRequest;
  final void Function() onCancel;
  final String? error;

  @override
  State<AdminOnboardingRequestView> createState() =>
      _AdminOnboardingRequestViewState();
}

class _AdminOnboardingRequestViewState
    extends State<AdminOnboardingRequestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SingleChildScrollView(
          child: MaxWidthBox(
            maxWidth: 600,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.arrow_back),
                    label: Text("Back"),
                    onPressed: () {
                      widget.onCancel();
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.request.type.description,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  if (widget.error != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.error!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  DataTable(
                    columns: [
                      DataColumn(label: Text('Property')),
                      DataColumn(label: Text('Value')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text("Request Date")),
                          DataCell(
                            Text(
                              DateFormat(
                                'yyyy-MM-dd',
                              ).format(widget.request.requestDate),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Company Name")),
                          DataCell(Text(widget.request.data['company_name'])),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Domain")),
                          DataCell(Text(widget.request.data['company_domain'])),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Phone")),
                          DataCell(Text(widget.request.data['company_phone'])),
                        ],
                      ),
                      // DataRow(
                      //   cells: [
                      //     DataCell(Text("User")),
                      //     DataCell(
                      //       Text(widget.request.data['user']['display_name']),
                      //     ),
                      //   ],
                      // ),
                      DataRow(
                        cells: [
                          DataCell(Text("Requestor Email")),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(widget.request.data['user']['email']),
                                if (widget.request.data['user']['email']
                                        .split('@')
                                        .last ==
                                    widget.request.data['company_domain']) ...[
                                  SizedBox(width: 8),
                                  Tooltip(
                                    message:
                                        "The requested domain matches\nuser's email domain.",
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Requestor Display Name")),
                          DataCell(
                            Text(
                              widget.request.data['user']['display_name'] ??
                                  "--",
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Requestor First Name")),
                          DataCell(
                            Text(
                              widget.request.data['user']['first_name'] ?? "--",
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Requestor Last Name")),
                          DataCell(
                            Text(
                              widget.request.data['user']['last_name'] ?? "--",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (widget.request.status == RequestStatus.pending) ...[
                    FilledButton(
                      child: Text("Create Company"),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            print(widget.request.data);
                            return AdminAddCompanyDialog(
                              userId: widget.request.data['requesting_user_id'],

                              companyName: widget.request.data['company_name'],
                              companyDomain:
                                  widget.request.data['company_domain'],
                              confirmationEmail:
                                  widget.request.data['user']['email'],
                              onAddCompany: widget.onAddCompany,
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    if (widget.request.status == RequestStatus.pending) ...[
                      FilledButton(
                        child: Text("Reject"),
                        onPressed: () async {
                          bool? res = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Reject Request"),
                                content: Text(
                                  "Are you sure you want to reject this request?",
                                ),
                                actions: [
                                  FilledButton(
                                    child: Text("Reject"),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                  ),
                                  OutlinedButton(
                                    child: Text("Cancel"),
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                  ),
                                ],
                              );
                            },
                          );
                          if (res == true) {
                            widget.onRejectRequest();
                          }
                        },
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
