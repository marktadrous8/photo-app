// lib/data/repositories/photo_repository_impl.dart

import '../data_sources/photo_remote_data_source.dart';
import '../../domain/entities/photo.dart';
import '../../core/result/result.dart';
import '../../domain/repositories/photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoRemoteDataSource remoteDataSource;

  PhotoRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Result<List<Photo>>> getPhotos({
    int? albumId,
    int page = 1,
    String? sortBy,
    String sortOrder = 'asc',
  }) async {
    return remoteDataSource.fetchPhotos(
      albumId: albumId,
      page: page,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<Result<void>> cachePhotos(List<Photo> photos) async {
    // No-op implementation
    return Result.success(null);
  }

  @override
  Future<Result<List<Photo>>> getCachedPhotos() async {
    // No-op implementation
    return Result.failure('No cached data available.');
  }
}
