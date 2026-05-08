import 'package:go_router/go_router.dart';

import '../../presentation/screen/login/login_screen.dart';
import '../../presentation/screen/products/products_management_screen.dart';
import '../../presentation/screen/profile/profile_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      name: 'Login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/products',
      name: 'Products',
      builder: (context, state) => const ProductsManagementScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'Profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
  errorBuilder: (context, state) => const LoginScreen(),
);
