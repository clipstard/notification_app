import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/data/repositories/authentication_repository.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';
import 'package:notification_app/data/repositories/user_repository.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/logic/bloc/login/login_bloc.dart';
import 'package:notification_app/logic/bloc/push_notifications/push_notifications_bloc.dart';
import 'package:notification_app/logic/bloc/services/services_bloc.dart';

class GlobalProvidersBag extends StatelessWidget {
  final Widget child;

  GlobalProvidersBag({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: <RepositoryProvider<Object>>[
        _configureAuthenticationRepository(),
        _configureUserRepository(),
        _configureLoyaltyProgramRepository(),
      ],
      child: MultiBlocProvider(
        providers: <BlocProvider<Object?>>[
          _configureServiceBloc(),
          _configureAuthenticationBloc(),
          _configurePushNotificationBloc(),
          _configureLoginBloc(),
        ],
        child: child,
      ),
    );
  }

  BlocProvider<ServicesBloc> _configureServiceBloc() {
    return BlocProvider<ServicesBloc>(
      create: (_) => ServicesBloc(),
    );
  }

  BlocProvider<AuthenticationBloc> _configureAuthenticationBloc() {
    return BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) => AuthenticationBloc(
        authenticationRepository:
            RepositoryProvider.of<AuthenticationRepository>(context),
        loyaltyProgramRepository:
            RepositoryProvider.of<LoyaltyProgramRepository>(context),
      ),
    );
  }

  BlocProvider<PushNotificationsBloc> _configurePushNotificationBloc() {
    return BlocProvider<PushNotificationsBloc>(
      create: (BuildContext context) => PushNotificationsBloc(
        loyaltyProgramRepository:
            RepositoryProvider.of<LoyaltyProgramRepository>(context),
      )..add(PushNotificationsStarted()),
    );
  }

  BlocProvider<LoginBloc> _configureLoginBloc() {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(
        authenticationRepository:
            RepositoryProvider.of<AuthenticationRepository>(context),
      ),
    );
  }

  RepositoryProvider<AuthenticationRepository>
      _configureAuthenticationRepository() {
    return RepositoryProvider<AuthenticationRepository>(
      create: (BuildContext context) => AuthenticationRepository(),
    );
  }

  RepositoryProvider<UserRepository> _configureUserRepository() {
    return RepositoryProvider<UserRepository>(
      create: (BuildContext context) => UserRepository(),
    );
  }

  RepositoryProvider<LoyaltyProgramRepository>
      _configureLoyaltyProgramRepository() {
    return RepositoryProvider<LoyaltyProgramRepository>(
      create: (BuildContext context) => LoyaltyProgramRepository(),
    );
  }
}
