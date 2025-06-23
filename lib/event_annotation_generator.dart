import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';

class EventAnnotationGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    if (!_checkValidGenerateFile(library, buildStep)) return '';

    final values = <String>[];

    final libraryName = library.element.source.uri.pathSegments.last.replaceAll('.dart', '');

    values.add('''
// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '$libraryName.dart'; 
    ''');

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
// ignore: non_constant_identifier_names
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

  bool _checkValidGenerateFile(LibraryReader library, BuildStep buildStep) {
    final annotatedMethods = <MethodElement>[];
    
    for (var classElement in library.classes) {
      for (var method in classElement.methods) {
        if (_getEventAnnotation(method) != null) {
          annotatedMethods.add(method);
        }
      }
    }
    
    if (annotatedMethods.isEmpty) return false;
    
    final source = library.element.source.contents.data;
    final expectedPartFile = buildStep.inputId.changeExtension('.event.dart').path.split('/').last;
    
    if (!source.contains("part '$expectedPartFile';") && !source.contains('part "$expectedPartFile";')) {
      log.warning('Found @Event annotations in ${buildStep.inputId.path} but missing part directive: part \'$expectedPartFile\';');
      return false;
    }

    return true;
  }
}
