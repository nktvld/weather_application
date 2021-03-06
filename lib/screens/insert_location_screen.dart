import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:weather_app/utils/constants.dart';

class InsertLocationScreen extends StatefulWidget {
  @override
  _InsertLocationScreenState createState() => _InsertLocationScreenState();
}

class _InsertLocationScreenState extends State<InsertLocationScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: BlocListener<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state.isSuccess) {
            print('success');
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(providers: [
                        BlocProvider.value(
                          value: context.read<WeatherBloc>(),
                        ),
                      ], child: WeatherScreen())));
            });
          } else if (state.isFailure) {
            print('fail');
            _showSnackBar(context);
          } else if (state.isLoading) {
            print('loading');
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cityField(),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    _flareWidget(),
                    _insertYourLocationText(context),
                  ],
                ),
                Container()
              ],
            ),
          ),
        ),
      ),
      //   ),
      // ),
    );
  }

  Widget _cityField() {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              style: TextStyle(color: Colors.white, fontSize: 15),
              cursorColor: Colors.white,
              cursorHeight: 25,
              decoration: kTextFormFieldDecoration.copyWith(),
              controller: _cityController,
            ),
            IconButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  context
                      .read<WeatherBloc>()
                      .add(FetchWeatherByCity(city: _cityController.text));
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ))
          ],
        ),
      );
    });
  }

  Widget _insertYourLocationText(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) => state.isLoading
          ? CircularProgressIndicator(
        color: Colors.blueGrey.shade900,
      )
          : Text(
        'Insert your location.',
        style: TextStyle(
            fontSize: 25,
            color: Colors.blueGrey.shade900,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _flareWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: FlareActor(
            "assets/animations/WorldSpin.flr",
            fit: BoxFit.contain,
            animation: "roll",
          ),
          height: 300,
          width: 300),
    );
  }


  void _showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.blueGrey.shade900,
      content: Text('Something went wrong'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
