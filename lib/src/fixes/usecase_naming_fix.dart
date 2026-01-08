import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class UsecaseNamingFix extends DartAssist {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    final path = resolver.path;

    if (!path.contains('/usecases/')) return;

    context.registry.addClassDeclaration((ClassDeclaration node) {
      // Only trigger if cursor is on the class name
      if (!target.intersects(node.name.sourceRange)) return;

      final className = node.name.lexeme;

      if (className.endsWith('Usecase')) return;

      reporter
          .createChangeBuilder(message: 'Append Usecase suffix to class name', priority: 80)
          .addDartFileEdit((builder) {
            builder.addSimpleReplacement(node.name.sourceRange, '${className}Usecase');
          });
    });
  }
}
