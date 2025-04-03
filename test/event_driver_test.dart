import 'package:event_driver/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:event_driver/event_driver.dart';
import 'my_service.dart';

void main() {
  // すべてのイベントハンドラを登録
  EventRegistry.registerAll();
  
  // イベントを発火
  EventDriver().call("buttonPushed", ["login_button"]);
  EventDriver().call("formSubmitted", [{"username": "user1", "password": "****"}]);
}
