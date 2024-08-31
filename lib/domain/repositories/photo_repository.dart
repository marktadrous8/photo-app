// lib/domain/repositories/photo_repository.dart

import '../../core/result/result.dart';
import '../entities/photo.dart';

abstract class PhotoRepository {
  Future<Result<List<Photo>>> getPhotos({
    int? albumId,
    int page = 1,
    String? sortBy,          // Add this parameter
    String sortOrder = 'asc', // Add this parameter
  });

  Future<Result<void>> cachePhotos(List<Photo> photos);
  Future<Result<List<Photo>>> getCachedPhotos();
}
