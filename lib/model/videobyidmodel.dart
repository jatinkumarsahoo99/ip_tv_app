// To parse this JSON data, do
// final videoByIdModel = videoByIdModelFromJson(jsonString);

import 'dart:convert';

VideoByIdModel videoByIdModelFromJson(String str) =>
    VideoByIdModel.fromJson(json.decode(str));

String videoByIdModelToJson(VideoByIdModel data) => json.encode(data.toJson());

class VideoByIdModel {
  VideoByIdModel({
    this.code,
    this.status,
    this.message,
    this.result,
  });

  int? code;
  int? status;
  String? message;
  List<Result>? result;

  factory VideoByIdModel.fromJson(Map<String, dynamic> json) => VideoByIdModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(
            json["result"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  int? id;
  String? categoryId;
  String? languageId;
  String? castId;
  int? channelId;
  String? directorId;
  String? starringId;
  String? supportingCastId;
  String? networks;
  String? maturityRating;
  String? name;
  String? thumbnail;
  String? landscape;
  String? videoUploadType;
  String? trailerType;
  String? trailerUrl;
  String? releaseYear;
  String? ageRestriction;
  String? maxVideoQuality;
  String? releaseTag;
  int? typeId;
  int? videoType;
  String? videoExtension;
  int? isPremium;
  String? description;
  int? videoDuration;
  int? videoSize;
  int? view;
  dynamic imdbRating;
  int? download;
  int? status;
  String? isTitle;
  String? releaseDate;
  String? video320;
  String? video480;
  String? video720;
  String? video1080;
  String? subtitleType;
  String? subtitle;
  String? subtitleLang1;
  String? subtitleLang2;
  String? subtitleLang3;
  String? subtitle1;
  String? subtitle2;
  String? subtitle3;
  String? createdAt;
  String? updatedAt;
  int? stopTime;
  int? isDownloaded;
  int? isBookmark;
  int? rentBuy;
  int? isRent;
  int? rentPrice;
  int? isBuy;
  String? categoryName;
  String? sessionId;
  int? upcomingType;
  String? studios;
  String? contentAdvisory;
  String? viewingRights;

  Result({
    this.id,
    this.channelId,
    this.categoryId,
    this.languageId,
    this.castId,
    this.typeId,
    this.videoType,
    this.name,
    this.thumbnail,
    this.landscape,
    this.description,
    this.isPremium,
    this.isTitle,
    this.download,
    this.videoUploadType,
    this.video320,
    this.video480,
    this.video720,
    this.video1080,
    this.videoExtension,
    this.videoDuration,
    this.trailerType,
    this.trailerUrl,
    this.subtitleType,
    this.subtitleLang1,
    this.subtitle1,
    this.subtitleLang2,
    this.subtitle2,
    this.subtitleLang3,
    this.subtitle3,
    this.releaseDate,
    this.releaseYear,
    this.imdbRating,
    this.view,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.directorId,
    this.starringId,
    this.supportingCastId,
    this.networks,
    this.maturityRating,
    this.ageRestriction,
    this.maxVideoQuality,
    this.releaseTag,
    this.videoSize,
    this.stopTime,
    this.isDownloaded,
    this.isBookmark,
    this.rentBuy,
    this.isRent,
    this.rentPrice,
    this.isBuy,
    this.categoryName,
    this.sessionId,
    this.upcomingType,
    this.studios,
    this.contentAdvisory,
    this.viewingRights,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        channelId: json["channel_id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        castId: json["cast_id"],
        typeId: json["type_id"],
        videoType: json["video_type"],
        name: json["name"],
        thumbnail: json["thumbnail"],
        landscape: json["landscape"],
        description: json["description"],
        isPremium: json["is_premium"],
        isTitle: json["is_title"],
        download: json["download"],
        videoUploadType: json["video_upload_type"],
        video320: json["video_320"],
        video480: json["video_480"],
        video720: json["video_720"],
        video1080: json["video_1080"],
        videoExtension: json["video_extension"],
        videoDuration: json["video_duration"],
        trailerType: json["trailer_type"],
        trailerUrl: json["trailer_url"],
        subtitleType: json["subtitle_type"],
        subtitleLang1: json["subtitle_lang_1"],
        subtitle1: json["subtitle_1"],
        subtitleLang2: json["subtitle_lang_2"],
        subtitle2: json["subtitle_2"],
        subtitleLang3: json["subtitle_lang_3"],
        subtitle3: json["subtitle_3"],
        releaseDate: json["release_date"],
        releaseYear: json["release_year"],
        imdbRating: json["imdb_rating"],
        view: json["view"],
        status: int.tryParse(json["status"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        directorId: json["director_id"],
        starringId: json["starring_id"],
        supportingCastId: json["supporting_cast_id"],
        networks: json["networks"],
        maturityRating: json["maturity_rating"],
        ageRestriction: json["age_restriction"],
        maxVideoQuality: json["max_video_quality"],
        releaseTag: json["release_tag"],
        videoSize: json["video_size"],
        stopTime: json["stop_time"],
        isDownloaded: json["is_downloaded"],
        isBookmark: json["is_bookmark"],
        rentBuy: json["rent_buy"],
        isRent: json["is_rent"],
        rentPrice: json["rent_price"],
        isBuy: json["is_buy"],
        categoryName: json["category_name"],
        sessionId: json["session_id"],
        upcomingType: json["upcoming_type"],
        studios: json["studios"],
        contentAdvisory: json["content_advisory"],
        viewingRights: json["viewing_rights"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channel_id": channelId,
        "category_id": categoryId,
        "language_id": languageId,
        "cast_id": castId,
        "type_id": typeId,
        "video_type": videoType,
        "name": name,
        "thumbnail": thumbnail,
        "landscape": landscape,
        "description": description,
        "is_premium": isPremium,
        "is_title": isTitle,
        "download": download,
        "video_upload_type": videoUploadType,
        "video_320": video320,
        "video_480": video480,
        "video_720": video720,
        "video_1080": video1080,
        "video_extension": videoExtension,
        "video_duration": videoDuration,
        "trailer_type": trailerType,
        "trailer_url": trailerUrl,
        "subtitle_type": subtitleType,
        "subtitle_lang_1": subtitleLang1,
        "subtitle_1": subtitle1,
        "subtitle_lang_2": subtitleLang2,
        "subtitle_2": subtitle2,
        "subtitle_lang_3": subtitleLang3,
        "subtitle_3": subtitle3,
        "release_date": releaseDate,
        "release_year": releaseYear,
        "imdb_rating": imdbRating,
        "view": view,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "director_id": directorId,
        "starring_id": starringId,
        "supporting_cast_id": supportingCastId,
        "networks": networks,
        "maturity_rating": maturityRating,
        "age_restriction": ageRestriction,
        "max_video_quality": maxVideoQuality,
        "release_tag": releaseTag,
        "video_size": videoSize,
        "stop_time": stopTime,
        "is_downloaded": isDownloaded,
        "is_bookmark": isBookmark,
        "rent_buy": rentBuy,
        "is_rent": isRent,
        "rent_price": rentPrice,
        "is_buy": isBuy,
        "category_name": categoryName,
        "session_id": sessionId,
        "upcoming_type": upcomingType,
        "studios": studios,
        "content_advisory": contentAdvisory,
        "viewing_rights": viewingRights,
      };
}
