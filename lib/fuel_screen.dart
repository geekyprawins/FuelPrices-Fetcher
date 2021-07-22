import 'package:flutter/material.dart';
import 'constants.dart';
import 'repository.dart';
import 'fuel_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FuelPrice extends StatefulWidget {
  @override
  _FuelPriceState createState() => _FuelPriceState();
}

class _FuelPriceState extends State<FuelPrice> {
  FuelData fuelData = FuelData();
  Repository repo = Repository();
  List<String> _states = ["Choose a state"];
  List<String> _districts = ["Choose a district"];
  String _selectedState = "Choose a state";
  String _selectedDistrict = "Choose a district";
  String fuelPrice = ' 0.0';
  String fuelUrl = 'https://fuelprice-api-india.herokuapp.com/price/';
  String selectedFuel = 'Petrol';
  var buttonColor = inactiveColor;
  @override
  void initState() {
    _states = List.from(_states)..addAll(repo.getStates());
    super.initState();
  }

  DropdownButton androidDropDownButton() {
    List<DropdownMenuItem<String>> myFuels = [];

    for (String fuel in fuels) {
      var newItem = DropdownMenuItem(
        child: Text(
          fuel,
          style: GoogleFonts.asap(
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0,
            // color: Colors.white,
          ),
        ),
        value: fuel,
      );
      myFuels.add(newItem);
    }
    return DropdownButton<String>(
      isExpanded: true,
      isDense: true,
      value: selectedFuel,
      iconEnabledColor: Colors.white,
      items: myFuels,
      onChanged: (value) {
        setState(() {
          selectedFuel = value!;
        });
      },
    );
  }

  void _onSelectedState(String value) {
    setState(() {
      _selectedDistrict = "Choose a district";
      _districts = ["Choose a district"];
      _selectedState = value;
      _districts = List.from(_districts)..addAll(repo.getLocalByState(value));
    });
  }

  void _onSelectedDistrict(String value) {
    setState(() {
      _selectedDistrict = value;
    });
  }

  void updateFuelData() async {
    setState(() {
      buttonColor = activeColor;
    });
    var fuelResponse = await fuelData
        .getFuelData('$fuelUrl$_selectedState/$_selectedDistrict');
    setState(() {
      if (selectedFuel == 'Petrol') {
        fuelPrice = fuelResponse[0]['products'][0]['productPrice'];
      } else {
        fuelPrice = fuelResponse[0]['products'][1]['productPrice'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.deepOrange.shade800,
            child: Hero(
              tag: 'icon',
              child: Image.asset(
                'images/icon-fuel.png',
                fit: BoxFit.cover,
              ),
            )),
        backgroundColor: Colors.deepOrange.shade800,
        title: Center(
            child: Text(
          'Fuel Prices-India',
          style: GoogleFonts.lobster(fontSize: 35),
        )),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/flag-bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.9), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      items: _states.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(
                            dropDownStringItem,
                            style: GoogleFonts.asap(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2.0),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => _onSelectedState(value!),
                      value: _selectedState,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      items: _districts.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(
                            dropDownStringItem,
                            style: GoogleFonts.asap(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2.0),
                          ),
                        );
                      }).toList(),
                      // onChanged: (value) => print(value),
                      onChanged: (value) => _onSelectedDistrict(value!),
                      value: _selectedDistrict,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: androidDropDownButton(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    color: buttonColor,
                  ),
                  child: TextButton.icon(
                      style: ButtonStyle(
                        // backgroundColor: MaterialStateProperty.all<Color>(
                        //     Colors.green.shade900.withOpacity(0.6)),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.95),
                        ),
                      ),
                      onPressed: updateFuelData,
                      icon: Icon(
                        FontAwesomeIcons.rupeeSign,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Click to get the price',
                        style: GoogleFonts.asap(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade900.withOpacity(0.8),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '$selectedFuel price is \u{20B9}$fuelPrice a litre now!',
                    style: GoogleFonts.lobster(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
