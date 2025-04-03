import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';

class EventAnnotationGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final values = <String>[];
    
    for (var classElement in library.classes) {
      for (var method in classElement.methods) {
        final eventAnnotation = _getEventAnnotation(method);
        if (eventAnnotation != null) {
          final eventName = eventAnnotation.name;
          final className = classElement.name;
          final methodName = method.name;
          
          final parameterList = method.parameters.map((p) => '${p.type} ${p.name}').join(', ');
          final argumentList = method.parameters.map((p) => p.name).join(', ');
          
          values.add('''
void _register${className}_${methodName}(${className} instance) {
  EventDriver().registerHandler('$eventName', 
    ($parameterList) => instance.$methodName($argumentList));
}
''');
        }
      }
    }
    
    if (values.isEmpty) {
      return '';
    }
    
    return '''
// Generated code - do not modify by hand

import 'package:event_driver/event_driver.dart';

${values.join('\n')}

class EventRegistry {
  static void registerAll() {
    ${library.classes.map((cls) => 
      cls.methods.where((m) => _getEventAnnotation(m) != null)
         .map((m) => '_register${cls.name}_${m.name}(${cls.name}());')
         .join('\n    ')
    ).join('\n    ')}
  }
}
''';
  }
  
  Event? _getEventAnnotation(MethodElement method) {
    for (final annotation in method.metadata) {
      final constantValue = annotation.computeConstantValue();
      if (constantValue == null) continue;
      
      final type = constantValue.type;
      if (type != null && type.element != null && type.element!.name == 'Event') {
        final nameField = constantValue.getField('name');
        if (nameField != null) {
          return Event(nameField.toStringValue()!);
        }
      }
    }
    return null;
  }
}
