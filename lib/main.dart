import 'package:flutter/material.dart';

import 'core/usecase/app_strings.dart';
import 'features/pokemon/presentation/pages/generations_page.dart';
import 'features/pokemon/presentation/pages/home_page.dart';
import 'features/pokemon/presentation/widgets/app_style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: AppStyle.theme,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const GenerationsPage(),
        '/homePage': (BuildContext context) =>
            const HomePage(title: AppStrings.appTitle, generation: 1),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
