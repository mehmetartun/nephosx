import 'dart:convert';

import 'package:nephosx/model/drink.dart';
import 'package:flutter/material.dart';

import '../../../model/drink_image.dart';
import '../../../model/enums.dart';

class DrinkEditView extends StatefulWidget {
  final DrinkImage drinkImage;
  final void Function(Drink) onSave;
  final void Function() onCancel;

  const DrinkEditView({
    super.key,
    required this.drinkImage,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<DrinkEditView> createState() => _DrinkEditViewState();
}

class _DrinkEditViewState extends State<DrinkEditView> {
  late final TextEditingController _descriptionController;
  String? description;
  DrinkType? drinkType;
  Set<ServingFormat> servingFormats = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Drink'),
        actions: [
          IconButton(icon: Icon(Icons.cancel), onPressed: widget.onCancel),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image.memory(
                    base64Decode(widget.drinkImage.imageBase64),
                  ),
                ),
                Text(widget.drinkImage.fileName),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (val) {
                    description = val;
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Description cannot be empty';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  items: DrinkType.values.map((val) {
                    return DropdownMenuItem(value: val, child: Text(val.name));
                  }).toList(),
                  onChanged: (val) {
                    // Handle change
                    drinkType = val;
                  },
                  onSaved: (val) {
                    drinkType = val;
                  },
                  validator: (val) {
                    if (val == null) {
                      return 'Please select a drink type';
                    }
                    return null;
                  },
                ),
                ...ServingFormat.values.map((format) {
                  return CheckboxListTile(
                    title: Text(format.name),
                    value: servingFormats.contains(format),
                    onChanged: (isChecked) {
                      setState(() {
                        if (isChecked == true) {
                          servingFormats.add(format);
                        } else {
                          servingFormats.remove(format);
                        }
                      });
                    },
                  );
                }),
                FilledButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        drinkType != null &&
                        servingFormats.isNotEmpty) {
                      _formKey.currentState!.save();
                      Drink newDrink = Drink(
                        id: widget.drinkImage.id,
                        name: widget.drinkImage.fileName,
                        // description: description!,
                        imageBase64: widget.drinkImage.imageBase64,
                        drinkType: drinkType!,
                        // servingFormats: servingFormats,
                        createdAt: DateTime.now(),
                        lastUpdateAt: DateTime.now(),
                        // servingVolumeInMl: 100,
                        // alcoholPercentage: 10,
                      );
                      widget.onSave(newDrink);
                    }
                    // Create Drink object and pass to onSave
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
