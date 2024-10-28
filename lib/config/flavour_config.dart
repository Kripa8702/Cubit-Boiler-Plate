import 'package:flutter_dotenv/flutter_dotenv.dart';

class FlavorConfig {
  static String apiBaseUrl = '';
  static String env = '';

  static void init() {
    // Replace with your logic for handling different flavors/environments

    env = dotenv.env['ENV'] ?? 'dev';
    switch (env) {
      case 'dev':
        apiBaseUrl = dotenv.env['DEV_API_URL']!;
        break;
      case 'stage':
        apiBaseUrl = dotenv.env['STAGE_API_URL']!;
        break;
      case 'prod':
        apiBaseUrl = dotenv.env['PROD_API_URL']!;
        break;
      default:
        apiBaseUrl = dotenv.env['DEV_API_URL']!;
    }
  }
}
