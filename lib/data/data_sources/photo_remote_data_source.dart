// lib/data/data_sources/photo_remote_data_source.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/result/result.dart';
import '../../domain/entities/photo.dart';
import '../models/photo_model.dart';

class PhotoRemoteDataSource {
  final http.Client client;

  PhotoRemoteDataSource({required this.client});

  Future<Result<List<Photo>>> fetchPhotos({
    int? albumId,
    int page = 1,
    String? sortBy,   // New parameter for sorting
    String sortOrder = 'asc', // New parameter for sort order
  }) async {
    String url = 'https://jsonplaceholder.typicode.com/photos?_page=$page&_limit=10';

    if (albumId != null) {
      url += '&albumId=$albumId';
    }

    if (sortBy != null) {
      url += '&_sort=$sortBy&_order=$sortOrder';  // Append sorting query
    }

    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        final photos = data.map((json) => PhotoModel.fromJson(json)).toList();
        return Result.success(photos);
      } else {
        return Result.failure('Failed to load photos');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
