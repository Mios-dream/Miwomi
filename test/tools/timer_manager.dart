import 'dart:async';
import 'dart:ui';

class TimerManager {
  Timer? _timer; // 保存当前的Timer实例

  // 创建一个新的定时任务
  void createNewTimer(Duration duration, VoidCallback callback) {
    // 如果已经有定时任务在运行，则先取消它
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    // 创建一个新的定时任务
    _timer = Timer(duration, callback);
  }

  // 取消当前的定时任务
  void cancelCurrentTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }
}
