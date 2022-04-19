import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app3/layout/shop_app/cubit/states.dart';
import 'package:shop_app3/models/shop/get_favorites.dart';
import 'package:shop_app3/shared/styles/colors.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopStates>(
      builder: (context, state) {
        ShopAppCubit cubit = ShopAppCubit.get(context);
        return state is! ShopAppLoadingGetFavoritesState
            ? ListView.builder(
                itemCount: cubit.favoritesModel.data!.data!.length,
                itemBuilder: (context, index) {
                  return buildItemOfList(
                      cubit.favoritesModel.data!.data![index].product, cubit);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
      listener: (context, state) {},
    );
  }
}
