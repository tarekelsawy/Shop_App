import 'package:shop_app3/models/shop/favorite.dart';

abstract class ShopStates {}

class ShopAppInitialState extends ShopStates {}

class ShopAppChangeNavBotBarState extends ShopStates {}

// HOME
class ShopAppLoadingHomeDataState extends ShopStates {}

class ShopAppSuccessHomeDataState extends ShopStates {}

class ShopAppErrorHomeDataState extends ShopStates {}

// CATEGORY
class ShopAppLoadingCategoriesDataState extends ShopStates {}

class ShopAppSuccessCategoryDataState extends ShopStates {}

class ShopAppErrorCategoryDataState extends ShopStates {}

//change user favorites
class ShopAppToggleFavoritesState extends ShopStates {}

class ShopAppSuccessToggleFavoritesState extends ShopStates {
  ToggleFavoriteModel model;
  ShopAppSuccessToggleFavoritesState(this.model);
}

class ShopAppErrorToggleFavoritesState extends ShopStates {}

//get authorized favorites
class ShopAppSuccessGetFavoritesState extends ShopStates {}

class ShopAppErrorGetFavoritesState extends ShopStates {}

class ShopAppLoadingGetFavoritesState extends ShopStates {}

//user data
class ShopAppSuccessGetUserDataState extends ShopStates {}

class ShopAppErrorGetUserDataState extends ShopStates {}

class ShopAppLoadingGetUserDataState extends ShopStates {}

//update user data
class ShopAppSuccessUpdateUserDataState extends ShopStates {}

class ShopAppErrorUpdateUserDataState extends ShopStates {}

class ShopAppLoadingUpdateUserDataState extends ShopStates {}
