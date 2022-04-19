import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/models/shop/shop_app_model.dart';
import 'package:shop_app3/modules/shop_login_screen/cubit/shop_states.dart';
import 'package:shop_app3/shared/network/remote/dio_helper.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/network/end_point.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(BuildContext context) => BlocProvider.of(context);

  static bool isSecure = true;
  late ShopLoginModel loginData;

  void shopLoginPasswordIsSecure() {
    isSecure = !isSecure;
    emit(ShopLoginPasswordIsSecureState());
  }

  shopLoginGetData({required String email, required String password}) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(url: LOGIN, data: {
      'email': email,
      'password': password,
    }).then((value) {
      loginData = ShopLoginModel.fromJson(value.data);
      emit(ShopLoginSuccessState(loginData));
    }).catchError((error) {
      print(error.toString());
      emit(ShopLoginErrorState(error: error.toString(),),);
    });
  }
}
