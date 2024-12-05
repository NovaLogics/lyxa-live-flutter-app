// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUserModel _$AppUserModelFromJson(Map<String, dynamic> json) => AppUserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      searchableName: json['searchableName'] as String,
    );

Map<String, dynamic> _$AppUserModelToJson(AppUserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'searchableName': instance.searchableName,
    };
