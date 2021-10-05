import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hookezy/s/model/blocked_list_model.dart';
import 'package:hookezy/s/model/discover_list_model.dart';
import 'package:hookezy/s/model/fav_list_model.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/model/gift_list_model.dart';
import 'package:hookezy/s/model/leaderboard_model.dart';
import 'package:hookezy/s/model/my_earning_model.dart';
import 'package:hookezy/s/model/old_chat_model.dart';
import 'package:hookezy/s/model/payment_update_model.dart';
import 'package:hookezy/s/model/plan_model.dart';
import 'package:hookezy/s/model/random_user_model.dart';
import 'package:hookezy/s/model/recent_chat_model.dart';
import 'package:hookezy/s/model/rest_countries_model.dart';
import 'package:hookezy/s/model/user_profile_data.dart';
import 'package:hookezy/s/model/view_user_model.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/s/utils/quick_blox_local.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:ots/ots.dart';
import 'package:path/path.dart' as path;

import 'package:hookezy/s/my_earning/my_earning.dart';

class ApiRepository {
  static Future<PlanModel> getPlanModel() async {
    try {
      Dio dio = new Dio();
      Response response;
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/getPlans",
          data: {});
      print(response.data);
      return PlanModel.fromJson(response.data);
    } catch (error) {
      throw Exception(error);
    }
  }

  static Future<GetUserProfileModel> getUserProfile(int id) async {
    try {
      String ids = await SHelper.getUserId();
      print("My is ${ids}");
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({'userId': "${ids}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/currentUser",
          data: formData);
      print(response.data);
      return GetUserProfileModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<GetUserProfileModel> getUserProfileInitial(String ids) async {
    try {
      //String ids = await SHelper.getUserId();
      print("My is ${ids}");
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({'userId': "${ids}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/currentUser",
          data: formData);
      print(response.data);
      hideLoader();
      return GetUserProfileModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<UserProfileData> getUserProfileData(int id) async {
    try {
      String ids = await SHelper.getUserId();
      print("My is ${ids}");
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({'userId': "${ids}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/getMedia",
          data: formData);
      print("simple state ${response.data}");
      return UserProfileData.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<MyEarningModel> getMyEarning(int id) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({'userId': "${ids}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/myEarnings",
          data: formData);
      print(response.data);
      return MyEarningModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> updateUserProfile(
      UpdateUserProfileModel model) async {
    try {
      String ids = await SHelper.getUserId();
      print(model.toJson());
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({
        'userId': "${ids}",
        "about": model.about,
        "age": model.age.isNotEmpty ? model.age : "",
        "jobtitle": model.jobtitle.isNotEmpty ? model.jobtitle : "",
        "company": model.company.isNotEmpty ? model.company : "",
        "education": model.education.isNotEmpty ? model.education : "",
        "id": model.id,
        "role": "",
        "country": model.country.isNotEmpty ? model.country : "",
        "country_index": model.country_index != null ? model.country_index : "",
        "language": model.language.isNotEmpty ? model.language : "",
        "image": model.image != null
            ? await MultipartFile.fromFile(
                model.image.path,
                filename: model.image.path.split('/').last,
              )
            : "",
      });
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/update",
          data: formData);
      print("Update ${response}");
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> paymentUpdate(PaymentUpdateModel model) async {
    try {
      print("Ha :: ::: ::::: :::: :::: ${model.toJson()}");
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/purchaseCoin",
          data: model.toJson());
      print(response.data);
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }


  static Future<Response> tokenSubmit(PaymentUpdateModel model) async {
    try {
      print("Ha :: ::: ::::: :::: :::: ${model.toJson()}");
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/purchaseCoin",
          data: model.toJson());
      print(response.data);
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<List<RestCountriesModel>> getCountries(int id) async {
    try {
      Dio dio = new Dio();
      //dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      response = await dio.get(
        "https://restcountries.eu/rest/v2/all",
      );
      print(response.data);
      return response.data
          .map<RestCountriesModel>((json) => RestCountriesModel.fromJson(json))
          .toList();
      ;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> postStory(int userId, File image) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      dio.options.headers["accept-encoding"] = "gzip, deflate, br";
      Response response;
      FormData formData = new FormData.fromMap({
        'userId': "${ids}",
        "story_media[]": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/createStory",
          data: formData);
      print("Update ${response}");
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> postPhotos(int userId, File image) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";

      Response response;
      FormData formData = new FormData.fromMap({
        'userId': "${ids}",
        "media[]": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/addphotos",
          data: formData);
      print("Update ${response}");
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<BlockedListModel> getBlockedList() async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";

      Response response;
      FormData formData = new FormData.fromMap({
        'userId': "${ids}",
      });
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/blockedLists",
          data: formData);
      print("Update ${response}");
      return BlockedListModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> unBlockCall(int oid) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";

      Response response;
      FormData formData = new FormData.fromMap(
          {'userId': "${ids}", 'object_id': '${oid}', 'reason': "UNBLOCK"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/blockUser",
          data: formData);
      print("Update ${response}");
      return response;
    } catch (error) {
      print(error.response.data);
      throw Exception(error);
    }
  }

  static Future<Response> blockCall(int oid, String reason) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";

      Response response;
      FormData formData = new FormData.fromMap(
          {'userId': "${ids}", 'object_id': '${oid}', 'reason': reason});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/blockUser",
          data: formData);
      print("Update ${response}");
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> reportUser(int oid, String reason) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";

      Response response;
      FormData formData = new FormData.fromMap(
          {'userId': "${ids}", 'object_Id': '${oid}', 'reason': "${reason}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/reportUser",
          data: formData);
      print("Update Block and report ${response}");
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<DiscoverListModel> getDiscover(String language) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      print(language);
      Response response;
      FormData formData =
          new FormData.fromMap({'userId': "${ids}", 'language': "${language}"});
      print(formData.fields);
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/discoverUsers",
          data: formData);
      print("Update ${response}");
      return DiscoverListModel.fromJson(response.data);
    } catch (error) {
      print("discover ${error.toString()}");
      throw Exception(error);
    }
  }

  static Future<GetUserProfileModel> getUserProfileOther(int ids) async {
    try {
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({'userId': "${ids}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/currentUser",
          data: formData);
      print(response.data);
      return GetUserProfileModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<UserProfileData> getUserProfileDataOther(int ids) async {
    try {
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({'userId': "${ids}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/getMedia",
          data: formData);
      print(response.data);
      return UserProfileData.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> addToFav(int fid) async {
    try {
      Dio dio = new Dio();
      String ids = await SHelper.getUserId();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData =
          new FormData.fromMap({'userId': "${ids}", 'friendId': "${fid}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/addfavourite",
          data: formData);
      print(response.data);
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<FavListModel> getFav() async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({
        'userId': "${ids}",
      });
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/getfavourite",
          data: formData);
      print(response.data);
      return FavListModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<GiftListModel> getGift(int fid, int gid) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap(
          {'userId': "${ids}", 'friendId': "${fid}", 'giftId': "${gid}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/getGifts",
          data: formData);
      print(response.data);
      return GiftListModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> makePremium() async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({
        'userId': "${ids}",
        'plan_id': "1"

      });
    /*  'start_date': "2021-05-18",
    'end_date': "2022-05-18"*/
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/premiumMembership",
          data: formData);
      print(response.data);
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<ViewUserModel> getViewUser(int fid) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({
        'userId': "${ids}",
        'friendId': "${fid}",
      });
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/viewUser",
          data: formData);
      print(response.data);
      return ViewUserModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> postChatRegister(
      String name, String gender, String ids, int uuid) async {
    try {
      //String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "application/json; charset=utf-8";
      Response response;
      print("My Dataaaaa ${{
        'deviceToken': "${DateTime.now().toString()}",
        'userName': name,
        'sex': gender,
        'userId': "${ids}",
        'uuid': "${uuid}"
      }}");
      response =
          await dio.post("http://13.127.44.197:4600/api/users/create", data: {
        'deviceToken': "${DateTime.now().toString()}",
        'userName': name,
        'sex': gender,
        'userId': "${ids}",'uuid':'${uuid}'
      });
      print("Hola response ${response.data}");
      return response;
    } catch (error) {
      print("${error.response.data} solo");
      throw Exception(error);
    }
  }

  static Future<LeaderBoardModel> getLeaderboard(int fid) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData =
          new FormData.fromMap({'type': "${fid}", 'userId': "${ids}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/leaderboard",
          data: formData);
      print(response.data);
      return LeaderBoardModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<RecentChatModel> getRecentChat() async {
    try {
      String ids = await SHelper.getUsername();
      print("olppp ${ids}");
      Dio dio = new Dio();
      //dio.options.headers["content-type"] = "multipart/form-data";
      Response response;

      response = await dio.get(
          "http://13.127.44.197:4600/api/conversations/recentChats?userName=${ids}&pageNo=1&pageSize=100");
      print(response.data);
      return RecentChatModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<OldChatModel> getOldChat(String roomId) async {
    try {
      String ids = await SHelper.getUsername();
      Dio dio = new Dio();
      //dio.options.headers["content-type"] = "multipart/form-data";
      Response response;

      response = await dio.get(
          "http://13.127.44.197:4600/api/conversations/getOldChat?room_id=${roomId}&pageNo=1&pageSize=100");
      print(response.data);
      return OldChatModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> deductCoins(int coins,String entityId) async {
    try {
      String ids = await SHelper.getUserId();
      print("Deducts coins ${ids}");
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";

      Response response;
      FormData formData = new FormData.fromMap({
        'userId': "${ids}",
        'coins': '${coins}',
        'entityId':"${entityId}"
      });
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/deductCoin",
          data: formData);
      print("Update ${response}");
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> getAccessToken(String channelName) async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      response = await dio.get(
          "http://13.127.44.197:8080/access_token?channelName=${channelName}&uid=${ids}&role=subscriber&expireTime=10");
      print(response.data);
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<RandomUserModel> getRandomUser() async {
    try {
      String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData = new FormData.fromMap({
        'userId': "${ids}",
      });
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/randomUser",
          data: formData);
      print("Random Data ${response.data}");
      return RandomUserModel.fromJson(response.data);
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }

  static Future<Response> createQuickBloxKey(String ids, int uuid) async {
    try {
      //String ids = await SHelper.getUserId();
      Dio dio = new Dio();
      dio.options.headers["content-type"] = "multipart/form-data";
      Response response;
      FormData formData =
          new FormData.fromMap({'userId': "${ids}", 'uuid': "${uuid}"});
      response = await dio.post(
          "http://13.127.44.197/adminTemplate/public/api/updateKey",
          data: formData);
      print("uuid created : ${response.data}");
      return response;
    } catch (error) {
      print(error.toString());
      throw Exception(error);
    }
  }
}
