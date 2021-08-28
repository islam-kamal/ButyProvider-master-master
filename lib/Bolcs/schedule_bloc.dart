import 'package:BeauT_Stylist/NetWorkUtil.dart';
import 'package:BeauT_Stylist/UI/Schedule/schedule_data_model.dart';
import 'file:///D:/Wothoq%20Tech/Buty/code/ButyProvider-master-master/lib/UI/Schedule/work_schedule_model.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/repo/schedule_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ScheduleBloc extends Bloc<AppEvent, AppState>{
  @override
  AppState get initialState => Start(null);

  final BehaviorSubject<ScheduleDataModel> _times_subject = BehaviorSubject<ScheduleDataModel>();

  get times_subject {
    return _times_subject;
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async*{
    if(event is UploadScheduleEvent){
      yield Loading(null);

      var response = await ScheduleRepo.upload_schedule(
          day_date: event.day_date,
        schedule_data: event.schedule_data
      );

      if(response.status == true){
        yield Done(response);
      }else{
        yield ErrorLoading(response);
      }
    }else  if(event is TimesEvent){
      yield Loading(null,indicator: 'times');

      var response = await ScheduleRepo.getAllDayTimes(
          date: event.date,
      );
      print("-------- response ------- ${response}");
      if(response.status == true){
        _times_subject.sink.add(response);
        yield Done(response,indicator: 'times');
      }else{
        yield ErrorLoading(response,indicator: 'times');
      }
    }
}


}
final schedule_bloc = ScheduleBloc();