import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:string_typography/src/configs/private/main_setting.dart';

class DebounceTap {
  Timer? timer;
  Function(TapType, SettingType, String, Offset localPosition,
      Offset globalPosition) onFire;
  DebounceTap(this.onFire);

  void tapDown(SettingType settingType, String word, TapDownDetails details) {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      onFire(TapType.longTap, settingType, word, details.localPosition,
          details.globalPosition);

      timer.cancel();
    });
  }

  void tapUp(SettingType settingType, String word, TapUpDetails details) {
    if (timer != null) {
      if (timer!.isActive) {
        onFire(TapType.tap, settingType, word, details.globalPosition,
            details.localPosition);
        timer!.cancel();
      }
    }
  }
}

enum TapType {
  tap,
  longTap,
}
