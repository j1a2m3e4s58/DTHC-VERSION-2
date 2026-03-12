import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_colors.dart';
import 'data/cart_controller.dart';
import 'data/delivery_zone_controller.dart';
import 'data/order_controller.dart';
import 'data/store_controller.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DTHCApp());
}

class DTHCApp extends StatelessWidget {
  const DTHCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreController()),
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => DeliveryZoneController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DTHC',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.gold,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: AppColors.primaryBlack,
        ),
        home: const HomePage(),
      ),
    );
  }
}