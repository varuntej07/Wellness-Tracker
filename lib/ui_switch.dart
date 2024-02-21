import 'package:flutter/widgets.dart';

enum WidgetStyle{
 material,
 cupertino
}

class UiSwitch with ChangeNotifier{
  WidgetStyle widgetStyle;

  UiSwitch(this.widgetStyle);

 // WidgetStyle get widgetStyle => widgetStyle;

  void toggleWidgetStyle() {
    widgetStyle = widgetStyle == WidgetStyle.material ? WidgetStyle.cupertino : WidgetStyle.material;
    print("switch test");
    notifyListeners();
  }
}