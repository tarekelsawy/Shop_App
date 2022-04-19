import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/models/shop/shop_app_model.dart';
import 'package:shop_app3/modules/shop_login_screen/cubit/shop_states.dart';
import 'package:shop_app3/modules/shop_register_screen/cubit/states.dart';
import 'package:shop_app3/shared/network/remote/dio_helper.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/network/end_point.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(BuildContext context) =>
      BlocProvider.of(context);

  static bool isSecure = true;
  late ShopLoginModel RegisterData;

  void shopRegisterPasswordIsSecure() {
    isSecure = !isSecure;
    emit(ShopRegisterPasswordIsSecureState());
  }

  shopRegisterPostData({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(url: REGISTER, data: {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
    }).then((value) {
      RegisterData = ShopLoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessState(RegisterData));
    }).catchError((error) {
      print(error.toString());
      emit(
        ShopRegisterErrorState(
          error: error.toString(),
        ),
      );
    });
  }
}
