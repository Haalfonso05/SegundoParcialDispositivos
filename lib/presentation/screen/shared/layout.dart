import 'package:flutter/material.dart';

import '../../widgets/layout/drawer_widget.dart';

class Layout extends StatelessWidget {
  const Layout({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(title),
      ),
      drawer: const DrawerWidget(),
      body: child,
    );
  }
}
