import 'dart:convert';

import '../core/episodes/check_episode.dart';
import '../core/shared/response_content.dart';
import '../core/shared/status_and_types.dart';
import '../helper/api_helper.dart';
import '../helper/end_point.dart';

class CheckEpisodeService {
  final ApiHelper _apiHelper = ApiHelper();
  Future<ResponseContent> postCheckhalaqat(List id) async {
    Map<String, dynamic> data = {
      "data": {"halaqat": id}
    };
    ResponseContent response = await _apiHelper.postV2(
        EndPoint.checkHalaqat, jsonEncode(data),
        linkApi: "http://rased-api.maknon.org.sa",
        contentType: ContentTypeHeaders.applicationJson);
    if (response.success ?? false) {
      try {
        response.data = CheckEpisode.fromJson(response.data);
        return response;
      } catch (e) {
        return ResponseContent(
            statusCode: '1', message: '#Convert-Response#\n${e.toString()}');
      }
    } else if (response.isBadRequest) {
      response.message = 'BadRequest';
    } else if (response.isNotFound) {
      response.message = 'NotFound';
    } else if (response.isNoContent) {
      response.message = 'NoContent';
    }
    return response;
    // if (response.isSuccess) {
    //   try {
    //     response.data = CheckEpisode.fromJson(response.data);
    //     return response;
    //   } catch (e) {
    //     return ResponseContent(
    //         statusCode: '1', message: '#Convert-Response#\n${e.toString()}');
    //   }
    // } else {
    //   return response;
    // }
  }
}
