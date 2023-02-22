import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monitor_episodes/firebase_options.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/localization/translation.dart';
import 'package:monitor_episodes/model/theme/theme_dark.dart';
import 'package:monitor_episodes/model/theme/theme_light.dart';
import 'package:monitor_episodes/ui/views/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/core/shared/constants.dart';
import 'ui/views/login_screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Translation translation = Translation();
  await translation.fetchLocale();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'AllUsers', // id
      'أشعارات راصد الحلقات', // title
      description:
          "هذه القناة لاشعارك بكل جديد \nيرجئ التحديث للحصول على العروض الجديده", // description
      importance: Importance.high,
    );
  }
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  flutterLocalNotificationsPlugin!.show(
    message.notification.hashCode,
    message.notification?.title,
    message.notification?.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel?.id ?? '',
        channel?.name ?? '',
        channelDescription: channel?.description ?? '',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableLights: true,
        //sound: const RawResourceAndroidNotificationSound('sound')
      ),
      //iOS: DarwinNotificationDetails()
    ),
    //payload: 'Default Sound'
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Locale? locale = Translation.locale;
    return GetMaterialApp(
      title: locale.languageCode == 'ar' ? "راصد الحلقات" : "Monitor Episodes",
      defaultTransition: Transition.fade,
      theme: ThemeLight.themeLight,
      darkTheme: ThemeLight.themeLight,
     // darkTheme: ThemeDark.themeDark,
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      locale: Translation.locale,
      fallbackLocale: Translation.fallbackLocale,
      translations: Translation(),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isHome = false;
  bool isclose = false;
  bool isStartOpcity = false;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    SizeConfig('initialSize').init(originalWidth: 428, originalHeight: 926);
    Constants().getConstants();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FirebaseMessaging.instance.subscribeToTopic('AllUsers');
      var initialzationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initialzationSettingsios = const DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initialzationSettingsAndroid, iOS: initialzationSettingsios);
      flutterLocalNotificationsPlugin!.initialize(initializationSettings);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null && !kIsWeb) {
          flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel?.id ?? '',
                channel?.name ?? '',
                channelDescription: channel?.description ?? '',
                importance: Importance.max,
                priority: Priority.high,
                icon: android.smallIcon,
                playSound: true,
                enableLights: true,
                //sound: const RawResourceAndroidNotificationSound('sound')
              ),
            ),
            //payload: 'Default Sound'
          );
        }
      });
    });

    Timer(const Duration(seconds: 2), () async {
      setState(() {
        isclose = true;
      });
      Timer(const Duration(milliseconds: 500), () {
        if(mounted) {
          setState(() {
          isStartOpcity = true;
        });
        }
      });
      final prefs = await SharedPreferences.getInstance();
      final isLogin = prefs.getBool('isLogin') ?? false;

      Get.off(() => isLogin ? const Home() : const LoginScreen(),
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          transition: isHome ? Transition.zoom : Transition.downToUp);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          AnimatedPositioned(
            height: height,
            duration: const Duration(milliseconds: 700),
            bottom: isclose ? 150.h : 0,
            child: AnimatedOpacity(
              opacity: isStartOpcity ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: SvgPicture.asset(
                'images/maknoon_icon.svg',
                height: !isclose ? 72.h : 150.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
