import 'package:BeauT_Stylist/helpers/network-mappers.dart';

abstract class AppState {
  get model => null;
}

class NameError extends AppState {}

class PasswordError extends AppState {}

class EmailError extends AppState {}

class MobileError extends AppState {}

class AddressError extends AppState {}

class NumberError extends AppState {}

class Done extends AppState {
  Mappable model;
final String indicator;
  Done(this.model,{this.indicator});

  @override
  String toString() => 'Done';
}

class Start extends AppState {
  Mappable model;

  Start(this.model);

  @override
  String toString() => 'Start';
}

class Loading extends AppState {
  Mappable model;
  final String indicator;
  Loading(this.model,{this.indicator});

  @override
  String toString() => 'Loading';
}

class ErrorLoading extends AppState {
  Mappable model;
  final String indicator;
  ErrorLoading(this.model,{this.indicator});

  @override
  String toString() => 'Error';
}

class DeleteState extends AppState {
  Mappable model;

  DeleteState(this.model);

  @override
  String toString() => 'Delete';
}

class SendState extends AppState {
  Mappable model;

  SendState(this.model);

  @override
  String toString() => 'Delete';
}
