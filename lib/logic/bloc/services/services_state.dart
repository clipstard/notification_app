part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class ServicesUninitializedState extends ServicesState {}

class CompletedSplashScreenState extends ServicesState {}

class ServicesInitializedState extends ServicesState {}
