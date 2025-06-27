import 'package:event_driver/event_driver.dart';
import 'my_service.dart' as ms;
import 'order_service.dart' as os;

void main() {
  // すべてのイベントハンドラを登録
  ms.MyServiceEventRegistry.registerAll();
  os.OrderServiceEventRegistry.registerAll();
  
  // イベントを発火
  EventDriver().call("buttonPushed", ["login_button"]);
  EventDriver().call("formSubmitted", [{"username": "user1", "password": "****"}]);

  EventDriver().call("orderPlaced", [{"orderId": "12345", "items": ["item1", "item2"]}]);
  EventDriver().call("orderCanceled", ["12345", "Customer changed mind"]);
  EventDriver().call("orderShipped", ["12345", "TRACK123456"]);
  EventDriver().call("orderDelivered", ["12345"]);
  EventDriver().call("orderReturned", ["12345", "Item was defective"]);
  EventDriver().call("paymentReceived", ["12345", 100.0]);
  EventDriver().call("paymentRefunded", ["12345", 100.0]);
  EventDriver().call("itemOutOfStock", ["item1"]);
  EventDriver().call("customerContacted", ["12345", "Customer inquired about order status"]);
  EventDriver().call("orderNoteAdded", ["12345", "Please deliver before 5 PM"]);
}
