import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/logic/bloc/services/services_bloc.dart';

class GlobalProvidersBag extends StatelessWidget {
  final Widget child;

  GlobalProvidersBag({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: <BlocProvider<Object?>>[
          _configureServiceBloc(),
        ],
        child: child,
    );
  }

  BlocProvider<ServicesBloc> _configureServiceBloc() {
    return BlocProvider<ServicesBloc>(
      create: (_) => ServicesBloc(),
    );
  }

}
