import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/bloc/weather_bloc.dart';
import 'package:weatherapp/repositories/weather_repository.dart';
import 'package:weatherapp/screens/home_page.dart';

void main() {
  final weatherRepo = WeatherRepository();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<WeatherBloc>(
        create: (context) => WeatherBloc(
          weatherRepository: weatherRepo,
        ),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    ),
  ));
}
