import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/models/shop/settings_model.dart';
import 'package:shop_app3/modules/search/cubit/states.dart';
import 'package:shop_app3/shared/network/end_point.dart';
import 'package:shop_app3/shared/network/remote/dio_helper.dart';

class ShopSearchCubit extends Cubit<ShopSearchStates> {
  ShopSearchCubit() : super(ShopSearchInitialState());

  static ShopSearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel = SearchModel.fromJson({});
  void PostSearch({required String text}) {
    emit(ShopSearchLoadingState());
    DioHelper.postData(
      url: SEARCH_PRODUCT,
      data: {"text": text},
    ).then((value) {
      print('hello');
      searchModel = SearchModel.fromJson(value.data);
      emit(ShopSearchSuccessState());
    }).catchError((onError) {
      print(onError);
      emit(ShopSearchErrorState());
    });
  }
}
