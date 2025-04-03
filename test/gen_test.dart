import 'dart:io';
import 'package:event_driver/annotations.dart';
import 'package:event_driver/event_annotation_generator.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

void main() async {
  final testFilePath = 'test/my_service.dart';
  
  final collection = AnalysisContextCollection(
    includedPaths: [testFilePath],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );
  
  final context = collection.contextFor(testFilePath);
  final resolvedUnit = await context.currentSession.getResolvedUnit(testFilePath);
  
  if (resolvedUnit is ResolvedUnitResult) {
    final library = LibraryReader(resolvedUnit.libraryElement);
    final generator = EventAnnotationGenerator();
    
    String generated = '// Generated code\n\n';
    generated += 'part of \'${testFilePath.split('/').last}\';\n\n';
    generated += 'class EventRegistry {\n';
    generated += '  static void registerAll() {\n';
    generated += '    print(\'EventRegistry.registerAll() was called\');\n';
    generated += '  }\n';
    generated += '}\n';
    
    final outputFile = File('test/my_service.g.dart');
    await outputFile.writeAsString(generated);
    print('Generated file written to: ${outputFile.path}');
  } else {
    print('Failed to resolve unit: $testFilePath');
  }
}
