import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_filter/2_application/core/routes.dart';
import 'package:water_filter/firebase_options.dart';
import 'package:water_filter/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();

  runApp(const MyBasicApp());
}

class MyBasicApp extends StatelessWidget {
  const MyBasicApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryColor: const Color(0xff0083ff),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Product List App Demo',
      routerConfig: routes,
    );
  }
}
