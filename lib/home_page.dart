import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:homework1/recordedInfo.dart';
import 'package:homework1/ui_switch.dart';
import 'package:provider/provider.dart';
import '/workout_recorder.dart';
import '/emotion_recorder.dart';
import '/diet_recorder.dart';
import 'Models/data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:homework1/languages.dart';
import 'package:homework1/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  int selectedIndex = 0;
  bool isToggled = false;

  Future<void> openHiveBox() async {
    await Hive.openBox<EmotionRecord>('emotionRecords');
  }

  final List<Widget> _widgets = [
    const EmotionRecorderWidget(),
    const DietRecorderWidget(),
    const WorkoutRecorderWidget()
  ];

  void _onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uiStyle = Provider.of<UiSwitch>(context).widgetStyle;
    if(uiStyle == WidgetStyle.cupertino){
      return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        //backgroundColor: CupertinoColors.systemPurple,
        leading: const RecordedInfoWidget(),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                onPressed: showLanguageSelection,
              child: const Icon(CupertinoIcons.globe, color: CupertinoColors.black),
            ),
              CupertinoSwitch(
                value: isToggled,
                activeColor: CupertinoColors.activeGreen,
                onChanged: (value) {
                  setState(() {
                    isToggled = value;
                    Provider.of<UiSwitch>(context, listen: false).toggleWidgetStyle();
                  });
                },
              ),
            ]
        ),
      ),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [CupertinoColors.systemPurple, CupertinoColors.systemIndigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              ),
            ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: IndexedStack(
                index: selectedIndex,
                children: _widgets,
              ),
            ),
            CupertinoTabBar(
              backgroundColor: CupertinoColors.systemGrey,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.smiley),
                  label: AppLocalizations.of(context)!.emotions
                ),
                 BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.bell),
                  label: AppLocalizations.of(context)!.diet
                ),
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.bolt),
                  label: AppLocalizations.of(context)!.workout
                ),
              ],
              currentIndex: selectedIndex,
              onTap: _onTap,
            ),
          ],
        ),
    ),
        )
      );
    }
    else {
      return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.purpleAccent[250],
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(20.0), child: Text('')
          ),
          flexibleSpace: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const RecordedInfoWidget(),
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.all(1.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Language>(
                    icon: const Icon(Icons.language, color: Colors.black, size: 32),
                    onChanged: (Language ? language){
                      MyApp.of(context)?.setLocale(Locale(language!.langCode, ''));
                    },
                    items: Language.languagesList().map<DropdownMenuItem<Language>>((language) {
                      return DropdownMenuItem<Language>(
                        value: language,
                        child: Text(language.name,
                          style: const TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      );
                    }).toList(),
                  ),
                )
            ),
            Switch(
              value: Provider.of<UiSwitch>(context).widgetStyle == WidgetStyle.cupertino,
              onChanged: (value) {
                Provider.of<UiSwitch>(context, listen: false).toggleWidgetStyle();
              },
              activeColor: Colors.lightGreenAccent,
              activeTrackColor: Colors.green,
            )
          ]
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: _widgets,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple[400],
        unselectedItemColor: Colors.blueGrey[250],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.emoji_emotions_outlined),
              label: AppLocalizations.of(context)!.emotions
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.fastfood_rounded),
              label: AppLocalizations.of(context)!.diet
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.line_weight),
              label: AppLocalizations.of(context)!.workout
          )
        ],
        currentIndex: selectedIndex,
        onTap: _onTap,
      ),
    );
    }
  }

  void showLanguageSelection() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(AppLocalizations.of(context)!.chooseLanguage),
          actions: Language.languagesList().map((language) {
            return CupertinoActionSheetAction(
              child: Text(language.name),
              onPressed: (){
                myAppKey.currentState?.setLocale(Locale(language.langCode, ''));
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}