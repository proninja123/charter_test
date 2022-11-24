part of 'charter_bloc.dart';

abstract class CharterState {}

class CharterInitial extends CharterState {}

class Loading extends CharterState {}

class LoadingEnd extends CharterState {
  final bool error;

  LoadingEnd({this.error = false});
}

class ErrorState extends CharterState {
  final String error;

  ErrorState(this.error);
}

class GetCharterSuccessState extends CharterState {
  final CharterListResponse response;
  GetCharterSuccessState(this.response);
}

class AddCharterSuccessState extends CharterState {}

class LoginSuccessState extends CharterState {}
