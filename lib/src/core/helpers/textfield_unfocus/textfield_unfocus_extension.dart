import 'package:flutter/material.dart';

/// Unfocuses the current focus scope in the given [BuildContext].
///
/// This function is a utility to remove focus from the currently focused
/// widget within the specified context. It's useful for dismissing the keyboard
/// or other input methods when they are no longer needed.
void unfocus(BuildContext context) => FocusScope.of(context).unfocus();

/// An extension on [BuildContext] to unfocus the current focus scope.
///
/// This extension provides a convenient way to unfocus the current focus scope
/// directly from a [BuildContext] instance. It's a shorthand for
/// calling `FocusScope.of(context).unfocus()`, making it easier to read
/// and maintain in the codebase.
extension TextFieldUnFocusExtension on BuildContext {
  /// Unfocuses the current focus scope associated with this [BuildContext].
  ///
  /// This method is equivalent to calling `FocusScope.of(this).unfocus()`.
  /// It's a convenient way to remove focus from the currently focused
  /// widget, which can be useful for dismissing the keyboard or
  /// other input methods.
  void unfocus() => FocusScope.of(this).unfocus();
}
