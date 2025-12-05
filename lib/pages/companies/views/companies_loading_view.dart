import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';

class CompaniesLoadingView extends StatelessWidget {
  const CompaniesLoadingView({super.key});

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
                    "All Companies",
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
              SizedBox(height: 20),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainer,
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(height: 20),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                        title: Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                        subtitle: Container(
                          width: 150,
                          height: 12,
                          color: Colors.white,
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
