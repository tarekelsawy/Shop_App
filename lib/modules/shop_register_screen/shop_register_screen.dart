import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/modules/shop_register_screen/cubit/cubit.dart';
import 'package:shop_app3/modules/shop_register_screen/cubit/states.dart';

import '../../layout/shop_app/shop_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cashe_helper.dart';
import '../../shared/styles/colors.dart';
import '../shop_login_screen/cubit/shop_cubit.dart';
import '../shop_login_screen/shop_login_screen.dart';

class ShopRegisterScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.RegisterModel.status == true) {
              CasheHelper.saveData(
                key: 'token',
                value: state.RegisterModel.data!.token.toString(),
              ).then(
                (value) {
                  token = state.RegisterModel.data!.token.toString();
                  navigateAndFinish(
                    context: context,
                    widget: ShopLayout(),
                  );
                },
              );
            } else {
              showToast(
                  message: state.RegisterModel.message.toString(),
                  toastStatus: ToastStatus.FAILD);
            }
          }
        },
        builder: (context, state) {
          ShopRegisterCubit cubit = ShopRegisterCubit.get(context);
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
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontFamily: 'Lobster',
                                  ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Register to take hot offers',
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
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'type your name';
                            }
                          },
                          onFieldSubmitted: (String value) {},
                          labelText: 'type your name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        const SizedBox(
                          height: 10.0,
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
                          suffix: ShopRegisterCubit.isSecure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onPressed: () {
                            cubit.shopRegisterPasswordIsSecure();
                          },
                          isSecure: ShopLoginCubit.isSecure,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'type your phone';
                            }
                          },
                          onFieldSubmitted: (String value) {},
                          labelText: 'type your phone',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        const SizedBox(
                          height: 13.0,
                        ),
                        state is! ShopRegisterLoadingState
                            ? Container(
                                width: double.infinity,
                                color: defaultColor,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(22.0)),
                                  onPressed: () {
                                    if (_globalKey.currentState!.validate()) {
                                      cubit.shopRegisterPostData(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                        phone: phoneController.text,
                                      );
                                    }
                                  },
                                  child: Text(
                                    'register'.toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'Lobster',
                                    ),
                                  ),
                                ),
                              )
                            : Center(child: CircularProgressIndicator()),
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
