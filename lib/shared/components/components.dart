import 'package:flutter/material.dart';
import 'package:shop_app3/shared/styles/colors.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../layout/shop_app/cubit/cubit.dart';

navigateTo({
  required BuildContext context,
  required widget,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ),
  );
}

navigateAndFinish({required BuildContext context, required Widget widget}) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
    return widget;
  }), (route) => false);
}

Widget defaultTextFormField({
  required TextEditingController controller,
  required String? Function(String?) validator,
  required Function(String) onFieldSubmitted,
  TextInputType? keyboardType,
  void Function()? onPressed,
  Function(String)? onChanged,
  Icon? prefixIcon,
  IconData? suffix,
  String? labelText,
  bool? isSecure = false,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      filled: true,
      prefixIcon: prefixIcon,
      suffixIcon: IconButton(
        onPressed: onPressed,
        icon: Icon(suffix),
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        fontSize: 12,
        fontFamily: 'Lobster',
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          8,
        ),
        gapPadding: 2.0,
      ),
    ),
    onFieldSubmitted: onFieldSubmitted,
    onChanged: onChanged,
    validator: validator,
    obscureText: isSecure ?? false,
  );
}

Widget defaultButton({
  Color buttonColor = Colors.blue,
  double width = double.infinity,
  required VoidCallback function,
  required String child,
  bool isUpperCase = true,
}) =>
    MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      clipBehavior: Clip.antiAlias,
      color: buttonColor,
      height: 45,
      minWidth: width,
      textColor: Colors.white,
      onPressed: function,
      child: Text(isUpperCase ? '$child'.toUpperCase() : '$child'),
    );

Widget buildItemOfList(model, cubit, {bool fromSearch = false}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
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
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: '${model.image}',
                height: 120,
                width: 120,
              ),
              if (fromSearch != true && model.discount != 0)
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
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Text(
                    '${model.name}',
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                if (fromSearch == true)
                  Text(
                    '${model.price}',
                    style: TextStyle(
                      color: defaultColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                if (fromSearch != true)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                      if (fromSearch != true && model.discount != 0)
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
                          cubit.toggleFavorites(model.id);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: cubit.favorites[model.id] ?? true
                              ? defaultColor
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
