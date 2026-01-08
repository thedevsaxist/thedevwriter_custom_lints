import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
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
    if (path.endsWith('.g.dart')) return;

    context.registry.addClassDeclaration((ClassDeclaration node) {
      // Only offer assist when cursor is on the class name
      if (!target.intersects(node.name.sourceRange)) return;

      final oldName = node.name.lexeme;

      if (oldName.endsWith('Usecase')) return;

      final newName = '${oldName}Usecase';

      reporter
          .createChangeBuilder(message: 'Rename class and all references to $newName', priority: 90)
          .addDartFileEdit((builder) {
            _renameAllReferences(builder, node.root, oldName, newName);
          });
    });
  }

  void _renameAllReferences(
    DartFileEditBuilder builder,
    AstNode root,
    String oldName,
    String newName,
  ) {
    root.visitChildren(
      _ClassReferenceVisitor(oldName, (SourceRange range) {
        builder.addSimpleReplacement(range, newName);
      }),
    );
  }
}

class _ClassReferenceVisitor extends RecursiveAstVisitor<void> {
  final String targetClassName;
  final void Function(SourceRange) onReference;

  _ClassReferenceVisitor(this.targetClassName, this.onReference);

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.name == targetClassName) {
      onReference(node.sourceRange);
    }
    super.visitSimpleIdentifier(node);
  }
}
