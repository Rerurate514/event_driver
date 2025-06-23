import 'package:event_driver/annotations.dart';
import 'package:event_driver/event_driver.dart';

part 'order_service.event.dart'; // このファイルは自動生成されます

// 注文関連のイベント定数
const String orderPlacedEvent = "orderPlaced";
const String orderCanceledEvent = "orderCanceled";
const String orderShippedEvent = "orderShipped";
const String orderDeliveredEvent = "orderDelivered";
const String orderReturnedEvent = "orderReturned";
const String paymentReceivedEvent = "paymentReceived";
const String paymentRefundedEvent = "paymentRefunded";
const String itemOutOfStockEvent = "itemOutOfStock";
const String customerContactedEvent = "customerContacted";
const String orderNoteAddedEvent = "orderNoteAdded";


class OrderService {
  @Event(orderPlacedEvent)
  void handleOrderPlaced(Map<String, dynamic> orderDetails) {
    print('新しい注文が確定しました: ${orderDetails['orderId']}');
    // 注文データベースへの保存、在庫の引き当てなどの処理
  }

  @Event(orderCanceledEvent)
  void handleOrderCanceled(String orderId, String reason) {
    print('注文 $orderId がキャンセルされました。理由: $reason');
    // 在庫の戻し、返金処理の開始など
  }
  
  @Event(orderShippedEvent)
  void handleOrderShipped(String orderId, String trackingNumber) {
    print('注文 $orderId が発送されました。追跡番号: $trackingNumber');
    // 顧客への発送通知メール送信など
  }

  @Event(orderDeliveredEvent)
  void handleOrderDelivered(String orderId) {
    print('注文 $orderId が配達完了しました。');
    // 顧客への受領確認メール送信など
  }

  @Event(orderReturnedEvent)
  void handleOrderReturned(String orderId, String returnReason) {
    print('注文 $orderId が返品されました。理由: $returnReason');
    // 返品処理、返金処理など
  }

  @Event(paymentReceivedEvent)
  void handlePaymentReceived(String orderId, double amount) {
    print('注文 $orderId の支払いを受領しました。金額: $amount円');
    // 支払いの確定、注文ステータスの更新など
  }

  @Event(paymentRefundedEvent)
  void handlePaymentRefunded(String orderId, double amount) {
    print('注文 $orderId に対して ${amount}円の返金を行いました。');
    // 返金処理の記録など
  }

  @Event(itemOutOfStockEvent)
  void handleItemOutOfStock(String productId, int requestedQuantity) {
    print('商品 $productId が品切れです。リクエスト数: $requestedQuantity');
    // 顧客への通知、バックオーダー処理など
  }
  
  @Event(customerContactedEvent)
  void handleCustomerContacted(String orderId, String contactMethod, String notes) {
    print('注文 $orderId の顧客に $contactMethod で連絡しました。メモ: $notes');
    // 顧客対応履歴の記録など
  }

  @Event(orderNoteAddedEvent)
  void handleOrderNoteAdded(String orderId, String noteContent, String addedBy) {
    print('注文 $orderId にメモが追加されました。「$noteContent」 by $addedBy');
    // 注文履歴へのメモ追加など
  }
}