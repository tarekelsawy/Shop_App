import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app3/layout/shop_app/cubit/states.dart';
import 'package:shop_app3/modules/search/search_screen.dart';
import 'package:shop_app3/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app3/shared/components/components.dart';
import 'package:shop_app3/shared/styles/colors.dart';

import '../../shared/network/local/cashe_helper.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopAppCubit cubit = ShopAppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Salla',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context: context, widget: SearchScreen());
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: cubit.navBottomList[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            selectedItemColor: defaultColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            onTap: (int index) {
              cubit.changeNavBarIndex(index);
            },
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.category,
                ),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_outlined,
                ),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: 'Setting',
              ),
            ],
          ),
        );
      },
    );
  }
}
