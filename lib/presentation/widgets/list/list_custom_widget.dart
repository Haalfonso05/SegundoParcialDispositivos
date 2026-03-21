import 'package:parcial_flutter/config/router/router_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListCustomWidget extends StatelessWidget {
  final RouterModel routerModel;
  final bool drawer;

  const ListCustomWidget({
    super.key,
    required this.routerModel,
    this.drawer = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_iconForPath(routerModel.path), size: 18),
      title: Text(routerModel.name),
      subtitle: Text(routerModel.description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (drawer) {
          Navigator.pop(context);
        }
        context.go(routerModel.path);
      },
    );
  }

  IconData _iconForPath(String path) {
    if (path == '/') return Icons.home;
    if (path == '/product') return Icons.abc;
    return Icons.arrow_right;
  }
}
