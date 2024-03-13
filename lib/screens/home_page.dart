import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weatherapp/bloc/weather_bloc.dart';
import 'package:weatherapp/bloc/weather_event.dart';

import 'package:weatherapp/bloc/weather_state.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/widgets/weather_item.dart';
import 'package:weatherapp/widgets/toppage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WeatherModel> _weathers = [];
  String time = "";

  void _setTime() {
    final currentTime = DateTime.now();
    final hour = currentTime.hour;

    setState(() {
      if (hour >= 5 && hour < 12) {
        time = 'Günaydın';
      } else if (hour >= 12 && hour < 17) {
        time = 'İyi günler';
      } else if (hour >= 17 && hour < 23) {
        time = 'İyi akşamlar';
      } else {
        time = 'İyi geceler';
      }
    });
  }

  @override
  void initState() {
    context.read<WeatherBloc>().add(ResetFetchWeatherEvent());
    _setTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Gündüz (sabah 5 ile akşam 17 arası)
    bool isDaytime = now.hour >= 5 && now.hour < 17;

    // Arka plan resmini belirle
    String backgroundImagePath = isDaytime
        ? "assets/day.jpg" // Gündüz arka planı
        : "assets/nightp.jpeg"; // Gece arka planı
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherInitial) {
            context.read<WeatherBloc>().add(FetchWeather());
            return const Center(
              child: Text("İstek Atılıyor!"),
            );
          } else if (state is WeatherLoading) {
            return const Center(
              child: SpinKitWaveSpinner(
                size: 150,
                color: Colors.green,
              ),
            );
          } else if (state is WeatherLoaded) {
            _weathers = state.weathers;
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: TopPage(
                      weather: state.weathers.first,
                      city: state.city,
                      time: time,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.03),
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          _weathers.length > 1 ? _weathers.length - 1 : 0,
                      itemBuilder: (context, index) {
                        final WeatherModel weather = _weathers[index + 1];
                        return WeatherItem(weather: weather);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is WeatherError) {
            return const Center(
              child: Text("Hatalı istek!"),
            );
          } else {
            return const Center(
              child: Text("Bilinmeyen bir hata oluştu!"),
            );
          }
        },
      ),
    );
  }
}
