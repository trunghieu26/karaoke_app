import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// DATA
import 'data/datasources/lyrics_remote_datasource.dart';
import 'data/repositories/lyrics_repository_impl.dart';

// DOMAIN
import 'domain/usecases/get_lyrics.dart';

// SERVICE
import 'services/audio_service.dart';

// BLOC
import 'presentation/bloc/player_bloc.dart';
import 'presentation/bloc/player_event.dart';

// UI
import 'presentation/pages/player_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = LyricsRepositoryImpl(LyricsRemoteDataSource());

    return BlocProvider(
      create: (_) =>
          PlayerBloc(AudioService(), GetLyrics(repo))..add(InitPlayer()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PlayerPage(),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
