import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '/points_provider.dart';
import 'Models/data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Models/ui_switch.dart';
import 'authentication/login.dart';
import 'firebase_options.dart';


final GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(EmotionRecordAdapter());
  Hive.registerAdapter(DietRecordAdapter());
  Hive.registerAdapter(WorkoutRecordAdapter());
  Hive.registerAdapter(RecordedPointsAdapter());
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => RecordedPointsProvider()),
            ChangeNotifierProvider(create: (_) => UiSwitch(WidgetStyle.material))
          ],
          child: MyApp(key: myAppKey)
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
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
      home: const Login(),
    );
  }
}