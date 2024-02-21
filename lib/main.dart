import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '/points_provider.dart';
import 'Models/data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_page.dart';
import 'ui_switch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EmotionRecordAdapter());
  Hive.registerAdapter(DietRecordAdapter());
  Hive.registerAdapter(WorkoutRecordAdapter());
  Hive.registerAdapter(RecordedPointsAdapter());
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecordedPointsProvider()),
        ChangeNotifierProvider(create: (_) => UiSwitch(WidgetStyle.material)),
      ],
      child: const MyApp()
  )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: const MyHomePage(),
    );
  }
}