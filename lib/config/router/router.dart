import 'package:go_router/go_router.dart';

import '../../presentation/screen/product/product_screen.dart';
import '../../presentation/screen/screen.dart';
import '../../presentation/screen/shared/layout.dart';
import 'router_model.dart';

List<RouterModel> appRoutes = [
  RouterModel(
    name: 'Inicio',
    description: 'Pantalla principal',
    path: '/',
    widget: (context, state) => const HomeScreen(),
  ),
  RouterModel(
    name: 'Producto',
    description: 'Pantalla de productos',
    path: '/product',
    widget: (context, state) => const ProductScreen(),
  ),
];

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return Layout(title: state.topRoute?.name ?? '', child: child);
      },
      routes: [
        ...appRoutes.map((route) {
          return GoRoute(
            path: route.path,
            name: route.name,
            builder: (context, state) => route.widget(context, state),
          );
        }),
      ],
    ),
  ],
  errorBuilder: (context, state) => const HomeScreen(),
);
