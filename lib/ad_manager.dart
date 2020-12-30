
import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      //return "ca-app-pub-2705845233990833~8915655196";
      return "ca-app-pub-3940256099942544~4354546703";//test
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~2594085930";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      //return "ca-app-pub-2705845233990833/5347751752";
      return "ca-app-pub-3940256099942544/6300978111";//test
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4339318960";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

}