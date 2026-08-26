import 'package:flutter_riverpod/flutter_riverpod.dart';

final sideMenuControllerProvider = NotifierProvider<SideMenuController, bool>(
  SideMenuController.new,
);

class SideMenuController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void open() {
    state = true;
  }

  void close() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}
