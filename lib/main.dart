
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:rand2/multiLang.dart';
import 'ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'settingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {

  runApp(MyApp());
}

writeInt(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key, value);
}

writeBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

class AppBuilder extends StatefulWidget {
  final Function(BuildContext) builder;

  const AppBuilder(
      {Key key, this.builder})
      : super(key: key);

  @override
  AppBuilderState createState() => new AppBuilderState();

  static AppBuilderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<AppBuilderState>());
  }
}

class AppBuilderState extends State<AppBuilder> {

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppBuilder(builder: (context) {
      return MaterialApp(
        title: curLang.title,
        theme: ThemeData(
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: Theme
                .of(context)
                .textTheme
                .apply(
              fontSizeFactor: 1.1,
              fontSizeDelta: 4.0,
            ),
            inputDecorationTheme: InputDecorationTheme(
                hintStyle: TextStyle(
                  color: Colors.black12,
                )
            )


        ),
        home: MyHomePage(title: curLang.title),
        initialRoute: '/',
        routes: {
          '/Setting': (context) => SettingPage(),
          '/Setting/Lang': (context) => LanguagesScreen(),
        },);
    }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

bool hasRead = false;
int from, to, count;
bool reselect=false;

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  BannerAd _bannerAd;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.top);
  }

  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    _loadBannerAd();
  }



  Future read() async {
    if (hasRead) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      from = prefs.getInt('from') ?? 1;
      to = prefs.getInt('to') ?? 30;
      count = prefs.getInt('count') ?? 1;
      reselect = prefs.getBool('reselect');
      if(reselect==null)reselect=false;
      controllerFrom.text=from.toString();
      controllerTo.text=to.toString();
      controllerCount.text=count.toString();
      curLang=idLang(prefs.getInt('lang'));
    });
    hasRead = true;
  }

  String resultString = '';

  void run() {
    setState(() {
      resultString = '';
      if (count == 0) return;
      if (validateFrom() != null) return;
      if (validateTo() != null) return;
      if (validateCnt() != null) return;
      var a = from;
      var b = to;
      if (reselect) {
        resultString = '[';
        for (int i = 0; i < count - 1; i++) {
          resultString += (Random().nextInt(b - a + 1) + a).toString() + ', ';
        }
        resultString += (Random().nextInt(b - a + 1) + a).toString();
        resultString += ']';
      } else {
        List<int> arr = new List(b - a + 1);
        for (int i = a; i <= b; i++)
          arr[i - a] = i;
        arr.shuffle();

        resultString = arr.sublist(0, count).toString();
      }
    });
  }


  String validateFrom() {
    if(from==null)return '';
    return null;
  }

  String validateTo() {
    try {
      if (from > to) return curLang.mustBeLEq + '$from';
    } catch (e) {
      return '';
    }
    return null;
  }

  String validateCnt() {
    if (reselect) return null;
    try {
      if (count > to - from + 1) return curLang.countToLarge;
    } catch (e) {
      return '';
    }
    return null;
  }



  TextEditingController controllerTo=TextEditingController(),controllerFrom=TextEditingController(),controllerCount=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: read(),
        builder: (context, _) {
          _initAdMob();
          states.add(this);
          return Scaffold(
              appBar: AppBar(
                title: Text(curLang.title),
                leading: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, '/Setting');
                  },
                ),
              ),

              body: Padding(padding: const EdgeInsets.all(16), child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(curLang.range + ':', style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1),
                        SizedBox(width: 100, height: 70, child:
                        TextField(
                          controller: controllerFrom,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: curLang.min,
                            errorText: validateFrom(),
                            errorStyle: TextStyle(
                                fontSize: 15,
                                height: 0.7
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onChanged: (String a) {
                            setState(() {
                              if(a==''){from=null;return;}
                              from = int.parse(a);
                              writeInt('from', from);
                            });
                          },
                        ),
                        ),
                        Text('~'),
                        SizedBox(width: 100, height: 70, child:
                        TextField(
                          controller: controllerTo,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: curLang.max,
                            errorText: validateTo(),
                            errorStyle: TextStyle(
                                fontSize: 15,
                                height: 0.7
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onChanged: (String a) {
                            setState(() {
                              if(a==''){to=null;return;}
                              to = int.parse(a);
                              writeInt('to', to);
                            });
                          },

                        ),
                        ),
                      ]
                  ),
                  SizedBox(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[
                        Text(curLang.selectCount),
                        SizedBox(width: 100, height: 70, child:
                        TextField(
                          controller: controllerCount,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "",
                            errorText: validateCnt(),
                            errorStyle: TextStyle(
                              fontSize: 15,
                              height: .7,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onChanged: (String a) {
                            setState(() {
                              if(a==''){count=null;return;}
                              count = int.parse(a);
                              writeInt('count', count);
                            });
                          },
                        ),
                        ),
                        Text(curLang.repeat),
                        Checkbox(value: reselect, onChanged: (value) {
                          setState(() {
                            reselect = value;
                            writeBool('reselect', reselect);
                          });

                        })
                      ]
                  ),
                  SizedBox(height: 60),
                  Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,


                        child: Text(resultString, style: Theme
                            .of(context)
                            .textTheme
                            .headline3,),
                      )
                  ),


                ],
              ),
              ),
              floatingActionButton: FloatingActionButton(

                  backgroundColor: Color.fromARGB(150, 0, 0, 100),
                  focusColor: Color.fromARGB(255, 0, 0, 100),
                  splashColor: Color.fromARGB(255, 0, 0, 100),
                  onPressed: run,
                  child: Text(curLang.run)
              )

          );
        });
  }
}

