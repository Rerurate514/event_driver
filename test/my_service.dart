import 'package:event_driver/annotations.dart';
import 'package:event_driver/event_driver.dart';

part 'my_service.event.dart';

const String buttonPushedEvent = "buttonPushed";
const String formSubmittedEvent = "formSubmitted";

class MyService {
  @Event(buttonPushedEvent)
  void handleButtonPush(String buttonId) {
    print('Button $buttonId was pushed!');
  }
  
  @Event(formSubmittedEvent)
  void handleFormSubmit(Map<String, dynamic> formData) {
    print('Form submitted with data: $formData');
  }
}
