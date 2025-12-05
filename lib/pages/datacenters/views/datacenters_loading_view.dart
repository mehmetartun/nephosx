import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';

class DatacentersLoadingView extends StatelessWidget {
  const DatacentersLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MaxWidthBox(
          alignment: Alignment.topCenter,
          maxWidth: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Datacenters",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  // Add button placeholder
                  Shimmer.fromColors(
                    baseColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHigh,
                    highlightColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainer,
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              // Sort by row placeholder
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainer,
                  child: Row(
                    children: [
                      Container(width: 60, height: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Container(width: 100, height: 30, color: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainer,
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(height: 10),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        title: Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                        subtitle: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Container(
                              width: 100,
                              height: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        trailing: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
