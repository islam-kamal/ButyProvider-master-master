import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/models/current_ordera_model.dart';
import 'package:BeauT_Stylist/repo/user_journy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CurrentOrdersBloc extends Bloc<AppEvent, AppState> {
  @override
  AppState get initialState => Start(null);
  final type = BehaviorSubject<String>();

  Function(String) get updateType => type.sink.add;
  var ress;
  final BehaviorSubject<CurrentOrdersResponse> _subject = BehaviorSubject<CurrentOrdersResponse>();
  @override
  get subject {
    return _subject;
  }

  final BehaviorSubject<CurrentOrdersResponse> _fnished_reservations_subject = BehaviorSubject<CurrentOrdersResponse>();
  @override
  get fnished_reservations_subject {
    return _fnished_reservations_subject;
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is CurrentReservatiosnEvent) {
      yield Loading(null);
      print("current 1");
      var ress = await UserJourny.GETCURRENTORDERS();
      print("ress : $ress" );

      if(ress.status == true){

        _subject.sink.add(ress);
        yield Done(ress);
      }else{
        yield ErrorLoading(ress);
      }



    }else  if (event is FinishedReservatiosnEvent) {
      yield Loading(null);
      print("finish  1");
      var ress = await UserJourny.GETDONEORDERS();
      print("ress : $ress" );
      if(ress.status == true){

        _fnished_reservations_subject.sink.add(ress);
        yield Done(ress);
      }else{
        yield ErrorLoading(ress);
      }


    }
  }
}

final currentOrdersBloc = CurrentOrdersBloc();
