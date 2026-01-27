import 'package:flutter/material.dart';
import 'package:nephosx/model/key_value_pair.dart';

class GpuPropertyList extends StatelessWidget {
  final String title;
  final List<KeyValuePair> properties;
  final double width;
  final Widget? titleWidget;
  const GpuPropertyList({
    super.key,
    required this.title,
    required this.properties,
    this.width = 300,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (titleWidget != null) titleWidget!,
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: InkWell(
                  onTap: properties[index].onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child:
                            properties[index].keyWidget ??
                            Text(
                              properties[index].key,
                              overflow: TextOverflow.clip,
                            ),
                      ),
                      SizedBox(width: 10),
                      properties[index].valueWidget ??
                          Text(properties[index].value),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(height: 5);
            },
            itemCount: properties.length,
          ),
        ],
      ),
    );
  }
}
