import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLockNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void lock() => state = true;
  void unlock() => state = false;
}

final appLockProvider = NotifierProvider<AppLockNotifier, bool>(
  () => AppLockNotifier(),
);

class AppLock {
  static void lock(WidgetRef ref) {
    ref.read(appLockProvider.notifier).lock();
  }

  static void unlock(WidgetRef ref) {
    ref.read(appLockProvider.notifier).unlock();
  }
}
