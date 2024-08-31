// presentation/widgets/photo_list_tile.dart
import 'package:flutter/material.dart';
import '../../domain/entities/photo.dart';

class PhotoListTile extends StatelessWidget {
  final Photo photo;

  const PhotoListTile({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: Image.network(
            photo.thumbnailUrl,
            fit: BoxFit.cover,
            // The loadingBuilder shows a CircularProgressIndicator while the image is loading
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child; // The image is fully loaded, display it
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null, // If progress is unknown, display an indeterminate progress indicator
                  ),
                );
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, color: Colors.red); // Show error icon if the image fails to load
            },
          ),
        ),
        title: Text(
          photo.title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('Album ID: ${photo.albumId}'),
      ),
    );
  }
}
