import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // اللغة الافتراضية للتطبيق
  Locale _locale = const Locale('ar');

  // دالة تحديث اللغة وتغيير حالة التطبيق بالكامل
  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رائد الخير',
      debugShowCheckedModeBanner: false,
      
      // إعدادات اللغات المدعومة
      locale: _locale,
      supportedLocales: const [
        Locale('ar'), // العربية
        Locale('en'), // الإنجليزية
        Locale('ku'), // الكردية
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // تنسيق الثيم العام
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Tajawal', // تأكد من إضافة الخط في pubspec.yaml ليدعم العربية والكردية بشكل جميل
        useMaterial3: true,
      ),

      // نظام المسارات (Routes) لتسهيل التنقل بين الأزرار
      initialRoute: '/',
      routes: {
        // شاشة تسجيل الدخول هي نقطة البداية
        '/': (context) => LoginScreen(onLanguageChange: setLocale),
        
        // مسار شاشة إنشاء حساب جديد
        '/signup': (context) => SignUpScreen(onLanguageChange: setLocale),
        
        // مسار الشاشة الرئيسية (التي تحتوي على الهوم والبروفايل)
        '/home': (context) => HomeScreen(onLanguageChange: setLocale),
      },
    );
  }
}
