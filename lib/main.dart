import 'package:chatapp/app/UI/auth/homePage.dart';
import 'package:chatapp/app/UI/auth/login_screen.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/flavors/ch_environment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChEnvironment.initialize('dev');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: getInitialPage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data as Widget;
        },
      ),
    );
  }

  Future<Widget> getInitialPage() async {
    final token = await CommonService.getSessionToken();
    if (token == null || token.isEmpty) {
      return const LoginScreen();
    }
    return const Homepage();
  }
}
