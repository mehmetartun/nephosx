import 'package:nephosx/widgets/rounded_rectangle_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/cubit/theme_cubit.dart';

class BrightnessSelector extends StatelessWidget {
  const BrightnessSelector({
    super.key,
    this.shouldPop = true,
    this.showSnackbar = true,
    this.narrow = false,
  });
  final bool shouldPop;
  final bool showSnackbar;
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    ThemeCubit cubit = BlocProvider.of<ThemeCubit>(context);
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return narrow
            ? IconButton(
                icon: Icon(
                  Theme.of(context).brightness == Brightness.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: () {
                  cubit.changeThemeMode(
                    Theme.of(context).brightness == Brightness.light
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  );
                  if (shouldPop) {
                    Navigator.of(context).pop();
                  }
                },
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.themeMode == ThemeMode.light
                      ? IconButton.filledTonal(
                          icon: const Icon(Icons.light_mode),
                          onPressed: () {},
                          visualDensity: VisualDensity.standard,
                        )
                      : IconButton(
                          icon: const Icon(Icons.light_mode),
                          onPressed: () {
                            cubit.changeThemeMode(ThemeMode.light);

                            if (shouldPop) {
                              Navigator.of(context).pop();
                            }
                          },

                          // isSelected: true,
                        ),
                  const SizedBox(width: 10),
                  state.themeMode == ThemeMode.dark
                      ? IconButton.filledTonal(
                          icon: const Icon(Icons.dark_mode),
                          onPressed: () {},
                        )
                      : IconButton(
                          icon: const Icon(Icons.dark_mode),
                          onPressed: () {
                            cubit.changeThemeMode(ThemeMode.dark);

                            if (shouldPop) {
                              Navigator.of(context).pop();
                            }
                          },

                          // isSelected: true,
                        ),
                  const SizedBox(width: 10),
                  state.themeMode == ThemeMode.system
                      ? IconButton.filledTonal(
                          icon: const Icon(Icons.smartphone),
                          onPressed: () {},
                        )
                      : IconButton(
                          icon: const Icon(Icons.smartphone),
                          onPressed: () {
                            cubit.changeThemeMode(ThemeMode.system);
                            if (shouldPop) {
                              Navigator.of(context).pop();
                            }
                          },

                          // isSelected: true,
                        ),
                ],
              );
      },
    );
  }
}
