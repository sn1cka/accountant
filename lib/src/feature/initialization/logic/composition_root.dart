import 'package:drift/drift.dart';
import 'package:money_accountant/src/core/constant/config.dart';
import 'package:money_accountant/src/core/database/database.dart';
import 'package:money_accountant/src/core/utils/refined_logger.dart';
import 'package:money_accountant/src/feature/app/logic/tracking_manager.dart';
import 'package:money_accountant/src/feature/dashboard/dashboard_bloc.dart';
import 'package:money_accountant/src/feature/initialization/model/dependencies.dart';
import 'package:money_accountant/src/feature/settings/bloc/settings_bloc.dart';
import 'package:money_accountant/src/feature/settings/data/locale_datasource.dart';
import 'package:money_accountant/src/feature/settings/data/locale_repository.dart';
import 'package:money_accountant/src/feature/settings/data/text_scale_datasource.dart';
import 'package:money_accountant/src/feature/settings/data/text_scale_repository.dart';
import 'package:money_accountant/src/feature/settings/data/theme_datasource.dart';
import 'package:money_accountant/src/feature/settings/data/theme_mode_codec.dart';
import 'package:money_accountant/src/feature/settings/data/theme_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template composition_root}
/// A place where all dependencies are initialized.
/// {@endtemplate}
///
/// {@template composition_process}
/// Composition of dependencies is a process of creating and configuring
/// instances of classes that are required for the application to work.
///
/// It is a good practice to keep all dependencies in one place to make it
/// easier to manage them and to ensure that they are initialized only once.
/// {@endtemplate}
final class CompositionRoot {
  /// {@macro composition_root}
  const CompositionRoot(this.config, this.logger);

  /// Application configuration
  final Config config;

  /// Logger used to log information during composition process.
  final RefinedLogger logger;

  /// Composes dependencies and returns result of composition.
  Future<CompositionResult> compose() async {
    final stopwatch = Stopwatch()..start();

    logger.info('Initializing dependencies...');
    // initialize dependencies
    final dependencies = await _initDependencies();
    logger.info('Dependencies initialized');

    stopwatch.stop();
    final result = CompositionResult(
      dependencies: dependencies,
      msSpent: stopwatch.elapsedMilliseconds,
    );
    return result;
  }

  Future<Dependencies> _initDependencies() async {
    final errorTrackingManager = await _initErrorTrackingManager();
    final sharedPreferences = await SharedPreferences.getInstance();
    final appDataBse = AppDatabase();

    final settingsBloc = await _initSettingsBloc(sharedPreferences);
    final accountantBloc = await _initAccountantBloc(appDataBse);

    return Dependencies(
      settingsBloc: settingsBloc,
      errorTrackingManager: errorTrackingManager,
      accountantBloc: accountantBloc,
    );
  }

  Future<ErrorTrackingManager> _initErrorTrackingManager() async {
    final errorTrackingManager = SentryTrackingManager(
      logger,
      sentryDsn: config.sentryDsn,
      environment: config.environment.value,
    );

    if (config.enableSentry) {
      await errorTrackingManager.enableReporting();
    }

    return errorTrackingManager;
  }

  Future<SettingsBloc> _initSettingsBloc(SharedPreferences prefs) async {
    final localeRepository = LocaleRepositoryImpl(
      localeDataSource: LocaleDataSourceLocal(sharedPreferences: prefs),
    );

    final themeRepository = ThemeRepositoryImpl(
      themeDataSource: ThemeDataSourceLocal(
        sharedPreferences: prefs,
        codec: const ThemeModeCodec(),
      ),
    );

    final textScaleRepository = TextScaleRepositoryImpl(
      textScaleDataSource: TextScaleDatasourceLocal(sharedPreferences: prefs),
    );

    final locale = await localeRepository.getLocale();
    final theme = await themeRepository.getTheme();
    final textScale = await textScaleRepository.getScale();

    final initialState = SettingsState.idle(
      appTheme: theme,
      locale: locale,
      textScale: textScale,
    );

    final settingsBloc = SettingsBloc(
      localeRepository: localeRepository,
      themeRepository: themeRepository,
      textScaleRepository: textScaleRepository,
      initialState: initialState,
    );
    return settingsBloc;
  }

  Future<AccountantBloc> _initAccountantBloc(AppDatabase appDataBase) async {
    final expenses = await appDataBase.expenseCategories.all().get();
    final incomes = await appDataBase.incomeCategories.all().get();
    final accounts = await appDataBase.accounts.all().get();
    final totalIncome = await appDataBase.getMonthlySumFromTable(appDataBase.incomes);
    final totalExpense = await appDataBase.getMonthlySumFromTable(appDataBase.expenses);

    final initialState = AccountantState.idle(
      expenseCategories: expenses,
      incomeCategories: incomes,
      accounts: accounts,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    );
    return AccountantBloc(dataBase: appDataBase, initialState: initialState);
  }
}
