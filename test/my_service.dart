import 'package:event_driver/annotations.dart';
import 'package:event_driver/event_driver.dart';

part 'my_service.event.dart';

class MyService {
  @Event("buttonPushed")
  void handleButtonPush(String buttonId) {
    print('Button $buttonId was pushed!');
  }
  
  @Event("formSubmitted")
  void handleFormSubmit(Map<String, dynamic> formData) {
    print('Form submitted with data: $formData');
  }
}
