import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app3/models/shop/categories_model.dart';
import 'package:shop_app3/models/shop/home_model.dart';
import 'package:shop_app3/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app3/shared/styles/colors.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../layout/shop_app/cubit/states.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopAppSuccessToggleFavoritesState) {
          if (state.model.status) {
            showToast(
                message: state.model.message, toastStatus: ToastStatus.SUCCESS);
          } else {
            showToast(
                message: state.model.message, toastStatus: ToastStatus.FAILD);
          }
        }
      },
      builder: (context, state) {
        ShopAppCubit cubit = ShopAppCubit.get(context);
        return (cubit.homeModel != null && cubit.categoriesModel != null)
            ? ProductBuilder(cubit.homeModel, cubit.categoriesModel, context)
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget ProductBuilder(HomeModel? model, CategoriesModel? categoriesModel,
      BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselSlider(
            items: model!.data!.banners
                .map(
                  (e) => FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: '${e.image}',
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 240,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 2),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: AlignmentDirectional.centerStart,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 100,
                  child: ListView.separated(
                    padding: EdgeInsets.all(5.0),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return buildCategoriesItem(
                          categoriesModel!.data!.data[index]);
                    },
                    itemCount: categoriesModel!.data!.data.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 100,
                        thickness: 10,
                        color: Colors.white,
                        indent: 10,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 2,
            ),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.35,
              shrinkWrap: true,
              crossAxisSpacing: 5,
              mainAxisSpacing: 7,
              padding: EdgeInsets.all(4),
              physics: BouncingScrollPhysics(),
              children: List.generate(
                model.data!.products.length,
                (index) =>
                    BuildProductItem(model.data!.products[index], context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget BuildProductItem(ProductsModel model, BuildContext context) {
  return Container(
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
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: '${model.image}',
                height: 180,
                width: double.infinity,
              ),
              if (model.discount != 0)
                Container(
                  color: Colors.amber,
                  child: Text(
                    'DISCOUNT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${model.name}',
            style: TextStyle(
              height: 1.1,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),
          Row(
            children: [
              Text(
                '${model.price}',
                style: TextStyle(
                  color: defaultColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              if (model.discount != 0)
                Text(
                  '${model.oldPrice}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 10.0,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              Spacer(),
              IconButton(
                onPressed: () {
                  ShopAppCubit.get(context).toggleFavorites(model.id);
                },
                icon: Icon(
                  Icons.favorite,
                  color: ShopAppCubit.get(context).favorites[model.id] ?? true
                      ? defaultColor
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildCategoriesItem(DataModel model) {
  return Container(
    width: 100,
    height: 100,
    padding: EdgeInsets.all(5.0),
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
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: '${model.image}',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
          width: double.infinity,
          child: Expanded(
            child: Text(
              '${model.name}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    ),
  );
}
