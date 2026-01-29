import 'package:flutter/material.dart';

class TextDisplayWidget extends StatelessWidget {
  const TextDisplayWidget({
    Key? key,
    required this.textStyle,
    required this.description,
  }) : super(key: key);
  final TextStyle textStyle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      "$description ${textStyle.fontFamily} ${textStyle.fontSize} ${textStyle.fontWeight}",
      style: textStyle,
    );
  }
}

class ColorDisplayWidget extends StatelessWidget {
  const ColorDisplayWidget({
    Key? key,
    required this.primary,
    required this.onPrimary,
    required this.primaryText,
    this.onPrimaryText,
    this.width = 170,
    this.height = 100,
  }) : super(key: key);
  final Color primary;
  final Color onPrimary;
  final String primaryText;
  final String? onPrimaryText;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (onPrimaryText == null) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            width: width,
            height: height * 0.7,
            color: primary,
            child: Text(
              primaryText,
              style: TextStyle(color: onPrimary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            width: width,
            height: height * 0.7,
            color: primary,
            child: Text(
              primaryText,
              style: TextStyle(color: onPrimary, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            width: width,
            height: height * 0.3,
            color: onPrimary,
            child: Text(
              onPrimaryText!,
              style: TextStyle(color: primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
  }
}

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Colors')),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(context).colorScheme.primary,
                            onPrimary: Theme.of(context).colorScheme.onPrimary,
                            primaryText: "Primary",
                            onPrimaryText: "On Primary",
                          ),
                          SizedBox(width: 10),
                          ColorDisplayWidget(
                            primary: Theme.of(context).colorScheme.secondary,
                            onPrimary: Theme.of(
                              context,
                            ).colorScheme.onSecondary,
                            primaryText: "Secondary",
                            onPrimaryText: "On Secondary",
                          ),
                          SizedBox(width: 10),
                          ColorDisplayWidget(
                            primary: Theme.of(context).colorScheme.tertiary,
                            onPrimary: Theme.of(context).colorScheme.onTertiary,
                            primaryText: "Tertiary",
                            onPrimaryText: "On Tertiary",
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            onPrimary: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            primaryText: "Primary Container",
                            onPrimaryText: "On Primary Container",
                          ),
                          SizedBox(width: 10),
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            onPrimary: Theme.of(
                              context,
                            ).colorScheme.onSecondaryContainer,
                            primaryText: "Secondary Container",
                            onPrimaryText: "On Secondary Container",
                          ),
                          SizedBox(width: 10),
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.tertiaryContainer,
                            onPrimary: Theme.of(
                              context,
                            ).colorScheme.onTertiaryContainer,
                            primaryText: "Tertiary Container",
                            onPrimaryText: "On Tertiary Container",
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(context).colorScheme.surfaceDim,
                            onPrimary: Theme.of(context).colorScheme.onSurface,
                            primaryText: "Surface Dim",
                            // onPrimaryText: "On Primary Container",
                          ),
                          SizedBox(width: 10),
                          ColorDisplayWidget(
                            primary: Theme.of(context).colorScheme.surface,
                            onPrimary: Theme.of(context).colorScheme.onSurface,
                            primaryText: "Surface Bright",
                            // onPrimaryText: "On Secondary Container",
                          ),
                          SizedBox(width: 10),
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.surfaceBright,
                            onPrimary: Theme.of(context).colorScheme.onSurface,
                            primaryText: "Surface Light",
                            // onPrimaryText: "On Tertiary Container",
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLowest,
                            onPrimary: Theme.of(context).colorScheme.onSurface,
                            width: 530 / 5,
                            primaryText: "Surface Container Lowest",
                            // onPrimaryText: "On Primary Container",
                          ),
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLow,
                            onPrimary: Theme.of(context).colorScheme.onSurface,
                            width: 530 / 5,
                            primaryText: "Surface Container Low",
                            // onPrimaryText: "On Primary Container",
                          ),
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
                            onPrimary: Theme.of(context).colorScheme.onSurface,
                            width: 530 / 5,
                            primaryText: "Surface Container",
                            // onPrimaryText: "On Primary Container",
                          ),
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHigh,
                            onPrimary: Theme.of(context).colorScheme.onSurface,
                            width: 530 / 5,
                            primaryText: "Surface Container High",
                            // onPrimaryText: "On Primary Container",
                          ),
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            onPrimary: Theme.of(context).colorScheme.onSurface,
                            width: 530 / 5,
                            primaryText: "Surface Container Highest",
                            // onPrimaryText: "On Primary Container",
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(context).colorScheme.onSurface,
                            onPrimary: Theme.of(context).colorScheme.surface,
                            width: 530 / 4,
                            height: 50,
                            primaryText: "On Surface",
                            // onPrimaryText: "On Primary Container",
                          ),
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            onPrimary: Theme.of(context).colorScheme.surface,
                            width: 530 / 4,
                            height: 50,
                            primaryText: "On Surface Variant",
                            // onPrimaryText: "On Primary Container",
                          ),
                          ColorDisplayWidget(
                            primary: Theme.of(context).colorScheme.outline,
                            onPrimary: Theme.of(context).colorScheme.surface,
                            width: 530 / 4,
                            height: 50,
                            primaryText: "Outline",
                            // onPrimaryText: "On Primary Container",
                          ),
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.outlineVariant,
                            onPrimary: Theme.of(context).colorScheme.surface,
                            width: 530 / 4,
                            height: 50,
                            primaryText: "Outline Variant",
                            // onPrimaryText: "On Primary Container",
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 40),
                  Column(
                    children: [
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(context).colorScheme.error,
                            onPrimary: Theme.of(context).colorScheme.onError,
                            primaryText: "Error",
                            onPrimaryText: "On Error",
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.errorContainer,
                            onPrimary: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                            primaryText: "Error Container",
                            onPrimaryText: "On Error Container",
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.inverseSurface,
                            onPrimary: Theme.of(
                              context,
                            ).colorScheme.onInverseSurface,
                            primaryText: "Inverse Surface",
                            // onPrimaryText: "On Primary Container",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.onInverseSurface,
                            onPrimary: Theme.of(
                              context,
                            ).colorScheme.inverseSurface,
                            height: 50,
                            primaryText: "On Inverse Surface",
                            // onPrimaryText: "On Primary Container",
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(
                              context,
                            ).colorScheme.inversePrimary,
                            onPrimary: Theme.of(context).colorScheme.primary,
                            height: 50,
                            primaryText: "Inverse Primary",
                            // onPrimaryText: "On Primary Container",
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ColorDisplayWidget(
                            primary: Theme.of(context).colorScheme.scrim,
                            onPrimary: Theme.of(context).colorScheme.surface,
                            height: 50,
                            width: 160 / 2,
                            primaryText: "Scrim",
                            // onPrimaryText: "On Primary Container",
                          ),
                          SizedBox(width: 10),
                          ColorDisplayWidget(
                            primary: Theme.of(context).colorScheme.shadow,
                            onPrimary: Theme.of(context).colorScheme.surface,
                            width: 160 / 2,
                            height: 50,
                            primaryText: "Shadow",
                            // onPrimaryText: "On Primary Container",
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Typography",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 10),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.displayLarge!,
                description: "Display Large",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.displayMedium!,
                description: "Display Medium",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.displaySmall!,
                description: "Display Small",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.headlineLarge!,
                description: "Headline Large",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.headlineMedium!,
                description: "Headline Medium",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.headlineSmall!,
                description: "Headline Small",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.titleLarge!,
                description: "Title Large",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.titleMedium!,
                description: "Title Medium",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.titleSmall!,
                description: "Title Small",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.bodyLarge!,
                description: "Body Large",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.bodyMedium!,
                description: "Body Medium",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.bodySmall!,
                description: "Body Small",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.labelLarge!,
                description: "Label Large",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.labelMedium!,
                description: "Label Medium",
              ),
              TextDisplayWidget(
                textStyle: Theme.of(context).textTheme.labelSmall!,
                description: "Label Small",
              ),
              SizedBox(height: 20),
              Text("Input", style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: TextFormField(
                  initialValue: "Value",
                  decoration: InputDecoration(labelText: "Input"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: TextFormField(
                  initialValue: "Value",
                  enabled: false,
                  decoration: InputDecoration(labelText: "Input Disabled"),
                ),
              ),
              SizedBox(height: 20),
              Text("Button", style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Elevated Button"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: FilledButton(
                  onPressed: () {},
                  child: Text("Filled Button"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: FilledButton.tonal(
                  onPressed: () {},
                  child: Text("Filled Button Tonal"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text("Outlined Button"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: TextButton(onPressed: () {}, child: Text("Text Button")),
              ),
              SizedBox(height: 20),
              Text(
                "Icon Button",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton(icon: Icon(Icons.home), onPressed: () {}),
                  SizedBox(width: 10),
                  Text("IconButton"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton.filled(icon: Icon(Icons.home), onPressed: () {}),
                  SizedBox(width: 10),
                  Text("IconButton Filled"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton.filledTonal(
                    icon: Icon(Icons.home),
                    onPressed: () {},
                  ),
                  SizedBox(width: 10),
                  Text("IconButton Filled Tonal"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton.outlined(icon: Icon(Icons.home), onPressed: () {}),
                  SizedBox(width: 10),
                  Text("IconButton Outlined"),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.home),
                  label: Text("Elevated Button"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.home),
                  label: Text("Filled Button"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: Icon(Icons.home),
                  label: Text("Filled Button Tonal"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.home),
                  label: Text("Outlined Button"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.home),
                  label: Text("Text Button"),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Checkbox",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  SizedBox(width: 10),
                  Checkbox(value: true, onChanged: (value) {}),
                  SizedBox(width: 10),
                  Checkbox(value: null, onChanged: (value) {}, tristate: true),
                  SizedBox(width: 10),
                  Checkbox(value: false, onChanged: (value) {}, isError: true),
                  SizedBox(width: 10),
                  Checkbox(value: true, onChanged: (value) {}, isError: true),
                  SizedBox(width: 10),
                  Checkbox(
                    value: null,
                    onChanged: (value) {},
                    tristate: true,
                    isError: true,
                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 20),
              Text("Radio", style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Row(
                children: [
                  Radio(value: 1, groupValue: 1, onChanged: (value) {}),
                  SizedBox(width: 10),
                  Radio(value: 2, groupValue: 1, onChanged: (value) {}),
                  SizedBox(width: 10),
                  Radio(
                    value: 3,
                    groupValue: 1,
                    onChanged: (value) {},
                    enabled: false,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Slider", style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Slider(value: 0, onChanged: (value) {}),
              SizedBox(height: 20),
              Text("Switch", style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Row(
                children: [
                  Switch(value: false, onChanged: (value) {}),
                  SizedBox(width: 10),
                  Switch(value: true, onChanged: (value) {}),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Switch List Tile",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 400,
                child: SwitchListTile(
                  value: false,
                  title: Text("Switch List Tile"),
                  subtitle: Text("Subtitle"),
                  onChanged: (value) {},
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Dropdown Menu",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 10),
              DropdownMenuFormField(
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: "1", label: "Item 1"),
                  DropdownMenuEntry(
                    value: "2",
                    label: "Item 2",
                    leadingIcon: Icon(Icons.check),
                  ),
                  DropdownMenuEntry(value: "3", label: "Item 3"),
                  DropdownMenuEntry(
                    value: "4",
                    label: "Item 4",
                    enabled: false,
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
