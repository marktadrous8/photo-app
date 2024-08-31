// lib/presentation/pages/photo_list_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import '../widgets/photo_list_tile.dart';

class PhotoListPage extends StatefulWidget {
  @override
  _PhotoListPageState createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  final TextEditingController _filterController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PhotoProvider>(context, listen: false).loadPhotos(sortBy: 'id');
    });

    _scrollController.addListener(() {
      final provider = Provider.of<PhotoProvider>(context, listen: false);

      provider.onScrollUpdate(
        _scrollController.position.pixels,
        _scrollController.position.maxScrollExtent,
      );
    });
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sort By'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Album ID'),
                leading: Radio<String>(
                  value: 'albumId',
                  groupValue: Provider.of<PhotoProvider>(context).currentSortBy,
                  onChanged: (String? value) {
                    _sortPhotos(value!, 'asc');
                    Navigator.of(context).pop();
                  },
                ),
                tileColor: Provider.of<PhotoProvider>(context).currentSortBy == 'albumId'
                    ? Colors.blue.withOpacity(0.2)
                    : null,
              ),
              ListTile(
                title: Text('Title'),
                leading: Radio<String>(
                  value: 'title',
                  groupValue: Provider.of<PhotoProvider>(context).currentSortBy,
                  onChanged: (String? value) {
                    _sortPhotos(value!, 'asc');
                    Navigator.of(context).pop();
                  },
                ),
                tileColor: Provider.of<PhotoProvider>(context).currentSortBy == 'title'
                    ? Colors.blue.withOpacity(0.2)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter By Album ID'),
          content: TextField(
            controller: _filterController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Album ID',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int? albumId = int.tryParse(_filterController.text);
                if (albumId != null) {
                  Provider.of<PhotoProvider>(context, listen: false).filterByAlbumId(albumId);
                }
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                });
              },
              child: Text('Apply'),
            ),
            TextButton(
              onPressed: () {
                _filterController.clear();
                Provider.of<PhotoProvider>(context, listen: false).clearFilter();
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                });
              },
              child: Text('Clear Filter'),
            ),
          ],
        );
      },
    );
  }

  void _sortPhotos(String criteria, String order) {
    Provider.of<PhotoProvider>(context, listen: false).sortPhotos(criteria, order);
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon:                 Icon(Icons.import_export, size: 24),

            onPressed: () {
              _showSortDialog(context); // Open sort dialog
            },
          ),
        ],
      ),
      body: Consumer<PhotoProvider>(
        builder: (context, provider, child) {
          if (provider.loading && provider.photos.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.noData) {
            return Center(child: Text('No data available'));
          }

          final photos = provider.photos;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (provider.currentSortBy != null) ...[
                      OutlinedButton(
                        onPressed: () {},
                        child: Text('Sorted by ${provider.currentSortBy == 'albumId' ? 'album ID' : provider.currentSortBy}'),

                      ),
                      SizedBox(width: 8),
                    ],
                    if (provider.currentAlbumId != null) ...[
                      OutlinedButton(
                        onPressed: () {
                          provider.clearFilter();
                        },
                        child: Row(
                          children: [
                            Text('Filtered by ID ${provider.currentAlbumId}'),
                            SizedBox(width: 4),
                            Icon(Icons.clear, size: 16),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      itemCount: photos.length + (provider.loadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < photos.length) {
                          final photo = photos[index];
                          return PhotoListTile(photo: photo);
                        } else if (provider.loadingMore) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return SizedBox.shrink(); // No more items to load
                        }
                      },
                    ),
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          _scrollController.animateTo(
                            0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        label: Text('Top'),
                        icon: Icon(Icons.arrow_upward),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
