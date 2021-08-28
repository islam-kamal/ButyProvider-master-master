import 'package:bloc/bloc.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/repo/user_journy.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class CanselOrderBloc extends Bloc<AppEvent, AppState> {
  @override
  AppState get initialState => Start(null);

  final order_id = BehaviorSubject<int>();
  final status = BehaviorSubject<int>();
  final reason = BehaviorSubject<String>();

  Function(int) get updateId => order_id.sink.add;

  Function(int) get updateStatus => status.sink.add;
  Function(String) get cancel_reason => reason.sink.add;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is Click) {
      yield (Start(null));
      yield Loading(null);
      print("id : ${order_id.value}");
      print("status : ${status.value}");
      print("reason : ${reason.value}");
      var userResponee =
          await UserJourny.CanselOrder(order_id.value, status.value,reason.value);
      print("cancel order  Response  : ${userResponee}" );
      if (userResponee.status == true) {
        print("Donee");
        yield Done(userResponee);
      } else if (userResponee.status == false) {
        print("Message   ");
        yield ErrorLoading(userResponee);
      }
    }
  }
}

final canselOrderbloc = CanselOrderBloc();
