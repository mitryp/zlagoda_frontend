import 'package:flutter/material.dart';

const background = Color(0xFFF4F4F4);
const primary = Color(0xFF8B3FEC);
const secondary = Color(0xFF24DBC5);

final defaultBorderRadius = BorderRadius.circular(16);

final mainTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light().copyWith(
    background: background,
    primary: primary,
    secondary: secondary,
  ),
  navigationRailTheme: NavigationRailThemeData(
    elevation: 1,
    labelType: NavigationRailLabelType.all,
    useIndicator: true,
    indicatorShape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    backgroundColor: primary,
    selectedIconTheme: const IconThemeData(
      color: Colors.black,
    ),
    selectedLabelTextStyle: const TextStyle(
      color: Colors.white,
    ),
    unselectedIconTheme: const IconThemeData(
      color: Colors.white,
    ),
    unselectedLabelTextStyle: const TextStyle(
      color: Colors.white,
    ),
  ),
  cardTheme: CardTheme(
    // margin: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: defaultBorderRadius)),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
      textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 16)),
    ),
  ),
  tabBarTheme: const TabBarTheme(
    indicator: BoxDecoration(),
    labelColor: Colors.black,
    overlayColor: MaterialStatePropertyAll(Colors.transparent),
    labelPadding: EdgeInsets.symmetric(horizontal: 3),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  )
);
