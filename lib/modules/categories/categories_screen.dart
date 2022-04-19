import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/layout/shop_app/cubit/states.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../layout/shop_app/cubit/cubit.dart';
import '../../models/shop/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopAppCubit cubit = ShopAppCubit.get(context);
        return ListView.separated(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return buildCategoryItem(cubit.categoriesModel!.data!.data[index]);
          },
          separatorBuilder: (context, index) {
            return Divider(
              indent: 10,
            );
          },
          itemCount: cubit.categoriesModel!.data!.data.length,
        );
      },
    );
  }

  Widget buildCategoryItem(DataModel model) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(
                0.1,
                0.1,
              ),
              blurRadius: 10.0,
              spreadRadius: 0.5,
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: '${model.image}',
              height: 80,
              width: 80,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '${model.name}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }
}
