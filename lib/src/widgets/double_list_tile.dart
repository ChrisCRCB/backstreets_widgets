import 'package:flutter/material.dart';

import '../../extensions.dart';
import '../../shortcuts.dart';
import 'get_text.dart';

/// A widget that shows a double [value].
class DoubleListTile extends StatelessWidget {
  /// Create an instance.
  const DoubleListTile({
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.autofocus = false,
    this.actions = const [],
    this.decimalPlaces = 2,
    this.min,
    this.max,
    this.modifier = 1.0,
    this.onLongPress,
    super.key,
  });

  /// The current value.
  final double value;

  /// The function to call when [value] changes.
  final ValueChanged<double> onChanged;

  /// The title for the resulting [ListTile].
  final String title;

  /// The subtitle for the resulting [ListTile].
  ///
  /// If this value is `null`, then [value] will be used.
  final String? subtitle;

  /// How many decimal places should [value] be shown to.
  final int decimalPlaces;

  /// Whether or not the resulting [ListTile] should be autofocused.
  final bool autofocus;

  /// The actions for the resulting [GetText].
  final List<Widget> actions;

  /// The minimum value for [value].
  final double? min;

  /// The maximum value for [value].
  final double? max;

  /// How much hotkeys should change [value] by.
  final double modifier;

  /// What to do when long pressing the [ListTile].
  final GestureLongPressCallback? onLongPress;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final text = value.toStringAsFixed(decimalPlaces);
    return CallbackShortcuts(
      bindings: {
        moveDownShortcut: () {
          final i = value - modifier;
          if (i >= (min ?? i)) {
            onChanged(i);
          }
        },
        moveUpShortcut: () {
          final i = value + modifier;
          if (i <= (max ?? i)) {
            onChanged(i);
          }
        },
        moveToStartShortcut: () => onChanged(min ?? value),
        moveToEndShortcut: () => onChanged(max ?? value),
      },
      child: ListTile(
        autofocus: autofocus,
        title: Text(title),
        subtitle: Text(subtitle ?? text),
        onTap: () => context.pushWidgetBuilder(
          (final context) => GetText(
            onDone: (final value) {
              Navigator.pop(context);
              onChanged(double.parse(value));
            },
            actions: actions,
            text: text,
            title: title,
            validator: (final value) {
              final d = value == null ? null : double.tryParse(value);
              if (value == null || value.isEmpty) {
                return 'You must enter a value';
              } else if (d == null) {
                return 'Invalid number';
              } else if (d < (min ?? d)) {
                return 'Value must be at least $min';
              } else if (d > (max ?? d)) {
                return 'Value must be no more than $max';
              }
              return null;
            },
          ),
        ),
        onLongPress: onLongPress,
      ),
    );
  }
}
