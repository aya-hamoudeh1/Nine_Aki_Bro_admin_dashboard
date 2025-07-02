import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/api_services.dart';

part 'add_admin_state.dart';

class AddAdminCubit extends Cubit<AddAdminState> {
  AddAdminCubit() : super(AddAdminInitial());

  final ApiServices _apiServices = ApiServices();

  /// Sign Up
  Future<void> createAnAccount(Map<String, dynamic> data) async {
    emit(AddAdminLoading());
    try {
      emit(AddAdminLoading());
      Response response = await _apiServices.createAnAccount('signup', data);
      if (response.statusCode == 200) {
        emit(AddAdminSuccess());
      } else {
        emit(AddAdminError(messageError: response.data["msg"]));
      }
    } catch (e) {
      emit(
        AddAdminError(messageError: 'Some thing went wrong, please try again!'),
      );
      log(e.toString());
    }
  }
}
