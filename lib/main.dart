import 'package:flutter/material.dart';
import 'package:twiv/contact/contact_list.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFF8C00),
        appBarTheme: AppBarTheme(
          color: Color(0xFFFF8C00),
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.grey,
          cursorColor: Color(0xff171d49),
          selectionHandleColor: Color(0xff005e91),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        highlightColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFFF8C00),
            focusColor: Color(0xFFFF8C00),
            splashColor: Color(0xFFFF8C00)),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      home: ContactList()));
}
