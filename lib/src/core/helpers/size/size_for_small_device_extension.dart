import 'package:flutter/material.dart';

/// An extension on [Size] to determine if the device is considered small.
///
/// This extension adds a method to check if the device's screen height is less than 675 pixels,
/// which can be used to adjust the UI for smaller devices. It's a simple utility
/// to help with responsive design in Flutter applications.
extension SizeForSmallDeviceExtension on Size {
  /// Determines if the device is considered small based on its screen height.
  ///
  /// Returns `true` if the device's screen height is less than 675 pixels,
  /// indicating a small device. This can be useful for adjusting UI elements
  /// or layouts to better fit smaller screens.
  bool isSmallDevice() => height < 675;
}
