import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'multiLang.dart';
import 'main.dart';
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(curLang.setting),
      ),
      body:
          SettingsList(
            sections: [
              SettingsSection(
                title: '',
                tiles: [
                  SettingsTile(
                    title: curLang.language,
                    subtitle: curLang.langName,
                    leading: Icon(Icons.language),
                    onPressed:(context){ Navigator.pushNamed(context, '/Setting/Lang');},
                  ),
                ],
              ),
            ],

      ),
    );
  }
}


class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(curLang.language)),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: "中文",
              trailing: trailingWidget(Langs.zh_tw),
              onPressed: (a) {
                changeLanguage(Langs.zh_tw);
              },
            ),
            SettingsTile(
              title: "English",
              trailing: trailingWidget(Langs.en),
              onPressed: (a) {
                changeLanguage(Langs.en);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(Lang l) {
    return (curLang==l)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void changeLanguage(Lang lang) {
    curLang=lang;
    AppBuilder.of(context).rebuild();
  }
}