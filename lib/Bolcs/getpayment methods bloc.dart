import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/repo/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllPaymentMethods extends Bloc<AppEvent, AppState> {
  @override
  AppState get initialState => Start(null);

  var ress;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is Hydrate) {
      yield Start(null);
      ress = await UserDataRepo.getPaymentMethods();
      print("Status " + ress.status.toString() + "");
      yield Done(ress);
    }
  }
}

final allPaymentMethods = AllPaymentMethods();
