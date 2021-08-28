
import 'dart:io';

abstract class AppEvent {}

class Click extends AppEvent {
  List<int> paymentMethdos ;
  File user_photo;
  Click({this.paymentMethdos,this.user_photo});
}

class ChangePhone extends AppEvent {}

class ChangeName extends AppEvent {}

class ChangePassword extends AppEvent {}

class ChangeEmail extends AppEvent {}

class Delete extends AppEvent {}

class Add extends AppEvent {}

class AnimationEnd extends AppEvent {}

class Hydrate extends AppEvent {}

class UploadScheduleEvent extends AppEvent {
  List<String> day_date;
  List schedule_data;
  UploadScheduleEvent({this.day_date,this.schedule_data});
}

class TimesEvent extends AppEvent {
  final String date;
  TimesEvent({this.date});
}
class CurrentReservatiosnEvent extends AppEvent{}

class FinishedReservatiosnEvent extends AppEvent{}