import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/api_services.dart';
import '../../../core/helpers/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final ApiServices _apiServices = ApiServices();

  /// Login
  Future<void> login(Map<String, dynamic> data) async {
    emit(LoginLoading());
    try {
      Response response = await _apiServices.login('token', data);
      if (response.statusCode == 200) {
        await SharedPref.saveToken(response.data["access_token"]);
        emit(LoginSuccess());

        /// Save the token in the local storage by SharedPreference
      } else {
        emit(LoginError(messageError: response.data["msg"]));
      }
    } catch (e) {
      emit(
        LoginError(messageError: 'Some thing went wrong, please try again!'),
      );
      log(e.toString());
    }
  }
}
