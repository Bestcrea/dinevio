import 'dart:ui';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:customer/app/modules/splash_screen/views/splash_screen_view.dart';
import 'package:customer/firebase_options.dart';
import 'package:customer/global_setting_controller.dart';
import 'package:customer/services/localization_service.dart';
import 'package:customer/theme/styles.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:customer/services/payment_service.dart';
import 'package:customer/utils/fire_store_utils.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gérer les erreurs Flutter pour éviter les écrans rouges
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack: ${details.stack}');
  };

  // Gérer les erreurs asynchrones
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform Error: $error');
    debugPrint('Stack: $stack');
    return true; // Empêcher l'app de crasher
  };

  await _initFirebaseSafe();
  await _initStripe();
  configLoading();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Dinevio',
    theme: ThemeData(
      primarySwatch: Colors.amber,
      textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1),
    ),
    home: const MyApp(),
  ));
}

Future<void> _initFirebaseSafe() async {
  try {
    // Vérifier si Firebase est déjà initialisé
    if (Firebase.apps.isNotEmpty) {
      debugPrint('Firebase already initialized');
      return;
    }

    // Initialiser Firebase avec DefaultFirebaseOptions.currentPlatform
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase initialized successfully with DefaultFirebaseOptions');
      return;
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      // Fallback: essayer sans options (utilisera google-services.json / GoogleService-Info.plist)
      try {
        await Firebase.initializeApp();
        debugPrint('Firebase initialized successfully from native config files');
        return;
      } catch (e2) {
        debugPrint('Firebase initialization from native files also failed: $e2');
        debugPrint('App will continue without Firebase');
      }
    }
  } catch (e, stackTrace) {
    debugPrint('Firebase init critical error: $e');
    debugPrint('Stack trace: $stackTrace');
    // Ne pas planter l'app, continuer sans Firebase
  }
}

/// Initialize Stripe with publishable key from Firestore settings
Future<void> _initStripe() async {
  try {
    // Get payment settings from Firestore
    final paymentModel = await FireStoreUtils().getPayment();
    if (paymentModel != null && 
        paymentModel.strip != null && 
        paymentModel.strip!.isActive == true &&
        paymentModel.strip!.clientPublishableKey != null &&
        paymentModel.strip!.clientPublishableKey!.isNotEmpty) {
      
      // Initialize Stripe with publishable key and merchant identifier
      await PaymentService.initializeStripe(
        publishableKey: paymentModel.strip!.clientPublishableKey!,
        merchantIdentifier: 'merchant.com.dinevio.app',
        merchantDisplayName: 'Dinevio',
      );
      debugPrint('Stripe initialized successfully');
    } else {
      debugPrint('Stripe is not active or publishable key not found');
    }
  } catch (e) {
    debugPrint('Failed to initialize Stripe: $e');
    // Don't crash the app if Stripe initialization fails
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    WidgetsBinding.instance.addObserver(this);
    // WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return Listener(
            onPointerUp: (_) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.focusedChild!.unfocus();
              }
            },
            child: GetMaterialApp(
                title: 'Dinevio'.tr,
                debugShowCheckedModeBanner: false,
                theme: Styles.themeData(
                    themeChangeProvider.darkTheme == 0
                        ? true
                        : themeChangeProvider.darkTheme == 1
                            ? false
                            : themeChangeProvider.getSystemThem(),
                    context),
                localizationsDelegates: const [
                  CountryLocalizations.delegate,
                ],
                locale: LocalizationService.locale,
                fallbackLocale: LocalizationService.locale,
                translations: LocalizationService(),
                builder: (context, child) {
                  return SafeArea(
                    bottom: true,
                    top: false,
                    child: EasyLoading.init()(context, child),
                  );
                },
                initialRoute: AppPages.INITIAL,
                getPages: AppPages.routes,
                home: GetBuilder<GlobalSettingController>(
                    init: GlobalSettingController(),
                    builder: (context) {
                      return const SplashScreenView();
                    })),
          );
        },
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = const Color(0xFFFEA735)
    ..backgroundColor = const Color(0xFFf5f6f6)
    ..indicatorColor = const Color(0xFFFEA735)
    ..textColor = const Color(0xFFFEA735)
    ..maskColor = const Color(0xFFf5f6f6)
    ..userInteractions = true
    ..dismissOnTap = false;
}
