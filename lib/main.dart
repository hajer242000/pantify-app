import 'package:amwal_pay_sdk/navigator/sdk_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/screens/add_address.dart';
import 'package:plant_app/screens/cart_screen.dart';
import 'package:plant_app/screens/chat_screen.dart';
import 'package:plant_app/screens/check_out.dart';
import 'package:plant_app/screens/ereceipt.dart';
import 'package:plant_app/screens/explore_screen.dart';
import 'package:plant_app/screens/home_screen.dart';
import 'package:plant_app/screens/launch_screen.dart';
import 'package:plant_app/screens/orders.dart';
import 'package:plant_app/screens/payment_success.dart';
import 'package:plant_app/screens/plant_details.dart';
import 'package:plant_app/screens/plant_seller.dart';
import 'package:plant_app/screens/profile_screen.dart';
import 'package:plant_app/screens/shipping_address.dart';
import 'package:plant_app/screens/shipping_type.dart';
import 'package:plant_app/screens/sign_in.dart';
import 'package:plant_app/screens/sign_up.dart';
import 'package:plant_app/screens/start_screen.dart';
import 'package:plant_app/screens/track_order.dart';
import 'package:plant_app/screens/view_order.dart';
import 'package:plant_app/screens/wish_list_screen.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [AmwalSdkNavigator.amwalNavigatorObserver],
      routes: {
        '/': (context) => StartScreen(),
        '/signIn': (context) => SignIn(),
        '/signUp': (context) => SignUp(),
        '/launch': (context) => LaunchScreen(),
        '/home': (context) => HomeScreen(),
        '/PlantDetails': (context) => PlantDetails(
          plantModel: PlantModel(
            id: '',
            name: '',
            description: '',

            type: '',
            season: '',
            price: 0.0,
            quantity: 2,
            image: '',

            discount: 00,
            categoryId: '',
          ),
        ),
        '/explore': (context) => ExploreScreen(),
        '/wishList': (context) => WishListScreen(),
        '/chat': (context) => ChatScreen(),
        '/profile': (context) => ProfileScreen(),
        '/cart': (context) => CartScreen(),
        '/checkout': (context) => Checkout(),
        '/shippingAddress': (context) => ShippingAddress(),
        '/shippingType': (context) => ShippingType(),
        '/addAddress': (context) => AddAddress(),
        '/orders': (context) => Orders(),
        '/paymentSuccess': (context) => PaymentSuccess(),
        '/eReceipt': (context) => EReceipt(),
        '/viewOrder': (context) => ViewOrder(),
        '/trackOrder': (context) => TrackOrder(orderID: ''),
      },
      onGenerateRoute: (settings) {
        final orderID = settings.arguments as String?;
        if (settings.name == '/trackOrder') {
          return MaterialPageRoute(
            builder: (context) => TrackOrder(orderID: orderID!),
            settings: settings,
          );
        }
        return null;
      },
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: const Color(0xff232323),
          onSecondary: Colors.white,
          tertiary: const Color(0xff787878),
          onTertiary: Colors.white,
          surface: const Color(0xffFEFFFF),
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),
        fontFamily: "${GoogleFonts.inter}",

        textTheme: TextTheme(
          titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w300),
          titleLarge: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          headlineSmall: GoogleFonts.inter(
            color: placeholdColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.bold),
          bodyLarge: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F0F0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 1.4),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.2),
          ),

          hintStyle: GoogleFonts.lato(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),

          labelStyle: GoogleFonts.lato(
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        listTileTheme: ListTileThemeData(
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: Color(0xff777777),
            fontWeight: FontWeight.bold,
          ),
          subtitleTextStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),

        appBarTheme: AppBarTheme(centerTitle: true),
        dividerColor: const Color.fromARGB(255, 220, 218, 218),
      ),
      debugShowCheckedModeBanner: false,
    initialRoute: '/',
    
    );
  }
}
