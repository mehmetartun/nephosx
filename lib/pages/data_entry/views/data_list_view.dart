import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import '../../../model/drink_image.dart';
import '../../../navigation/my_navigator_route.dart';

class DataListView extends StatelessWidget {
  final List<DrinkImage> images;
  final void Function(DrinkImage) selectItem;
  final void Function() refresh;
  final void Function() drinksList;
  const DataListView({
    super.key,
    required this.images,
    required this.selectItem,
    required this.refresh,
    required this.drinksList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image List'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: refresh),
          IconButton(icon: const Icon(Icons.list), onPressed: drinksList),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              context.goNamed(MyNavigatorRoute.profile.name);
            },
          ),
        ],
      ),
      body: ListView(
        children: images.map((image) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              // Decode the base64 string into a Uint8List for Image.memory
              leading: Image.memory(base64Decode(image.imageBase64)),
              title: Text(image.fileName),
              onTap: () {
                selectItem(image);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
