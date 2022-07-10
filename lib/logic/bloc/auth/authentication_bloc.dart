import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';

import 'package:notification_app/data/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_app/services/local_storage_service.dart';
import 'package:notification_app/utils/utils.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required LoyaltyProgramRepository loyaltyProgramRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _loyaltyProgramRepository = loyaltyProgramRepository,
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _authEventSubscription = _authenticationRepository.event.listen(
        (AuthnenticationEvent event) => add(AuthenticationEventChanged(event)));

    _loyaltyProgramSubscription = _loyaltyProgramRepository.onNewData.listen(
        (LoyaltyProgram loyaltyProgram) =>
            add(AuthenticatedDataChanged(loyaltyProgram)));
  }

  final LocalStorage _localStorage = LocalStorage();
  final LoyaltyProgramRepository _loyaltyProgramRepository;
  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthnenticationEvent> _authEventSubscription;
  late StreamSubscription<LoyaltyProgram> _loyaltyProgramSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationEventChanged) {
      yield await _mapAuthenticationEventChangedToState(event.event);
    } else if (event is AuthenticatedDataChanged) {
      yield AuthenticationState.authDataChanged(event.loyaltyProgram);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOut(AuthenticationOrigin.userInteraction);
    }
  }

  @override
  Future<void> close() {
    _authEventSubscription.cancel();
    _authenticationRepository.dispose();
    _loyaltyProgramSubscription.cancel();
    _loyaltyProgramRepository.dispose();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationEventChangedToState(
    AuthnenticationEvent event,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.initialize:
        return _initAuthentication(AuthenticationOrigin.synthetic);
      case AuthenticationStatus.authenticated:
        return _initAuthenticatedUser(event.origin);
      case AuthenticationStatus.unauthenticated:
        return AuthenticationState.unauthenticated(event.origin);
      case AuthenticationStatus.unknown:
      default:
        return const AuthenticationState.unknown();
    }
  }

  Future<AuthenticationState> _initAuthentication(
      AuthenticationOrigin origin) async {
    _cleanIfFirstUseAfterUninstall();

    final bool hasToken = await _authenticationRepository.hasToken();

    return hasToken
        ? await _initAuthenticatedUser(origin)
        : AuthenticationState.unauthenticated(origin);
  }

  Future<AuthenticationState> _initAuthenticatedUser(
      AuthenticationOrigin origin) async {
    final Map<String, dynamic> loyaltyProgram = await _tryGetLoyaltyProgram();

    return loyaltyProgram['error'] == null
        ? AuthenticationState.authenticated(
            loyaltyProgram['data'] as LoyaltyProgram,
            origin,
          )
        : AuthenticationState.unauthenticated(
            AuthenticationOrigin.synthetic,
            loyaltyProgram['error'] as String,
          );
  }

  Future<Map<String, dynamic>> _tryGetLoyaltyProgram() async {
    final String msisdn = _localStorage.msisdn;
    Map<String, dynamic> result = <String, dynamic>{
      'data': null,
      'error': null,
    };

    try {
      final LoyaltyProgram loyaltyProgram = await _loyaltyProgramRepository
          .getProgram(msisdnToCustomerId(msisdn));

      /// Save user first name on every login, we'll  use it later like for
      /// remember me. Do not forget to update it when updating profile!
      _localStorage.userFirstName = loyaltyProgram.userInfos!.firstName;

      result['data'] = loyaltyProgram;
    } on Exception catch (e) {
      result['error'] = e.toString();
    }

    return result;
  }

  /// Well-known problem that the data stored in iOS Keychain is not deleted
  /// even app uninstalled. So that, we do it on first run in case of
  /// reinstallation.
  Future<void> _cleanIfFirstUseAfterUninstall() async {
    if (_localStorage.appFirstRun) {
      /// Delete all secure storage entries on first run after uninstall
      await _authenticationRepository.deleteAll();
      _localStorage.appFirstRun = false;
    }
  }
}
