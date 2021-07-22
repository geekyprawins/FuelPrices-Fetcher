import 'dart:convert';
import 'package:http/http.dart' as http;

class FuelData {
  Future getFuelData(String fuelUrl) async {
    http.Response response = await http.get(Uri.parse(fuelUrl));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      return decodedData;
    } else
      print(response.statusCode);
  }
}
