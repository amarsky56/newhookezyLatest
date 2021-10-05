// To parse this JSON data, do
//
//     final userProfileData = userProfileDataFromJson(jsonString);

import 'dart:convert';

UserProfileData userProfileDataFromJson(String str) => UserProfileData.fromJson(json.decode(str));

String userProfileDataToJson(UserProfileData data) => json.encode(data.toJson());

class UserProfileData {
  UserProfileData({
    this.status,
    this.message,
    this.stories,
    this.photos,
  });

  String status;
  String message;
  List<Story> stories;
  List<Photo> photos;

  factory UserProfileData.fromJson(Map<String, dynamic> json) => UserProfileData(
    status: json["status"],
    message: json["message"],
    stories: List<Story>.from(json["stories"].map((x) => Story.fromJson(x))),
    photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "stories": List<dynamic>.from(stories.map((x) => x.toJson())),
    "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
  };
}

class Photo {
  Photo({
    this.id,
    this.media,
  });

  int id;
  String media;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json["id"],
    media: json["media"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "media": media,
  };
}

class Story {
  Story({
    this.id,
    this.storyMedia,
  });

  int id;
  String storyMedia;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    id: json["id"],
    storyMedia: json["story_media"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "story_media": storyMedia,
  };
}
