import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_client/exceptions/auth_exceptions.dart';
import 'package:flutter_client/repositiories/auth/base_auth_repository.dart';
import 'package:flutter_client/repositiories/paths.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository extends BaseAuthRepository {
  Future<String> get siteManagerId async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('jwt');
    if (token == null) {
      throw AuthException('Not logged in');
    } else {
      try {
        // Verify a token (SecretKey for HMAC & PublicKey for all the others)
        final jwt = JWT.verify(token, SecretKey('secret'));
        if (jwt.payload['role'] == 'siteManager') {
          return jwt.payload['_id'];
        } else {
          throw UnauthorizedException('Failed to login');
        }
      } on JWTExpiredException catch (e) {
        developer.log(e.message, name: "AuthRepository");
        throw TokenExpiredException(e.message);
      } on JWTException catch (ex) {
        developer.log(ex.message, name: "AuthRepository");
        throw AuthException(ex.message); // ex: invalid signature
      } catch (e) {
        developer.log(e.toString(), name: "AuthRepository");
        throw AuthException(e.toString());
      }
    }
  }

  Future<String> get siteManagerName async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('jwt');
    if (token == null) {
      throw AuthException('Not logged in');
    } else {
      try {
        // Verify a token (SecretKey for HMAC & PublicKey for all the others)
        final jwt = JWT.verify(token, SecretKey('secret'));
        if (jwt.payload['role'] == 'siteManager') {
          return jwt.payload['name'];
        } else {
          throw UnauthorizedException('Failed to login');
        }
      } on JWTExpiredException catch (e) {
        developer.log(e.message, name: "AuthRepository");
        throw TokenExpiredException(e.message);
      } on JWTException catch (ex) {
        developer.log(ex.message, name: "AuthRepository");
        throw AuthException(ex.message); // ex: invalid signature
      } catch (e) {
        developer.log(e.toString(), name: "AuthRepository");
        throw AuthException(e.toString());
      }
    }
  }

  Future<bool?> isTokenAvailable() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final token = sharedPreferences.getString('jwt');
    if (token == null) {
      throw AuthException('Not logged in');
    } else {
      try {
        // Verify a token (SecretKey for HMAC & PublicKey for all the others)
        final jwt = JWT.verify(token, SecretKey('secret'));
        if (jwt.payload['role'] == 'siteManager') {
          return true;
        } else {
          throw UnauthorizedException('Failed to login');
        }
      } on JWTExpiredException catch (e) {
        developer.log(e.message, name: "AuthRepository");
        throw TokenExpiredException(e.message);
      } on JWTException catch (ex) {
        developer.log(ex.message, name: "AuthRepository");
        throw AuthException(ex.message); // ex: invalid signature
      } catch (e) {
        developer.log(e.toString(), name: "AuthRepository");
        throw AuthException(e.toString());
      }
    }
  }

  @override
  Future<bool> login(String email, String password) async {
    final Uri authApiUri = Uri.https(
      hostName,
      authPath,
    );

    // Request headers
    const requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    // Request body
    var requestBody = jsonEncode({
      'email': email,
      'password': password,
    });

    // Make POST request to login api
    final response = await http.post(
      authApiUri,
      headers: requestHeaders,
      body: requestBody,
    );

    if (response.statusCode == 401) {
      throw InvalidCredentialsException('Failed to login');
    } else if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final acessToken = decodedResponse['accessToken'];

      try {
        // Verify a token (SecretKey for HMAC & PublicKey for all the others)
        final jwt = JWT.verify(acessToken, SecretKey('secret'));

        if (jwt.payload['role'] == 'siteManager') {
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.setString('jwt', acessToken);
          return true;
        } else {
          throw UnauthorizedException('Failed to login');
        }
      } on JWTExpiredException catch (e) {
        developer.log(e.message, name: "AuthRepository");
        throw TokenExpiredException(e.message);
      } on JWTException catch (ex) {
        developer.log(ex.message, name: "AuthRepository");
        throw AuthException(ex.message); // ex: invalid signature
      } catch (e) {
        developer.log(e.toString(), name: "AuthRepository");
        throw AuthException(e.toString());
      }
    }

    return false;
  }

  @override
  Future<bool> logout() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.remove('jwt');

    if (sharedPreferences.getString('jwt') == null) {
      return true;
    } else {
      return false;
    }
  }
}
