import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/screens/insert_location_screen.dart';
import 'package:weather_app/services/weather_repository.dart';
import 'bloc/weather_bloc.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepositoryProvider(
        create: (context) => WeatherRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => WeatherBloc(
                weatherRepo: context.read<WeatherRepository>(),
              ),
            ),
          ],
          // SettingsBloc(),
          child: InsertLocationScreen(),
        ),
      ),
    );
  }
}
