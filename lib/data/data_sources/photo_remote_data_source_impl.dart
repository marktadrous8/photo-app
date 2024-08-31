// lib/data/data_sources/photo_remote_data_source_impl.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/result/result.dart';
import '../../domain/entities/photo.dart';
import '../models/photo_model.dart';
import 'photo_remote_data_source.dart'; // Ensure this import is correct

class PhotoRemoteDataSourceImpl implements PhotoRemoteDataSource { // Fix the typo here
  final http.Client client;

  PhotoRemoteDataSourceImpl({required this.client});

  @override
  Future<Result<List<PhotoModel>>> fetchPhotos({
    int? albumId,
    int page = 1,
    String? sortBy,
    String sortOrder = 'asc',
  }) async {
    String url = 'https://jsonplaceholder.typicode.com/photos?_page=$page&_limit=10';

    if (albumId != null) {
      url += '&albumId=$albumId';
    }

    if (sortBy != null) {
      url += '&_sort=$sortBy&_order=$sortOrder';
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
