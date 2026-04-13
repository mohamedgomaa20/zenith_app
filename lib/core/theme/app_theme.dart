import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Tajawal",
    scaffoldBackgroundColor: Color(0xffF6F7F9),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    colorScheme: ColorScheme.light(
      primary: Color(0xff15B86C),
      primaryContainer: Color(0xffFFFFFF),

      onSurface: Color(0xff161F1B),
      outlineVariant: Color(0xffA0A0A0),

      outline: Color(0xff6A6A6A),
      secondary: Color(0xff3A4640),
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(fontSize: 20, color: Color(0xff161F1B)),
      foregroundColor: Color(0xff161F1B),
      backgroundColor: Color(0xffF6F7F9),
      surfaceTintColor: Color(0xffF6F7F9),
    ),

    iconTheme: IconThemeData(color: Color(0xff161F1B)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff15B86C),
        foregroundColor: Color(0xffFFFCFC),
        fixedSize: Size(double.infinity, 44),
        textStyle: TextStyle(fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        textStyle: TextStyle(fontSize: 16),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xff15B86C)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xff15B86C),
      foregroundColor: Color(0xffFFFCFC),
      shape: RoundedRectangleBorder(borderRadius: .circular(100)),
      extendedTextStyle: TextStyle(fontSize: 16),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xff161F1B),
        fontFamily: "Tajawal",
      ),
    ),
    dividerTheme: DividerThemeData(color: Color(0xffD1DAD6)),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xff15B86C),
      selectionColor: Color(0xff15B86C),
      selectionHandleColor: Color(0xff15B86C),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Color(0xffF6F7F9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xff15B86C)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: .fixed,
      backgroundColor: Color(0xffF6F7F9),
      selectedItemColor: Color(0xff15B86C),
      unselectedItemColor: Color(0xff3A4640),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Tajawal",
    scaffoldBackgroundColor: Color(0xff181818),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    colorScheme: ColorScheme.dark(
      primary: Color(0xff15B86C),
      primaryContainer: Color(0xff282828),
      onSurface: Color(0xffFFFFFF),
      outlineVariant: Color(0xffA0A0A0),
      outline: Color(0xff6A6A6A),
      secondary: Color(0xffC6C6C6),
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(fontSize: 20, color: Color(0xffFFFCFC)),
      foregroundColor: Color(0xffFFFCFC),
      backgroundColor: Color(0xff181818),
      surfaceTintColor: Color(0xff181818),
    ),

    iconTheme: IconThemeData(color: Color(0xffFFFCFC)),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff15B86C),
        foregroundColor: Color(0xffFFFCFC),
        textStyle: TextStyle(fontSize: 16),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xff15B86C),
      foregroundColor: Color(0xffFFFCFC),
      shape: RoundedRectangleBorder(borderRadius: .circular(100)),
      extendedTextStyle: TextStyle(fontSize: 16),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(0xffFFFCFC),
        textStyle: TextStyle(fontSize: 16),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xff15B86C)),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xffFFFCFC),
        fontFamily: "Tajawal",
      ),
    ),
    dividerTheme: DividerThemeData(color: Color(0xff6E6E6E)),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xff15B86C),
      selectionColor: Color(0xff15B86C),
      selectionHandleColor: Color(0xff15B86C),
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: Color(0xff181818),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xff15B86C)),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: .fixed,
      backgroundColor: Color(0xff181818),
      selectedItemColor: Color(0xff15B86C),
      unselectedItemColor: Color(0xffC6C6C6),
    ),
  );
}
