part of 'services_bloc.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => <Object>[];
}

class ServicesInitialized extends ServicesEvent {}

class SplashScreenPlayed extends ServicesEvent {}
