import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenWithProvider<T extends BlocBase<Object?>> extends StatelessWidget {
  final T Function(BuildContext) create;
  final Widget child;

  const ScreenWithProvider({
    required this.create,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: create,
      child: child,
    );
  }
}
