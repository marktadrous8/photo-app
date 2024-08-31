// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'data/data_sources/photo_remote_data_source_impl.dart';
import 'data/repositories/photo_repository_impl.dart';
import 'domain/usecases/fetch_photos.dart';
import 'presentation/pages/photo_list_page.dart';
import 'presentation/providers/photo_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = http.Client();

  final photoRemoteDataSource = PhotoRemoteDataSourceImpl(client: httpClient);

  final photoRepository = PhotoRepositoryImpl(
    remoteDataSource: photoRemoteDataSource,
  );

  final fetchPhotosUseCase = FetchPhotos(photoRepository);

  runApp(MyApp(fetchPhotosUseCase: fetchPhotosUseCase));
}

class MyApp extends StatelessWidget {
  final FetchPhotos fetchPhotosUseCase;

  const MyApp({Key? key, required this.fetchPhotosUseCase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PhotoProvider(fetchPhotos: fetchPhotosUseCase),
        ),
      ],
      child: MaterialApp(
        title: 'Photo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PhotoListPage(),
      ),
    );
  }
}
