import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app3/modules/search/cubit/cubit.dart';
import 'package:shop_app3/modules/search/cubit/states.dart';
import 'package:shop_app3/shared/components/components.dart';
import 'package:shop_app3/shared/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopSearchCubit(),
      child: BlocConsumer<ShopSearchCubit, ShopSearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ShopSearchCubit cubit = ShopSearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: () {
                          cubit.PostSearch(text: searchController.text);
                        },
                        icon: Icon(Icons.search),
                      ),
                      labelText: 'Type To Search',
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Lobster',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        gapPadding: 2.0,
                      ),
                    ),
                    onFieldSubmitted: (String value) {
                      cubit.PostSearch(text: searchController.text);
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  if (state is ShopSearchLoadingState)
                    LinearProgressIndicator(
                      color: defaultColor,
                    ),
                  if (state is ShopSearchSuccessState)
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return buildItemOfList(
                              cubit.searchModel!.data!.product![index], cubit,
                              fromSearch: true);
                        },
                        itemCount: cubit.searchModel!.data!.product!.length,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
