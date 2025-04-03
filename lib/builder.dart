import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'event_annotation_generator.dart';

Builder eventBuilder(BuilderOptions options) =>
    SharedPartBuilder([EventAnnotationGenerator()], 'event');
