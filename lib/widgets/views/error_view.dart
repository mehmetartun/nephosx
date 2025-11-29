import 'package:flutter/material.dart';

import '../../model/consideration.dart';
import '../../model/enums.dart';
import '../../model/gpu_transaction.dart';
import '../occupation_view_paint.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final void Function()? onRetry;
  const ErrorView({
    super.key,
    required this.title,
    this.message = "Error...",
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
              if (onRetry != null) ...[
                SizedBox(height: 20),
                ElevatedButton(onPressed: onRetry, child: Text("Retry")),
              ],
              OccupationView(
                fromDate: DateTime.now(),
                toDate: DateTime.now().add(Duration(days: 3650)),
                transactions: [
                  GpuTransaction(
                    id: "1",
                    buyerCompanyId: "1",
                    gpuClusterId: "1",
                    sellerCompanyId: "1",
                    createdAt: DateTime.now(),
                    startDate: DateTime.now().add(Duration(days: 100)),
                    endDate: DateTime.now().add(Duration(days: 200)),
                    consideration: Consideration(
                      amount: 1,
                      currency: Currency.usd,
                    ),
                    datacenterId: "1",
                  ),
                  GpuTransaction(
                    id: "1",
                    buyerCompanyId: "1",
                    gpuClusterId: "1",
                    sellerCompanyId: "1",
                    createdAt: DateTime.now(),
                    startDate: DateTime.now().add(Duration(days: 340)),
                    endDate: DateTime.now().add(Duration(days: 442)),
                    consideration: Consideration(
                      amount: 1,
                      currency: Currency.usd,
                    ),
                    datacenterId: "1",
                  ),
                  GpuTransaction(
                    id: "1",
                    buyerCompanyId: "1",
                    gpuClusterId: "1",
                    sellerCompanyId: "1",
                    createdAt: DateTime.now(),
                    startDate: DateTime.now().add(Duration(days: 500)),
                    endDate: DateTime.now().add(Duration(days: 600)),
                    consideration: Consideration(
                      amount: 1,
                      currency: Currency.usd,
                    ),
                    datacenterId: "1",
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
