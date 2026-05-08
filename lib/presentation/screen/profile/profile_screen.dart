import 'package:flutter/material.dart';

import '../../../config/app_notifiers.dart';
import '../../../config/app_translations.dart';
import '../../widgets/layout/drawer_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, _, _) {
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Text(tr('title_profile')),
          ),
          drawer: const DrawerWidget(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: cs.primaryContainer,
                  child: ClipOval(
                    child: Image.asset(
                      'fotoDePerfil.jpg',
                      width: 112,
                      height: 112,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.person,
                        size: 56,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Spike',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Spike@bruna.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                ),
                const SizedBox(height: 28),
                Container(
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(context,
                          icon: Icons.person_outline,
                          label: tr('prof_name_label'),
                          value: 'Spike'),
                      Divider(height: 1, color: cs.onSurface.withValues(alpha: 0.08)),
                      _buildInfoRow(context,
                          icon: Icons.email_outlined,
                          label: tr('prof_email_label'),
                          value: 'Spike@bruna.com'),
                      Divider(height: 1, color: cs.onSurface.withValues(alpha: 0.08)),
                      _buildInfoRow(context,
                          icon: Icons.badge_outlined,
                          label: tr('prof_role_label'),
                          value: tr('prof_role_value')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1E3A8A), size: 22),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
