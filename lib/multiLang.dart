import 'package:flutter/material.dart';

int langId(Lang lang){
  if(lang==Langs.zh_tw)return 0;
  if(lang==Langs.en)return 1;
  return 0;
}
Lang idLang(int id){
  if(id==0)return Langs.zh_tw;
  if(id==1)return Langs.en;
  return Langs.zh_tw;
}



class Lang{
  String
  langName,
  title,
  mustBeLEq,
  setting,
  countToLarge,
  range,
  min,
  max,
  selectCount,
  repeat,

  language,
  run
  ;
}

class Langs {
  static final Lang zh_tw = Lang()
    ..langName='中文'
    ..title = '隨機選號器'
    ..mustBeLEq = '必須>='
    ..setting = '設定'
    ..countToLarge = '個數過多'
    ..range = '範圍'
    ..min = '起始數字'
    ..max = '結束數字'
    ..selectCount = '選取個數'
    ..repeat = '重複選取'

    ..language='語言'
    ..run='選號'
  ;
  static final Lang en = Lang()
  ..langName='English'
    ..title = 'Random number picker'
    ..mustBeLEq = 'must >='
    ..setting = 'Settings'
    ..countToLarge = 'too large'
    ..range = 'range'
    ..min = 'min'
    ..max = 'max'
    ..selectCount = 'count:'
    ..repeat = 'repeat'

    ..language='Language'
    ..run='run'
  ;
}

Lang curLang=Langs.zh_tw;
List<State> states=List<State>();
void setLang(Lang l){

}
