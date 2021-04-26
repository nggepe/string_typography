import 'dart:async';

class DebounceTap {
  Timer? timer;
  Function(TapType)? callback;

  void tapDown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (callback != null) callback!(TapType.longTap);

      timer.cancel();
    });
  }

  void tapUp() {
    if (timer != null) {
      if (timer!.isActive) {
        if (callback != null) {
          callback!(TapType.tap);
          timer!.cancel();
        }
      }
    }
  }
}

enum TapType {
  tap,
  longTap,
}
