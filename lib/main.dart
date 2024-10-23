import 'package:flutter/material.dart';
import 'package:movie_discovery_app/provider/movie_provider.dart';
import 'package:movie_discovery_app/screens/home_screen.dart';
import 'package:movie_discovery_app/screens/movie_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check initial connectivity status
  var connectivityResult = await Connectivity().checkConnectivity();
  bool isConnected = connectivityResult != ConnectivityResult.none;

  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(context),
      child: MyApp(isConnected: isConnected),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isConnected;

  const MyApp({Key? key, required this.isConnected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isConnected) {
        _showNoConnectionDialog(context);
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Discovery',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/details': (context) => MovieDetailsScreen(),
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue[200],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.black,
    );
  }

  void _showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please turn on Wi-Fi or mobile data."),
          actions: [
            TextButton(
              onPressed: () async {
                var connectivityResult = await Connectivity().checkConnectivity();
                if (connectivityResult != ConnectivityResult.none) {
                  Navigator.of(context).pop();
                } else {
                  _showNoConnectionDialog(context);
                }
              },
              child: const Text("Retry"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
