import 'package:flutter/material.dart';
import 'package:client/splash/view/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('guest');
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://esgliczquhfdqkmnjgdp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVzZ2xpY3pxdWhmZHFrbW5qZ2RwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIxOTMzNDMsImV4cCI6MjA2Nzc2OTM0M30.1NgWbr6vQCyuJoYb_UggBtd5E6fhP4ik4F1iFclLeXA',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trend AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}
