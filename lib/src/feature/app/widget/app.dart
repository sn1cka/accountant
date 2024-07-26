import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_accountant/src/feature/app/widget/material_context.dart';
import 'package:money_accountant/src/feature/dashboard/dashboard_bloc.dart';
import 'package:money_accountant/src/feature/initialization/logic/composition_root.dart';
import 'package:money_accountant/src/feature/initialization/model/dependencies.dart';
import 'package:money_accountant/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:money_accountant/src/feature/settings/widget/settings_scope.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// {@template app}
/// [App] is an entry point to the application.
///
/// If a scope doesn't depend on any inherited widget returned by
/// [MaterialApp] or [WidgetsApp], like [Directionality] or [Theme],
/// and it should be available in the whole application, it can be
/// placed here.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({required this.result, super.key});

  /// The result from the [CompositionRoot].
  final CompositionResult result;

  @override
  Widget build(BuildContext context) => DefaultAssetBundle(
        bundle: SentryAssetBundle(),
        child: DependenciesScope(
          dependencies: result.dependencies,
          child: SettingsScope(
            settingsBloc: result.dependencies.settingsBloc,
            child: BlocProvider<AccountantBloc>.value(
              value: result.dependencies.accountantBloc,
              child: const MaterialContext(),
            ),
          ),
        ),
      );
}
