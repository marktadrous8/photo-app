// lib/data/data_sources/photo_cache_data_source_impl.dart

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/photo.dart';
import '../models/photo_model.dart';

abstract class PhotoCacheDataSource {
  Future<void> cachePhotos(List<PhotoModel> photos);
  Future<List<PhotoModel>?> getCachedPhotos();
}

class PhotoCacheDataSourceImpl implements PhotoCacheDataSource {
  final SharedPreferences sharedPreferences;

  PhotoCacheDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cachePhotos(List<PhotoModel> photos) async {
    final photosJson = photos.map((photo) => photo.toJson()).toList();
    await sharedPreferences.setString('CACHED_PHOTOS', photosJson.toString());
  }

  @override
  Future<List<PhotoModel>?> getCachedPhotos() async {
    final jsonString = sharedPreferences.getString('CACHED_PHOTOS');
    if (jsonString != null) {
      // Parse the JSON string and return the list of Photos
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => PhotoModel.fromJson(json)).toList();
    } else {
      return null;
    }
  }
}
