import 'package:coach/model/app_instruction.dart';
import 'package:flutter/material.dart';

class InstructionDisplayWidget extends StatelessWidget {
  const InstructionDisplayWidget({
    super.key,
    required this.index,
    required this.itemCount,
    required this.appInstruction,
  });
  final int index;
  final int itemCount;
  final AppInstruction appInstruction;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: double.infinity,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appInstruction.imagePath == null
                ? SizedBox(height: 200)
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.infinity,
                    child: Image.asset(
                      appInstruction.imagePath!,
                      fit: BoxFit.cover,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                appInstruction.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                appInstruction.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
