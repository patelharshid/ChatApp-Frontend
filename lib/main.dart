import 'package:chatapp/app/UI/auth/homePage.dart';
import 'package:chatapp/app/UI/auth/loginPage.dart';
import 'package:chatapp/app/UI/auth/profileSetupPage.dart';
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
        future: _startPage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data as Widget;
        },
      ),
    );
  }

  Future<Widget> _startPage() async {
    final token = await CommonService.getSessionToken();
    final userId = await CommonService.getUserId();
    if (token == null || token.isEmpty) {
      return const LoginPage();
    }
    if (userId == null || userId.isEmpty) {
      return const ProfileSetupPage();
    }
    return const Homepage();
  }
}
