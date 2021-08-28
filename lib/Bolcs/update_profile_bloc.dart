import 'package:BeauT_Stylist/Bolcs/signupBloc.dart';
import 'package:BeauT_Stylist/helpers/static_data.dart';
import 'package:BeauT_Stylist/models/login_model.dart';
import 'package:bloc/bloc.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/repo/user_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class UpdateProfileBloc extends Bloc<AppEvent, AppState> {
  @override
  AppState get initialState => Start(null);

  final name = BehaviorSubject<String>();
  final beaut_name = BehaviorSubject<String>();

  final email = BehaviorSubject<String>();
  final mobile = BehaviorSubject<String>();

  final newPassword = BehaviorSubject<String>();
  final CurrentPassword = BehaviorSubject<String>();
  final NewpasswordConfirmation = BehaviorSubject<String>();

  Function(String) get updateBeautName => beaut_name.sink.add;

  Function(String) get updateEmail => email.sink.add;

  Function(String) get updateName => name.sink.add;

  Function(String) get updateMobile => mobile.sink.add;

  Function(String) get updateNewPassword => newPassword.sink.add;

  Function(String) get updateCurrentPassword => CurrentPassword.sink.add;

  Function(String) get updateConfirmPassword => NewpasswordConfirmation.sink.add;
  String msg;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    print("------ city id -------- : ${signUpBloc.city_id.value}");
    if (event is Click) {
      print("profile 1-1");
      yield Loading(null);
      print("profile 1-2");

      var userResponee = await UserDataRepo.UpdateProfileApi(
          name: name.value,
          paymentMethdos: event.paymentMethdos,
          email:   email.value,
          city_id: signUpBloc.city_id.value,
          beaut_name:  beaut_name.value,
          confirmPassword:  NewpasswordConfirmation.value,
          currentPassword:    CurrentPassword.value,
          mobile: mobile.value,
          newPassword: newPassword.value,
          photo:event.user_photo
      );
      print("userResponee : ${userResponee}");
      print("profile 1-3");

      print("Update Response ResPonse" + userResponee.msg);
      if (userResponee.status == true) {
        print("profile 1-4");
        SharedPreferenceManager preferenceManager = SharedPreferenceManager();
        preferenceManager.writeData(CachingKey.IS_LOGGED_IN, true);
        yield Done(userResponee);


        print("profile 1-5");

        yield Done(userResponee);
      } else if (userResponee.status == false) {
        print("profile 1-6");
        yield ErrorLoading(userResponee);
      }
    }
  }
}

final updateProfileBloc = UpdateProfileBloc();
