import 'package:chat_gpt_fltr/constants/constants.dart';
import 'package:chat_gpt_fltr/core/utils.dart';
import 'package:chat_gpt_fltr/providers/chats_provider.dart';
import 'package:chat_gpt_fltr/providers/models_provider.dart';
import 'package:chat_gpt_fltr/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  setOverlayStyleAndOrientations();
  FlutterNativeSplash.remove();
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 3));
}

void main() async {
  await initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModelsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(color: cardColor),
          primarySwatch: Colors.blue,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
