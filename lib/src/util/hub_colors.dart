import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hub/src/util/hex_color.dart';

class HubColors {
  static final HubColors _hubColors = HubColors._internal();

  Color primary = HexColor("#fab826"); //yellow
  Color secondary = HexColor("#fccc58"); //light yellow
  Color yellowExtraLight = HexColor("#facf7d"); //light yellow
  Color dark = HexColor("#24211b"); //dark text
  Color gray = HexColor("#9c9c9c"); //can use in some titles
  Color white = HexColor("#f8eaca"); //off-white
  Color brown = HexColor("#937636"); //off-white
  Color lightBrown = HexColor("#ae8f49"); //off-white
  Color lightGreyTextbox = HexColor("#f2f2f0"); //textInput background

  Decoration appBarGradient() {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [hubColors.primary, hubColors.yellowExtraLight]),
    );
  }


  factory HubColors () {
    return _hubColors;
  }

  HubColors._internal();
}

final hubColors = HubColors();
