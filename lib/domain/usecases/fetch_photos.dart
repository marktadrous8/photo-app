// lib/domain/usecases/fetch_photos.dart

import '../../core/result/result.dart';
import '../entities/photo.dart';
import '../repositories/photo_repository.dart';

class FetchPhotos {
  final PhotoRepository repository;

  FetchPhotos(this.repository);

  Future<Result<List<Photo>>> call({
    int? albumId,
    int page = 1,
    String? sortBy,          // Add this parameter
    String sortOrder = 'asc', // Add this parameter
  }) {
    return repository.getPhotos(
      albumId: albumId,
      page: page,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
