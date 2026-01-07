import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class ReqResModelNamingRule extends DartLintRule {
  const ReqResModelNamingRule()
    : super(
        code: const LintCode(
          name: 'req_res_model_naming',
          problemMessage:
              'Model files must end with `_req_model.dart` or `_res_model.dart` and match the class suffix.',
        ),
      );

  @override
  void run(CustomLintResolver resolver, DiagnosticReporter reporter, CustomLintContext context) {
    final path = resolver.path.replaceAll('\\', '/');

    if (!path.contains('/models/')) return;

    final isReq = path.endsWith('_req_model.dart');
    final isRes = path.endsWith('_res_model.dart');

    if (!isReq && !isRes) {
      context.registry.addCompilationUnit((node) {
        reporter.atNode(node, code);
      });
      return;
    }

    context.registry.addClassDeclaration((node) {
      final className = node.name.lexeme;

      if (isReq && !className.endsWith('ReqModel')) {
        reporter.atNode(node, code);
      }

      if (isRes && !className.endsWith('ResModel')) {
        reporter.atNode(node, code);
      }
    });
  }
}
