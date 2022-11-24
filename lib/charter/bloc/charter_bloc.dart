import 'package:charter_app/charter/models/charter_list_response.dart';
import 'package:charter_app/charter/models/login_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'charter_event.dart';
part 'charter_state.dart';

class CharterBloc extends Bloc<CharterEvent, CharterState> {
  Dio dio = Dio();

  CharterBloc() : super(CharterInitial()) {
    on<CharterEvent>((event, emit) {});
    on<GetCharterEvent>(onGetCharterEvent);
    on<AddCharterEvent>(onAddCharterEvent);
    on<LoginEvent>(onLoginEvent);
  }

  onGetCharterEvent(GetCharterEvent event, Emitter<CharterState> emit) async {
    emit(Loading());
    final prefs = await SharedPreferences.getInstance();
    try {
      var resp = await dio.get(
        "https://asia-southeast1-marlo-bank-dev.cloudfunctions.net/api_dev/contracts/charterers/search?charterer_name=${event.search}",
        options: Options(
          headers: {"authtoken": prefs.getString('token')},
        ),
      );

      if (resp.data == null) {
        emit(LoadingEnd());
        return emit(ErrorState("Data not found"));
      }

      emit(LoadingEnd());
      return emit(
          GetCharterSuccessState(CharterListResponse.fromJson(resp.data)));
    } on DioError catch (e) {
      emit(LoadingEnd(error: true));
      print("ERROR CAUGHT::::: $e");
      showtoast(e.response!.data["message"]);
      return emit(ErrorState(e.message));
    } catch (e) {
      emit(LoadingEnd(error: true));
      showtoast(e.toString());
      print("ERROR CAUGHT::::: $e");
      return emit(ErrorState("$e"));
    }
  }

  onAddCharterEvent(AddCharterEvent event, Emitter<CharterState> emit) async {
    emit(Loading());
    print("HEREEEEEEE IN ADD");
    final prefs = await SharedPreferences.getInstance();
    print("TOKEN::::: ${prefs.getString('token')}");
    try {
      var resp = await dio.post(
        "https://asia-southeast1-marlo-bank-dev.cloudfunctions.net/api_dev/contracts/charterers",
        data: event.data,
        options: Options(
          headers: {
            "authtoken": prefs.getString('token'),
            "content-type": "application/json"
          },
        ),
      );

      if (resp.data == null) {
        emit(LoadingEnd());
        return emit(ErrorState("Data not found"));
      }

      emit(LoadingEnd());
      return emit(AddCharterSuccessState());
    } on DioError catch (e) {
      print("ERROR CAUGHT::::: $e");
      showtoast(e.response!.data["error"]["message"]);
      emit(LoadingEnd());
      return emit(ErrorState(e.message));
    } catch (e) {
      print("ERROR CAUGHT::::: $e");
      showtoast(e.toString());
      emit(LoadingEnd());
      return emit(ErrorState("$e"));
    }
  }

  onLoginEvent(LoginEvent event, Emitter<CharterState> emit) async {
    emit(Loading());
    final prefs = await SharedPreferences.getInstance();
    print("HERE IN BLOC::::");
    try {
      var resp = await dio.post(
        "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBFiEDfEaaK6lBtIdxLXspmxGux1TGsCmg",
        data: {
          "email": "xihoh55496@dineroa.com",
          "password": "Marlo@123",
          "returnSecureToken": true
        },
      );

      if (resp.data == null) {
        emit(LoadingEnd());
        return emit(ErrorState("Data not found"));
      }

      LoginResponse login = LoginResponse.fromJson(resp.data);
      prefs.setString('token', login.idToken!);

      emit(LoadingEnd());
      return emit(LoginSuccessState());
    } on DioError catch (e) {
      emit(LoadingEnd());
      showtoast(e.response!.data["message"]);
      return emit(ErrorState(e.message));
    } catch (e) {
      emit(LoadingEnd());
      showtoast(e.toString());
      return emit(ErrorState("$e"));
    }
  }

  showtoast(String? message, [Toast duration = Toast.LENGTH_SHORT]) {
    Fluttertoast.showToast(
      msg: message!,
      toastLength: duration,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
