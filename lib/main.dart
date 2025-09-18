// If you want to start here for non-auth users
import 'package:ecfc/services/auth_service.dart';
import 'package:ecfc/services/wishlist_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'services/cart_service.dart';
import 'screens/shop_page.dart'; // API version

// 🔹 NEW IMPORT
import 'glass_background.dart';

// ✅ Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => WishlistService()),
      ],
      child: const CfcApp(),
    ),
  );
}

class CfcApp extends StatelessWidget {
  const CfcApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService(); // Get instance

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CFC — Custom Fashion Cart',
      themeMode: ThemeMode.dark,
      navigatorKey: navigatorKey, // ✅ add this

      // ✅ Inject GlassBackground globally
      builder: (context, child) {
        return GlassBackground(
          child: child ?? const SizedBox(),
        );
      },

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C3AED)),
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.transparent, // ✅ important
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.transparent, // ✅ important
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),

      home: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const CfcHomePage(); // User is logged in
          }
          // If you want to force login first, you can return SignInPage()
          // return const SignInPage();
          // For now, let's keep CfcHomePage and let ProfilePage handle auth UI
          return const CfcHomePage();
        },
      ),
    );
  }
}














// // If you want to start here for non-auth users
// import 'package:ecfc/services/auth_service.dart';
// import 'package:ecfc/services/wishlist_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'screens/home_page.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:provider/provider.dart';
// import 'services/cart_service.dart';
// import 'screens/shop_page.dart'; // API version
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => CartService()),
//           ChangeNotifierProvider(create: (_) => WishlistService()),
//         ],
//           child: const CfcApp()
//       ),
//   );
// }
//
// class CfcApp extends StatelessWidget {
//   const CfcApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final AuthService authService = AuthService(); // Get instance
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'CFC — Custom Fashion Cart',
//       themeMode: ThemeMode.dark,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C3AED)),
//         useMaterial3: true,
//         fontFamily: 'Roboto',
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF7C3AED),
//           brightness: Brightness.dark,
//         ),
//         scaffoldBackgroundColor: const Color(0xFF0B0B14),
//         useMaterial3: true,
//       ),
//       home: StreamBuilder<User?>(
//         stream: authService.authStateChanges,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(body: Center(child: CircularProgressIndicator()));
//           }
//           if (snapshot.hasData) {
//             return const CfcHomePage(); // User is logged in
//           }
//           // If you want to force login first, you can return SignInPage()
//           // return const SignInPage();
//           // For now, let's keep CfcHomePage and let ProfilePage handle auth UI
//           return const CfcHomePage();
//         },
//       ),
//     );
//   }
// }
//
