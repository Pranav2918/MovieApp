import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical/app/domain/repository/app_repository.dart';

import 'app/domain/dio_helper/dio_helper.dart';
import 'app/presentation/home_screen/cubits/genre/genre_cubit.dart';
import 'app/presentation/home_screen/cubits/now_playing/movie_cubit.dart';
import 'app/presentation/home_screen/home_screen.dart';
import 'app/shared/theme/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Sizer().init(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MovieCubit(AppRepository())),
          BlocProvider(create: (_) => GenreCubit(AppRepository())),
        ],
        child: HomeScreen(),
      ),
    );
  }
}
