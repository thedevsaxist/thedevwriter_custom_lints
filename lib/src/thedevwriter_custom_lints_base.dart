import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'req_req_model_naming_rule.dart';
import 'usecase_naming_rule.dart';

PluginBase createPlugin() => _ProjectLintPlugin();

class _ProjectLintPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [UsecaseNamingRule(), ReqResModelNamingRule()];
  }
}
