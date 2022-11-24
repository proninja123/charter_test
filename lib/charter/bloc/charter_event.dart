part of 'charter_bloc.dart';

abstract class CharterEvent {}

class GetCharterEvent extends CharterEvent {
  final String search;
  GetCharterEvent({required this.search});
}

class AddCharterEvent extends CharterEvent {
  final Map<String, Map> data;
  AddCharterEvent({required this.data});
}

class LoginEvent extends CharterEvent {}
