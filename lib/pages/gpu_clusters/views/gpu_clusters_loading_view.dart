import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';

class GpuClustersLoadingView extends StatelessWidget {
  const GpuClustersLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        highlightColor: Theme.of(context).colorScheme.surfaceContainer,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: MaxWidthBox(
                maxWidth: 1100,
                child: FittedBox(
                  child: SizedBox(
                    width: 1100,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          // Header
                          Row(
                            children: [
                              Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Filters
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 60,
                                          height: 20,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                // Dropdowns Row
                                SizedBox(
                                  height: 90,
                                  child: Row(
                                    children: List.generate(5, (index) {
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 20.0,
                                          ),
                                          child: Container(
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                // Date Pickers Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(child: Container()),
                                    SizedBox(width: 20),
                                    Expanded(child: Container()),
                                    SizedBox(width: 20),
                                    Expanded(child: Container()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          // Table
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Table Header
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 15.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(12, (index) {
                                      return Expanded(
                                        child: Container(
                                          height: 20,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                Divider(height: 1),
                                // Table Body
                                ...List.generate(10, (index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                          vertical: 12.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(12, (
                                            colIndex,
                                          ) {
                                            return Expanded(
                                              child: Container(
                                                height: 16,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                ),
                                                color: Colors.white,
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      if (index < 9) Divider(height: 1),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
