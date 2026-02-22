import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:student_task_management/firebase_options.dart';
import 'package:student_task_management/utils/binding.dart';
import 'package:student_task_management/view/splash.dart';
import 'package:student_task_management/view/login.dart';
import 'package:student_task_management/view/register.dart';
import 'package:student_task_management/view/home_view.dart';
import 'package:student_task_management/view/taskscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Task Manager',
      initialBinding: AppBindings(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.blue[800]),
          titleTextStyle: TextStyle(
            color: Colors.blue[800],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/register', page: () => Register()),
        GetPage(name: '/home', page: () => HomeView()),
        GetPage(name: '/add-task', page: () => TaskFormView()),
        GetPage(name: '/edit-task', page: () => TaskFormView(isEditing: true)),
      ],
    );
  }
}