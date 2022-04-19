class ToggleFavoriteModel {
  late bool status;
  late String message;
  ToggleFavoriteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
