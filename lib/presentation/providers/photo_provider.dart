// lib/presentation/providers/photo_provider.dart

import 'package:flutter/material.dart';
import '../../domain/usecases/fetch_photos.dart';
import '../../domain/entities/photo.dart';
import '../../core/result/result.dart';

class PhotoProvider with ChangeNotifier {
  final FetchPhotos fetchPhotos;
  List<Photo> _photos = [];
  bool _loading = false;
  bool _loadingMore = false;
  int _currentPage = 1;
  String? _currentSortBy = 'id'; // Default sort by ID
  String _currentSortOrder = 'asc';
  bool _noData = false;
  int? _currentAlbumId;  // Track the current album ID filter

  PhotoProvider({required this.fetchPhotos});

  List<Photo> get photos => _photos;
  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get noData => _noData;
  String get sortOrder => _currentSortOrder;
  String? get currentSortBy => _currentSortBy;
  int? get currentAlbumId => _currentAlbumId;  // Getter for current album ID

  Future<void> loadPhotos({int? albumId, String? sortBy, String sortOrder = 'asc'}) async {
    _loading = true;
    _currentAlbumId = albumId;  // Update the current album ID
    _currentSortBy = sortBy;
    _currentSortOrder = sortOrder;
    notifyListeners();

    final result = await fetchPhotos(
      albumId: albumId,
      page: _currentPage,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );

    if (result.isSuccess) {
      _photos = result.data!;
      _noData = _photos.isEmpty;
    } else {
      _noData = true;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> filterByAlbumId(int albumId) async {
    _currentPage = 1;
    _photos.clear();
    await loadPhotos(albumId: albumId, sortBy: _currentSortBy, sortOrder: _currentSortOrder);
  }

  Future<void> clearFilter() async {
    _currentPage = 1;
    _photos.clear();
    _currentAlbumId = null;  // Clear the album filter
    await loadPhotos(sortBy: _currentSortBy, sortOrder: _currentSortOrder);
  }

  Future<void> sortPhotos(String criteria, String order) async {
    _currentPage = 1;
    _photos.clear();
    _currentSortBy = criteria;
    _currentSortOrder = order;
    await loadPhotos(albumId: _currentAlbumId, sortBy: criteria, sortOrder: order);
  }

  Future<void> loadMorePhotos() async {
    if (_loadingMore) return;

    _loadingMore = true;
    _currentPage++;
    notifyListeners();

    final result = await fetchPhotos(
      albumId: _currentAlbumId,
      page: _currentPage,
      sortBy: _currentSortBy,
      sortOrder: _currentSortOrder,
    );

    if (result.isSuccess) {
      _photos.addAll(result.data!);
    }

    _loadingMore = false;
    notifyListeners();
  }

  void onScrollUpdate(double scrollPosition, double maxScrollExtent) {
    if (scrollPosition >= maxScrollExtent - 200 && !_loadingMore) {
      loadMorePhotos();
    }
  }
}
