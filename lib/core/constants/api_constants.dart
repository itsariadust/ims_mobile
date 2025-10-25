import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  final _baseUrl = dotenv.env['BASE_URL'];
  final _keycloakUrl = dotenv.env['KEYCLOAK_URL'];

  get baseUrl => _baseUrl;
  get keycloakUrl => _keycloakUrl;
}