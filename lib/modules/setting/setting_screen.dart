import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app3/layout/shop_app/cubit/states.dart';
import 'package:shop_app3/shared/components/components.dart';
import 'package:shop_app3/shared/styles/colors.dart';

import '../../shared/network/local/cashe_helper.dart';
import '../shop_login_screen/shop_login_screen.dart';

class SettingScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopAppCubit cubit = ShopAppCubit.get(context);
        if (cubit.userModel != null) {
          nameController.text = cubit.userModel!.data!.name.toString();
          emailController.text = cubit.userModel!.data!.email.toString();
          phoneController.text = cubit.userModel!.data!.phone.toString();
        }
        return cubit.userModel != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      children: [
                        if (state is ShopAppLoadingUpdateUserDataState)
                          LinearProgressIndicator(),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultTextFormField(
                          controller: nameController,
                          validator: (String? val) {
                            if (val == null || val.isEmpty) {
                              return 'type your Name';
                            }
                          },
                          onFieldSubmitted: (String val) {},
                          keyboardType: TextInputType.name,
                          labelText: 'Name',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        defaultTextFormField(
                          controller: emailController,
                          validator: (String? val) {
                            if (val == null || val.isEmpty) {
                              return 'type your Email';
                            }
                          },
                          onFieldSubmitted: (String val) {},
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'Email',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        defaultTextFormField(
                          controller: phoneController,
                          validator: (String? val) {
                            if (val == null || val.isEmpty) {
                              return 'type your phone';
                            }
                          },
                          onFieldSubmitted: (String val) {},
                          keyboardType: TextInputType.phone,
                          labelText: 'Phone',
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultButton(
                          function: () {
                            if (globalKey.currentState!.validate()) {
                              cubit.updateUserData(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                          child: 'UPDATE',
                          buttonColor: defaultColor,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultButton(
                          function: () {
                            CasheHelper.removeData(key: 'token').then(
                              (value) {
                                if (value) {
                                  cubit.currentIndex = 0;
                                  navigateAndFinish(
                                    context: context,
                                    widget: ShopLoginScreen(),
                                  );
                                }
                              },
                            );
                          },
                          child: 'LOGOUT',
                          buttonColor: defaultColor,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
