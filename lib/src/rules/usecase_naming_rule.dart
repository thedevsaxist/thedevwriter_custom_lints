import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils/generated_files.dart';

class UsecaseNamingRule extends DartLintRule {
  const UsecaseNamingRule()
    : super(
        code: const LintCode(
          name: 'usecase_naming_convention',
          problemMessage:
              'Usecase files must end with `_usecase.dart` and classes must end with `Usecase`.',
        ),
      );

  @override
  void run(CustomLintResolver resolver, DiagnosticReporter reporter, CustomLintContext context) {
    if (isGeneratedFile(resolver)) return;

    final path = resolver.path;

    if (!path.contains('/usecases/')) return;

    // File name check
    if (!path.endsWith('_usecase.dart')) {
      context.registry.addCompilationUnit((node) {
        reporter.atNode(node, code);
      });
      return;
    }

    // Class name check
    context.registry.addClassDeclaration((node) {
      final className = node.name.lexeme;

      if (!className.endsWith('Usecase')) {
        reporter.atNode(node, code);
      }
    });
  }
}
