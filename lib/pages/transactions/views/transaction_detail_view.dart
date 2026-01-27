import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/model/key_value_pair.dart';
import 'package:nephosx/repositories/database/database.dart';
import 'package:nephosx/widgets/gpu_property_list.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:nephosx/model/file_data.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/gpu_transaction.dart';
import '../../../repositories/storage/storage_repository.dart';

class TransactionDetailView extends StatefulWidget {
  const TransactionDetailView({
    super.key,
    required this.transaction,
    required this.onCancel,
  });
  final GpuTransaction transaction;
  final Function() onCancel;

  @override
  State<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  final StorageRepository _storageRepository = StorageRepository();
  bool _isUploading = false;

  Future<void> _uploadDocument() async {
    try {
      final file = await _storageRepository.pickFile();
      if (file != null) {
        setState(() => _isUploading = true);
        final url = await _storageRepository.uploadFile(
          path: "transactions/${widget.transaction.id}",
          file: file,
        );
        if (mounted) {
          if (url != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document uploaded successfully')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to upload document')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _downloadDocument(FileData document) async {
    try {
      final url = await _storageRepository.getDownloadURL(document.path);
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch document URL')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading document: $e')),
        );
      }
    }
  }

  late GpuTransaction _transaction;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _transaction = widget.transaction;
    _subscription = FirebaseFirestore.instance
        .collection("transactions")
        .doc(_transaction.id)
        .snapshots()
        .listen((qs) {
          print("qs transaction received");
          if (qs.exists) {
            setState(() {
              _transaction = GpuTransaction.fromJson({
                ...qs.data()!,
                "id": qs.id,
              });
              print("transaction received");
            });
          }
        });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: MaxWidthBox(
          maxWidth: 1000,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Transaction Detail",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Spacer(),
                  OutlinedButton.icon(
                    label: Text("Close"),
                    icon: Icon(Icons.close),
                    onPressed: widget.onCancel,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                direction: Axis.horizontal,
                spacing: 20,
                runSpacing: 20,
                children: [
                  GpuPropertyList(
                    title: "Documents",
                    titleWidget: OutlinedButton.icon(
                      icon: Icon(Icons.upload),
                      onPressed: _isUploading ? null : _uploadDocument,
                      label: _isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            )
                          : const Text("Upload PDF"),
                    ),
                    properties: _transaction.documents
                        .map(
                          (e) => KeyValuePair(
                            key: e.description ?? e.name,
                            // keyWidget: Row(
                            //   children: [
                            //     IconButton(
                            //       icon: Icon(Icons.edit),
                            //       onPressed: () {},
                            //     ),
                            //     SizedBox(width: 5),
                            //     Expanded(child: Text(e.name)),
                            //   ],
                            // ),
                            value: "Download",
                            valueWidget: IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () {
                                _downloadDocument(e);
                              },
                            ),
                            // onTap: () => _downloadDocument(e),
                          ),
                        )
                        .toList(),
                  ),
                  GpuPropertyList(
                    title: "Parties",
                    properties: [
                      KeyValuePair(
                        key: "Buyer",
                        value: _transaction.buyerCompany?.name ?? "",
                      ),
                      KeyValuePair(
                        key: "Seller",
                        value: _transaction.sellerCompany?.name ?? "",
                      ),
                    ],
                  ),
                  GpuPropertyList(
                    title: "Transaction",
                    properties: [
                      KeyValuePair(
                        key: "Start Date",
                        value: DateFormat(
                          'yyyy-MM-dd',
                        ).format(_transaction.startDate),
                      ),
                      KeyValuePair(
                        key: "End Date",
                        value: DateFormat(
                          'yyyy-MM-dd',
                        ).format(_transaction.endDate),
                      ),
                      KeyValuePair(
                        key: "Consideration",
                        value: _transaction.consideration.formatted,
                      ),
                      KeyValuePair(
                        key: "Hourly Rate",
                        value: _transaction.hourlyRate.formatted,
                      ),
                    ],
                  ),
                  GpuPropertyList(
                    title: "GPU Cluster",
                    properties: [
                      KeyValuePair(
                        key: "GPU Model",
                        value: _transaction.gpuCluster?.device?.name ?? "",
                      ),
                      KeyValuePair(
                        key: "Quantity",
                        value:
                            _transaction.gpuCluster?.quantity.toString() ?? "",
                      ),
                      KeyValuePair(
                        key: "Serial Number",
                        value: _transaction.gpuCluster?.serialNumber ?? "",
                      ),
                      KeyValuePair(
                        key: "Asset Tag",
                        value: _transaction.gpuCluster?.assetTag ?? "",
                      ),
                      KeyValuePair(
                        key: "Datacenter",
                        value: _transaction.datacenter?.name ?? "",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
