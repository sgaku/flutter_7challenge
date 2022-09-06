import 'package:flutter/material.dart';
import 'package:flutter_7challenge/RankingPage.dart';
import 'package:flutter_7challenge/RecordingPage.dart';
import 'package:flutter_7challenge/SettingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class Index extends ChangeNotifier {
  int selectedIndex = 0;

  void onTapItem(int i) {
    selectedIndex = i;
    notifyListeners();
  }
}

final indexProvider = ChangeNotifierProvider((ref) {
  return Index();
});

class MainPage extends ConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  static const _screen = [
    RecordPage(),
    RankingPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(indexProvider);

    return Scaffold(
      body: _screen[value.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: value.selectedIndex,
        onTap: value.onTapItem,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.touch_app), label: '記録する'),
          BottomNavigationBarItem(icon: Icon(Icons.reorder), label: 'ランキング'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

