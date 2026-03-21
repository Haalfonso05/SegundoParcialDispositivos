import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterModel {
  RouterModel({
    required this.name,
    required this.description,
    required this.path,
    required this.widget,
  });

  final String name;
  final String description;
  final String path;
  final Widget Function(BuildContext, GoRouterState) widget;
}
