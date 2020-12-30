import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '隨機選號器',
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
      home: MyHomePage(title: '隨機選號器'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



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






  String resultString='';
  int from,to,count;
  bool reselect=false;
  void run() {
    setState(() {
      resultString='';
      if(count==0)return;
      if(validateTo()!=null)return;
      if(validateCnt()!=null)return;
      var a=from;
      var b=to;
      if(reselect){
        resultString='[';
        for(int i=0;i<count-1;i++){
          resultString+=(Random().nextInt(b-a+1)+a).toString()+', ';
        }
        resultString+=(Random().nextInt(b-a+1)+a).toString();
        resultString+=']';
      }else{
        List<int> arr=new List(b-a+1);
        for(int i=a;i<=b;i++)arr[i-a]=i;
        arr.shuffle();
        
        resultString= arr.sublist(0,count).toString();
      }
      

    });
  }


  String validateTo(){
    try {
      if (from>to)return '必須>=$from';
    }catch(e){
      return '';
    }
    return null;
  }
  String validateCnt(){
    if(reselect)return null;
    try {
      if (count>to-from+1)return '個數過多';
    }catch(e){
      return '';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _initAdMob();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Padding(padding: const EdgeInsets.all(16), child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('範圍:', style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1),
                SizedBox(width: 100, height: 70, child:
                TextField(
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "起始數字",


                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  onChanged: (String a) {
                    setState(() {
                      from = int.parse(a);
                    });
                  },
                ),
                ),
                Text('~'),
                SizedBox(width: 100, height: 70, child:
                TextField(
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "結束數字",
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
                      to = int.parse(a);
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
                Text('選取個數:'),
                SizedBox(width: 100,height: 70, child:
                TextField(
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
                      count = int.parse(a);
                    });
                  },
                ),
                ),
                Text('重複選取:'),
                Checkbox(value: reselect, onChanged: (value) {
                  setState(() {
                    reselect = value;
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
          child: Text('選號')
      )

    );
  }
}
