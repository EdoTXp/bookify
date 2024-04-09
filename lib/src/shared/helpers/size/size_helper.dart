import 'package:flutter/material.dart';

extension SizeForSmallDeviceExtension on Size {
  bool isSmallDevice() => height < 675;
}
