import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app3/layout/shop_app/shop_layout.dart';
import 'package:shop_app3/shared/components/constants.dart';
import 'package:shop_app3/shared/network/local/cashe_helper.dart';

import 'modules/onboarding/onboarding_screen.dart';
import 'modules/shop_login_screen/shop_login_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/styles/colors.dart';

void main() async {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      DioHelper.dioInit();
      await CasheHelper.init();
      Widget startWidget = OnBoardingScreen();
      dynamic onBoarding = CasheHelper.getData(key: 'onBoarding');
      token = CasheHelper.getData(key: 'token');

      print(token);
      if (onBoarding != null) {
        if (token != null) {
          print('on!tok!');

          startWidget = ShopLayout();
        } else {
          print('on!tok?');
          startWidget = ShopLoginScreen();
        }
      } else {
        print('on?tok?');
        startWidget = OnBoardingScreen();
      }
      runApp(MyApp(
        startWidget: startWidget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  Widget startWidget;
  MyApp({required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopAppCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.deepPurple,
            elevation: 10,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            elevation: 0.0,
          ),
          primarySwatch: defaultColor,
          textTheme: TextTheme(
            headline5: TextStyle(fontFamily: 'Lobster'),
          ),
        ),
        home: startWidget,
      ),
    );
  }
}
