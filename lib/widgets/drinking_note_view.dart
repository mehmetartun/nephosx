import 'package:coach/model/drinking_note.dart';
import 'package:flutter/material.dart';

class DrinkingNoteView extends StatelessWidget {
  const DrinkingNoteView({super.key, required this.drinkingNote});
  final DrinkingNote drinkingNote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 5),
                    Text(drinkingNote.drinkLocation.title),
                  ],
                ),
                elevation: 0,
              ),
              SizedBox(width: 5),
              Chip(
                shadowColor: Colors.transparent,
                label: Row(
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 5),
                    Text(drinkingNote.drinkCompany.title),
                  ],
                ),
              ),
            ],
          ),
          if (drinkingNote.notes != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Row(
                children: [
                  // Icon(Icons.),
                  // SizedBox(width: 5),
                  Text(
                    drinkingNote.notes!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
