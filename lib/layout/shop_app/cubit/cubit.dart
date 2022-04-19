import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/layout/shop_app/cubit/states.dart';
import 'package:shop_app3/models/shop/get_favorites.dart';
import 'package:shop_app3/models/shop/home_model.dart';
import 'package:shop_app3/models/shop/shop_app_model.dart';
import 'package:shop_app3/modules/categories/categories_screen.dart';
import 'package:shop_app3/modules/favourites/favourites_screen.dart';
import 'package:shop_app3/modules/products/products_screen.dart';
import 'package:shop_app3/modules/setting/setting_screen.dart';

import '../../../models/shop/categories_model.dart';
import '../../../models/shop/favorite.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/end_point.dart';
import '../../../shared/network/remote/dio_helper.dart';

class ShopAppCubit extends Cubit<ShopStates> {
  ShopAppCubit() : super(ShopAppInitialState());

  static ShopAppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List navBottomList = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingScreen(),
  ];
  HomeModel? homeModel;
  void changeNavBarIndex(int newIndex) {
    currentIndex = newIndex;
    emit(ShopAppChangeNavBotBarState());
  }

  void getHomeData() async {
    emit(ShopAppLoadingHomeDataState());
    await DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      emit(ShopAppLoadingHomeDataState());
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products.forEach((product) {
        favorites.addAll({product.id: product.inFavorites});
      });
      print('favorites:$favorites');
      emit(ShopAppSuccessHomeDataState());
    }).catchError((onError) {
      print('error:$onError');
      emit(ShopAppErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategoriesData() async {
    emit(ShopAppLoadingCategoriesDataState());
    await DioHelper.getData(
      url: CATEGORIES,
      token: token,
    ).then((value) {
      print(' cat:${value.data}');
      categoriesModel = CategoriesModel.fromJson(value.data);
      print('name ::::${categoriesModel!.data!.data[1].name}');
      emit(ShopAppSuccessCategoryDataState());
    }).catchError((onError) {
      print(onError.toString());
      emit(ShopAppErrorCategoryDataState());
    });
  }

  late ToggleFavoriteModel toggleFavoriteModel;
  Map<int, bool> favorites = {};

  void toggleFavorites(int productId) {
    favorites[productId] = !(favorites[productId] ?? false);
    emit(ShopAppToggleFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      toggleFavoriteModel = ToggleFavoriteModel.fromJson(value.data);
      if (!toggleFavoriteModel.status) {
        favorites[productId] = !(favorites[productId] ?? false);
      } else {
        getFavorites();
      }
      emit(ShopAppSuccessToggleFavoritesState(toggleFavoriteModel));
    }).catchError((onError) {
      favorites[productId] = !(favorites[productId] ?? false);
      emit(ShopAppErrorToggleFavoritesState());
    });
  }

  late FavoritesModel favoritesModel;
  void getFavorites() {
    emit(ShopAppLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      print('getFavorites id:${favoritesModel.data!.data![1].product!.id}');
      emit(ShopAppSuccessGetFavoritesState());
    }).catchError((onError) {
      emit(ShopAppErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;
  void getUserData() {
    emit(ShopAppLoadingGetUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopAppSuccessGetUserDataState());
    }).catchError((onError) {
      print('error:${onError.toString()}');
      emit(ShopAppErrorGetUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopAppLoadingUpdateUserDataState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        "name": name,
        "phone": phone,
        "email": email,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(ShopAppSuccessUpdateUserDataState());
    }).catchError((onError) {
      emit(ShopAppErrorUpdateUserDataState());
    });
  }
}
