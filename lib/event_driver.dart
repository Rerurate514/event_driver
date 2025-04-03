class EventDriver {
  static final EventDriver _instance = EventDriver._internal();
  factory EventDriver() => _instance;
  EventDriver._internal();
  
  final Map<String, List<Function>> _eventHandlers = {};
  
  void registerHandler(String eventName, Function handler) {
    _eventHandlers[eventName] ??= [];
    _eventHandlers[eventName]!.add(handler);
  }
  
  void call(String eventName, [List<dynamic> args = const []]) {
    if (!_eventHandlers.containsKey(eventName)) {
      print('Warning: No handlers registered for event "$eventName"');
      return;
    }
    
    for (var handler in _eventHandlers[eventName]!) {
      Function.apply(handler, args);
    }
  }
}
