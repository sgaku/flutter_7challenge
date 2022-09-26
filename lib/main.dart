import 'package:flutter/material.dart';
import 'package:flutter_7challenge/screens/model/Ranking.dart';
import 'package:flutter_7challenge/screens/page/RankingPage.dart';
import 'package:flutter_7challenge/screens/page/RecordingPage.dart';
import 'package:flutter_7challenge/screens/page/SettingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_7challenge/screens/launch/launch_screen.dart';
import 'package:flutter_7challenge/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'Data/firestore/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;


final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      iOS: DarwinInitializationSettings(),
    ),



  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: LaunchScreen.routeName,
      onGenerateRoute: ref.watch(routerProvider).onGenerateRoute,
      home: const MainPage(),
    );
  }
}

class Index extends ChangeNotifier {
  int selectedIndex = 0;

  void onTapItem(int i, Ranking rankValue) {
    rankValue.fetchRankingList();
    selectedIndex = i;
    notifyListeners();
  }
}

final indexProvider = ChangeNotifierProvider((ref) {
  return Index();
});

class MainPage extends ConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const MainPage(),
    );
  }

  const MainPage({Key? key}) : super(key: key);

  static const _screen = [
    RecordPage(),
    RankingPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(indexProvider);
    final rankValue = ref.watch(rankingProvider);

    return Scaffold(
      body: _screen[value.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: value.selectedIndex,
        onTap: (int index) => value.onTapItem(index, rankValue),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.touch_app), label: '記録する'),
          BottomNavigationBarItem(icon: Icon(Icons.reorder), label: 'ランキング'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'メニュー'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
