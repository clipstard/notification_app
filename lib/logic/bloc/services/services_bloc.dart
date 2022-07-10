import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc() : super(ServicesUninitializedState());

  ServicesState get initialState => ServicesUninitializedState();

  @override
  Stream<ServicesState> mapEventToState(ServicesEvent event) async* {
    if (event is ServicesInitialized) {
      yield ServicesInitializedState();
    } else if (event is SplashScreenPlayed) {
      yield CompletedSplashScreenState();
    }
  }

  String toJson(String state) {
    return json.encode(state);
  }

  static ServicesBloc? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }
}
