//
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'brand/theme.dart';
import 'global_pods/providers.dart';
import 'app/home/home.page.dart';
import 'app/login/login.page.dart';
import 'services/database.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final auth = watch(authProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      home: StreamBuilder<User?>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return LoginPage();
            }
            return HomePage();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        stream: auth.authStateChanges(),
      ),
    );
  }
}
