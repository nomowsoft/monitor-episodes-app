// ignore_for_file: unnecessary_this

class ResponseContent<T> {
  T? data;
  bool? success;
  String? message;
  String? statusCode;
  ResponseContent(
      {this.data, this.success = false, this.message, this.statusCode});

  ResponseContent.fromJson(Map<String, dynamic> jsonMap, int statusCode) {
    data = jsonMap as T?;
    success = jsonMap['result']['success'] ?? false;
    message = success! ? null : jsonMap['result']['error'];
    this.statusCode = statusCode.toString();
  }
  ResponseContent.fromGetJson(Map<String, dynamic> jsonMap, int statusCode) {
    data = jsonMap as T?;
    success = jsonMap['success'] ?? false;
    message = success! ? null : jsonMap['error'];
    this.statusCode = statusCode.toString();
  }

  // ResponseContent.fromJson(Map<String, dynamic> jsonMap,int statusCode) {
  //   data = jsonMap as T?;
  //   success = jsonMap['status']??((statusCode <= 200 &&  statusCode < 299)? true : false);
  //   message = data !=null ? jsonMap['success']?.toString() ?? jsonMap['error'] :null;
  //   this.statusCode = statusCode.toString();
  //   }

  //   ResponseContent.fromJsonv1(Map<String, dynamic> jsonMap,int statusCode) {
  //   data = jsonMap as T?;
  //   success = false;
  //  // message = data !=null ? jsonMap['success']?.toString() ?? jsonMap['error'] :null;
  //   this.statusCode = success!? statusCode.toString():'400';
  //   }
  //      ResponseContent.fromJsonv2(Map<String, dynamic> jsonMap,int statusCode) {
  //   data = jsonMap as T?;
  //   success = jsonMap['result']['success']?? false;
  //  // message = data !=null ? jsonMap['success']?.toString() ?? jsonMap['error'] :null;
  //   this.statusCode = success!? statusCode.toString():'400';
  //   }

  ResponseContent.fromJsonList(T value, int statusCode) {
    data = value;
    success = ((statusCode <= 200 && statusCode < 299) ? true : false);
    message = null;
    this.statusCode = statusCode.toString();
  }
  // ResponseContent.fromJsonListError(Map<String, dynamic> jsonMap) {
  // data = jsonMap['data'];
  // success = (statusCode <= 200 &&  statusCode < 299)?; jsonMap['success']??false;
  // message = jsonMap['message'];
  // error = jsonMap['error'].toString();
  // statusCode =  statusCode ;
  // }

  bool get isSuccess => (this.success ?? false);
  bool get isBadRequest =>
      (int.parse(this.statusCode!) >= 400 && int.parse(this.statusCode!) < 499);
  bool get isNoContent => (this.statusCode == '204');
  bool get isErrorConnection => (this.statusCode == '0');
  bool get isNotFound => (this.statusCode == '404');
}
