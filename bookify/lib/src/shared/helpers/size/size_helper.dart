import 'package:flutter/material.dart';

extension SizeForSmallDevice on Size {
  bool isSmallDevice() => height < 675;
}
