import 'package:attend/core/config/environment.dart';

class FlavorConfig {
  // Stores which environment the app is currently running in
  final Environment environment;

  // Stores the base API URL for backend calls in this environment
  final String baseApiUrl;

  // A single shared instance of FlavorConfig for the whole app (Singleton)
  static late FlavorConfig _instance;

  // Private constructor: prevents other parts of the app from creating instances directly
  FlavorConfig._internal({
    required this.environment, // Must provide environment when creating instance
    required this.baseApiUrl, // Must provide backend URL when creating instance
  });

  // Called once (usually at app startup) to initialize the FlavorConfig instance
  static void init({
    required Environment environment,
    required String baseApiUrl,
  }) {
    // Create the one and only FlavorConfig instance and store it
    _instance = FlavorConfig._internal(
      environment: environment,
      baseApiUrl: baseApiUrl,
    );
  }

  // Provides access to the single instance from anywhere in the app
  static FlavorConfig get instance => _instance;

  // Easy checks to know which environment the app is running in
  bool get isDev => environment.isDev;
  bool get isProd => environment.isProd;
}
