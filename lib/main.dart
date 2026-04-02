import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_colors.dart';
import 'data/cart_controller.dart';
import 'data/delivery_zone_controller.dart';
import 'data/order_controller.dart';
import 'data/store_controller.dart';
import 'data/theme_controller.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  runApp(DTHCApp(firebaseReady: firebaseReady));
}

class DTHCApp extends StatelessWidget {
  final bool firebaseReady;

  const DTHCApp({super.key, required this.firebaseReady});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StoreController(enableSync: firebaseReady),
        ),
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(
          create: (_) => OrderController(enableSync: firebaseReady),
        ),
        ChangeNotifierProvider(
          create: (_) => DeliveryZoneController(enableSync: firebaseReady),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeController()
            ..setThemeMode(StoreController().getStoreSettings().themeMode),
        ),
      ],
      child: Builder(
        builder: (context) {
          final themeController = context.watch<ThemeController>();

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DTHC',
            themeMode: themeController.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Arial',
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.gold,
                brightness: Brightness.light,
              ),
              scaffoldBackgroundColor: AppColors.lightPalette.background,
              cardColor: AppColors.lightPalette.card,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Arial',
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF58A6FF),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: AppColors.darkPalette.background,
              cardColor: AppColors.darkPalette.card,
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
