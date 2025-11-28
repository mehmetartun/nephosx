import 'dart:convert';

import 'package:coach/pages/statistics/cubit/statistics_cubit.dart';
import 'package:coach/widgets/formfields/drink_location_form_field.dart';
import 'package:coach/widgets/formfields/drink_size_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../model/consumption.dart';
import '../model/drinking_note.dart';
import '../model/enums.dart';
import 'calendar_date.dart';
import 'drink_card.dart';
import 'drinking_note_view.dart';
import 'formfields/drink_company_form_field.dart';
import 'scaffolds/responsive_bottom_sheet.dart';

class EditableDayBlock extends StatefulWidget {
  EditableDayBlock({
    super.key,
    required this.consumptions,
    required this.date,
    required this.onTap,
    required this.onDelete,
    required this.onSizeChange,
    required this.onSavedNote,
    required this.onUpdatedNote,
    this.drinkingNote,
  });
  final List<Consumption> consumptions;
  final DateTime date;
  final void Function(Consumption) onDelete;
  final void Function({required Consumption cons, required DrinkSize size})
  onSizeChange;
  final void Function(DrinkingNote) onSavedNote;
  final void Function(DrinkingNote) onUpdatedNote;
  final void Function(DateTime) onTap;
  final DrinkingNote? drinkingNote;

  @override
  State<EditableDayBlock> createState() => _EditableDayBlockState();
}

class _EditableDayBlockState extends State<EditableDayBlock> {
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<FormState> notesFormKey = GlobalKey();

  DrinkingNote? newNotes;
  String? uid;
  DrinkCompany? _drinkCompany;
  DrinkLocation? _drinkLocation;
  String? _drinkNote;

  @override
  void initState() {
    super.initState();
    uid = widget.consumptions.first.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: ShapeDecoration(
      //   color: Theme.of(context).colorScheme.surfaceContainerHigh,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // ),
      // margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CalendarDate(date: widget.date, onTap: widget.onTap),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      // textBaseline: TextBaseline.alphabetic,
                      // crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.scale,
                            size: Theme.of(
                              context,
                            ).textTheme.titleMedium?.fontSize,
                          ),
                        ),

                        RichText(
                          text: TextSpan(
                            text: NumberFormat('0').format(
                              Consumption.totalCalories(widget.consumptions),
                            ),

                            style: Theme.of(context).textTheme.headlineSmall,
                            children: [
                              TextSpan(
                                text: ' kCal',

                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // textBaseline: TextBaseline.ideographic,
                      // crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.local_bar,
                            size: Theme.of(
                              context,
                            ).textTheme.titleMedium?.fontSize,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: NumberFormat('0.0').format(
                              Consumption.totalUnits(widget.consumptions),
                            ),
                            style: Theme.of(context).textTheme.headlineSmall,
                            children: [
                              TextSpan(
                                text: ' units',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (uid != null)
                Padding(
                  padding: const EdgeInsets.only(right: 0, left: 20),
                  child: TextButton.icon(
                    icon: widget.drinkingNote == null
                        ? Icon(Icons.note_add)
                        : Icon(Icons.edit_note),
                    label: Text("Notes"),
                    onPressed: () async {
                      bool? res = await showResponsiveBottomSheet<bool>(
                        context: context,
                        builder: (context) {
                          return Stack(
                            children: [
                              SingleChildScrollView(
                                child: Form(
                                  key: notesFormKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          10,
                                          10,
                                          10,
                                          0,
                                        ),
                                        child: Text(
                                          "Notes for ${DateFormat("EEE, d MMM yyyy").format(widget.date)}",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          10,
                                          10,
                                          10,
                                          10,
                                        ),
                                        child: TextFormField(
                                          initialValue:
                                              widget.drinkingNote?.notes,
                                          decoration: InputDecoration(
                                            labelText: "Notes (optional)",
                                          ),
                                          minLines: 2,
                                          maxLines: 5,
                                          onSaved: (val) {
                                            val?.isEmpty ?? true
                                                ? _drinkNote = null
                                                : _drinkNote = val;
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.fromLTRB(
                                          10,
                                          10,
                                          10,
                                          10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainerHigh,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Location",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                            SizedBox(height: 10),
                                            DrinkLocationFormField(
                                              initialValue: widget
                                                  .drinkingNote
                                                  ?.drinkLocation,
                                              padding: EdgeInsets.all(0),
                                              validator: (val) {
                                                if (val == null) {
                                                  return "Please select a location";
                                                }
                                                return null;
                                              },
                                              onSaved: (val) {
                                                _drinkLocation = val;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.fromLTRB(
                                          10,
                                          10,
                                          10,
                                          10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainerHigh,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Company",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                            SizedBox(height: 10),
                                            DrinkCompanyFormField(
                                              initialValue: widget
                                                  .drinkingNote
                                                  ?.drinkCompany,
                                              padding: EdgeInsets.all(0),
                                              validator: (val) {
                                                if (val == null) {
                                                  return "Please select company";
                                                }
                                                return null;
                                              },
                                              onSaved: (val) {
                                                _drinkCompany = val;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 100),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 20,
                                bottom: 20,
                                child: FloatingActionButton(
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  child: Icon(Icons.send),
                                  onPressed: () {
                                    if (notesFormKey.currentState?.validate() ??
                                        false) {
                                      notesFormKey.currentState?.save();

                                      widget.drinkingNote != null
                                          ? widget.onUpdatedNote(
                                              widget.drinkingNote!.copyWith(
                                                notes: _drinkNote,
                                                drinkCompany: _drinkCompany,
                                                drinkLocation: _drinkLocation,
                                              ),
                                            )
                                          : widget.onSavedNote(
                                              DrinkingNote(
                                                date: widget.date,
                                                id: "Dummy",
                                                uid: uid!,
                                                drinkLocation: _drinkLocation!,
                                                drinkCompany: _drinkCompany!,
                                                notes: _drinkNote,
                                              ),
                                            );
                                      GoRouter.of(context).pop();
                                    } else {}
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
          if (widget.drinkingNote != null)
            DrinkingNoteView(drinkingNote: widget.drinkingNote!),
          if (widget.drinkingNote == null) SizedBox(height: 10),
          if (widget.consumptions.isEmpty) SizedBox(height: 10),
          ...widget.consumptions.map((cons) {
            return Card(
              margin: EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => MaxWidthBox(
                          maxWidth: 500,
                          child: Dialog(
                            insetPadding: EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: DrinkCard(drink: cons.drink!),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        base64Decode(cons.drink!.imageBase64),
                      ),
                    ),
                    title: Text(cons.drink!.name),
                    subtitle: Text(cons.drinkSize.description),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(NumberFormat('0 kCal').format(cons.calories)),
                        Text(NumberFormat('0.0 units').format(cons.units)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        label: Text("Update"),
                        onPressed: () async {
                          bool? res;
                          res = await showResponsiveBottomSheet<bool>(
                            context: context,
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    10,
                                    20,
                                    10,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Update Size",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SingleChildScrollView(
                                        child: DrinkSizeFormField(
                                          onSaved: (val) {
                                            if (val != null) {
                                              widget.onSizeChange(
                                                cons: cons,
                                                size: val,
                                              );
                                            }
                                          },
                                          drinkType: cons.drink!.drinkType,
                                          initialValue: cons.drinkSize,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          15,
                                          10,
                                          15,
                                          10,
                                        ),
                                        child: Row(
                                          children: [
                                            FilledButton(
                                              child: Text("Save"),
                                              onPressed: () {
                                                formKey.currentState?.save();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      TextButton.icon(
                        label: Text("Delete"),
                        onPressed: () async {
                          bool? res = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                icon: Icon(Icons.delete),
                                title: Text("Confirm Deletion"),
                                content: Text(
                                  "Are you sure you want to delete this entry?",
                                ),
                                actions: [
                                  OutlinedButton(
                                    child: Text("Confirm"),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                  FilledButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          if (res == true) {
                            widget.onDelete(cons);
                          }
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
