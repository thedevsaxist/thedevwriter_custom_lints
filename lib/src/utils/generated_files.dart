import 'package:custom_lint_builder/custom_lint_builder.dart';

bool isGeneratedFile(CustomLintResolver resolver) {
  final path = resolver.path.replaceAll('\\', '/');

  // Common generated file patterns
  const generatedSuffixes = ['.g.dart', '.freezed.dart', '.gr.dart', '.config.dart'];

  if (generatedSuffixes.any(path.endsWith)) {
    return true;
  }

  final content = resolver.source.contents.data;

  // Standard generated file header
  if (content.startsWith('// GENERATED CODE') || content.contains('DO NOT MODIFY')) {
    return true;
  }

  return false;
}
