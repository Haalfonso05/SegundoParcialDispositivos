import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_notifiers.dart';
import '../../../config/app_translations.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, _, _) {
        final location = GoRouterState.of(context).uri.path;
        return Drawer(
          child: Column(
            children: [
              _buildHeader(context),
              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.inventory_2_outlined,
                label: tr('drawer_products'),
                selected: location == '/products',
                onTap: () => context.go('/products'),
              ),
              _buildMenuItem(
                context,
                icon: Icons.person_outline,
                label: tr('drawer_profile'),
                selected: location == '/profile',
                onTap: () => context.push('/profile'),
              ),
              const Spacer(),
              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.logout,
                label: tr('logout'),
                color: Colors.redAccent,
                onTap: () => context.go('/login'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 38,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              '0192257 - Hector Augusto Alfonso Castilla',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '0192261 - Cristian Albeiro Romero Rincon',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
    bool selected = false,
  }) {
    final effectiveColor = color ??
        (selected
            ? const Color(0xFF1E3A8A)
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75));
    return ListTile(
      leading: Icon(icon, color: effectiveColor),
      title: Text(
        label,
        style: TextStyle(color: effectiveColor, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }
}
