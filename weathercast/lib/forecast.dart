import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'location.dart';
import 'weather.dart';

Future<Weather> forecast() async {
  const url = 'https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at';
const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImM0MGQ0NGE4N2ZmNDVmYTUzODJiOWUwOGU2ZWJmYTdiZTc5ZDcxNWE0NmZmNWU4YzNkZTk5YmZlNGFjMjEwZTA3MjViZjczMGI4MjY5MzA1In0.eyJhdWQiOiIyIiwianRpIjoiYzQwZDQ0YTg3ZmY0NWZhNTM4MmI5ZTA4ZTZlYmZhN2JlNzlkNzE1YTQ2ZmY1ZThjM2RlOTliZmU0YWMyMTBlMDcyNWJmNzMwYjgyNjkzMDUiLCJpYXQiOjE2Njg5MzM2MjcsIm5iZiI6MTY2ODkzMzYyNywiZXhwIjoxNzAwNDY5NjI3LCJzdWIiOiIyMjgzIiwic2NvcGVzIjpbXX0.bE96T5UBqb6sH1HoGPvSa4kYPPmu32sER3KGnkg0M3RceRK4zYreouoL0ruPiUVdTuby4J1WymdtLP_5FCNTveKL5c9kpZ8HlIZRIGahzKDpCDvoQosbhGR6VLZmB0RhFno8GAl5vCv8D8PcRJfUbhjLK1sYrKCDHjtz66odZQ8F-saXO1FdWPPaDiWxTp9G85kzU3RiKqxPYPkSMjtRf43H-p11M3m5pydS5hxc7tUSsCyVkkzELLBmZ3yzwTI5o_81uldo42G4ARwZ06EjajmbIk1TV_53x4uZ0c4B8HugP2KI0ZAuObZT4xdU7ZgScNG5kjUaU8Dgn9VaZDcqTXSTULg2M4uFu4BBvxbmEWgtA4-VIjEY4vglZZN9iFziIeU79942-LMweTpIQLiliXOsksDqj6z7sTUFSL8JfOzczclYa0fgNk3-1ZvPVu3XTYRg3JIon27LsyZnCW7sNwcKRRBopZFaBpXnWpumQ4fDYsfU-DbMk_nybNQTIckPDiCsXisXS8UfM6Zg5MY43mnDap7Kccb4aDKJTvLtQyvHrySqpgKYkiJn9AAroXHGDHoTiZFoMWz11ksWzolMpQzpCZSyL4FfFf2Agd_XRXFftigFNRz767RkJYzklaV44wGcIhWPh0mxC7uxMlW7Wn0yIeWff3sZ0Dsc5AOzfJ4';

try {
  Position location = await getCurrentLocation();
  http.Response response = await http.get(
  Uri.parse('$url?lat=${location.latitude}&lon=${location.longitude}&fields=tc,cond'), 
  headers: {
    'accept': 'application/json',
    'authorization': 'Bearer $token',
  }
);
  if(response.statusCode == 200) {
    var result = jsonDecode(response.body)['WeatherForecasts'][0]['forecasts'][0]['data'];
    Placemark address = (await placemarkFromCoordinates(location.latitude, location.longitude)).first;
    return Weather(
    address: '${address.subLocality}\n${address.administrativeArea}',
    temperature: result['tc'],
    cond: result['cond'],
  );
} else {
return Future.error(response.statusCode);
}
} catch (e) {
return Future.error(e);
}

}