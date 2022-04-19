import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app3/modules/shop_register_screen/shop_register_screen.dart';
import 'package:shop_app3/shared/components/constants.dart';

import '../../layout/shop_app/shop_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cashe_helper.dart';
import '../../shared/styles/colors.dart';
import 'cubit/shop_cubit.dart';
import 'cubit/shop_states.dart';

class ShopLoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status == true) {
              CasheHelper.saveData(
                key: 'token',
                value: state.loginModel.data!.token.toString(),
              ).then((value) {
                token = state.loginModel.data!.token.toString();
                navigateAndFinish(
                  context: context,
                  widget: ShopLayout(),
                );
              });
            } else {
              showToast(
                  message: state.loginModel.message.toString(),
                  toastStatus: ToastStatus.FAILD);
            }
          }
        },
        builder: (context, state) {
          ShopLoginCubit cubit = ShopLoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontFamily: 'Lobster',
                                  ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Login to take hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                    fontFamily: 'Lobster',
                                  ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'type your email';
                            }
                          },
                          onFieldSubmitted: (String value) {},
                          labelText: 'type your email',
                          prefixIcon: Icon(Icons.email_outlined),
                          isSecure: false,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'type your password';
                            }
                          },
                          onFieldSubmitted: (String value) {},
                          labelText: 'type your password',
                          prefixIcon: Icon(Icons.password_outlined),
                          suffix: ShopLoginCubit.isSecure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onPressed: () {
                            cubit.shopLoginPasswordIsSecure();
                          },
                          isSecure: ShopLoginCubit.isSecure,
                        ),
                        const SizedBox(
                          height: 13.0,
                        ),
                        state is! ShopLoginLoadingState
                            ? Container(
                                width: double.infinity,
                                color: defaultColor,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(22.0)),
                                  onPressed: () {
                                    if (_globalKey.currentState!.validate()) {
                                      cubit.shopLoginGetData(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  child: Text(
                                    'login'.toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'Lobster',
                                    ),
                                  ),
                                ),
                              )
                            : Center(child: CircularProgressIndicator()),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Don\'t have an acount?',
                              style: TextStyle(
                                fontFamily: 'Lobster',
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(
                                    context: context,
                                    widget: ShopRegisterScreen());
                              },
                              child: const Text(
                                'REGISTER',
                                style: TextStyle(
                                  fontFamily: 'Lobster',
                                  color: defaultColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void showToast({required String message, required ToastStatus toastStatus}) {
  Fluttertoast.showToast(
    msg: message.toString(),
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(toastStatus: toastStatus),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastStatus { SUCCESS, FAILD, WARNNING }
Color chooseToastColor({required ToastStatus toastStatus}) {
  Color toastColor;
  switch (toastStatus) {
    case ToastStatus.SUCCESS:
      toastColor = Colors.green;
      break;
    case ToastStatus.FAILD:
      toastColor = Colors.red;
      break;
    case ToastStatus.WARNNING:
      toastColor = Colors.yellow;
      break;
  }
  return toastColor;
}
