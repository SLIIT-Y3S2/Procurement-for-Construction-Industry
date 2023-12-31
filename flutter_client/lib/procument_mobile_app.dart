import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/blocs/auth/auth_bloc.dart';
import 'package:flutter_client/constants.dart';
import 'package:flutter_client/repositiories/auth/auth_repository.dart';

import 'package:flutter_client/screens/login_screen.dart';

import 'package:flutter_client/screens/main_screen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_client/globals.dart';

class ProcumentMobileApp extends StatefulWidget {
  const ProcumentMobileApp({super.key});

  @override
  State<ProcumentMobileApp> createState() => _ProcumentMobileAppState();
}

class _ProcumentMobileAppState extends State<ProcumentMobileApp> {
  late AuthRepository _authRepository;
  bool _isTokenAvailable = false;

  // MaterialApp
  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository();
    _authRepository.isTokenAvailable().then((isTokenAvailable) {
      setState(() {
        if (isTokenAvailable != null) {
          _isTokenAvailable = isTokenAvailable;
        } else {
          _isTokenAvailable = false;
        }
      });
    }).catchError((error) {
      developer.log(
        'Error: ${error.toString()}',
        error: error,
        name: 'procument_mobile_app.dart',
        stackTrace: error,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignedIn) {
          rootNavigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        }
        if (state is AuthInitial) {
          rootNavigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }

        if (state is SignedOut) {
          rootNavigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: rootNavigatorKey,
        title: 'Procument Mobile App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: kSeedColor,
            primary: kPrimaryColor,
            surface: kSurfaceColor,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
        ),
        home: _isTokenAvailable ? const MainScreen() : const LoginScreen(),
      ),
    );
  }
}
