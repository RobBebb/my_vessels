import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_vessels/src/features/authentication/data/fake_auth_repository.dart';
import 'package:my_vessels/src/features/authentication/presentation/account/account_screen.dart';
import 'package:my_vessels/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:my_vessels/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:my_vessels/src/features/vessels/presentation/vessel_screen/vessel_screen.dart';
import 'package:my_vessels/src/features/vessels/presentation/vessels_list/vessels_list_screen.dart';
import 'package:my_vessels/src/routing/not_found_screen.dart';

enum AppRoute {
  home,
  vessel,
  account,
  signIn,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.location == '/signIn') {
          return '/';
        }
      } else {
        if (state.location == '/account' || state.location == '/orders') {
          return '/';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const VesselsListScreen(),
        routes: [
          GoRoute(
              path: 'vessel/:id',
              name: AppRoute.vessel.name,
              builder: (conext, state) {
                final vesselId = state.params['id']!;
                return VesselScreen(vesselId: vesselId);
              }),
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const AccountScreen(),
            ),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
              ),
            ),
          ),
        ],
      )
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
  ;
});
