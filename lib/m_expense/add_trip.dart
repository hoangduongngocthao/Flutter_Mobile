// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:m_expense/m_expense/data/tripEntity.dart';
import 'package:m_expense/m_expense/route_names.dart';
import 'package:intl/intl.dart';

class AddTrip extends StatefulWidget {
  // final OnAddTrip onAddTrip;
  AddTrip({
    Key? key, this.theTrip,
  }) : super(key: key);

  tripEntity? theTrip;

  @override
  State<AddTrip> createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  late final tripEntityDB _crudStorage;

  _AddTripState() {
    _selectedValue = _nameListTrip[0];
    _selectedValue = _carListTrip[0];
    _selectedValue = _placeListTrip[0];
  }

  String _selectedValue = "";
  final _nameListTrip = ["Competition", "Meeting", "Signing", "Negotiation"];
  final _carListTrip = ["FamilyCar", "Moto", "Bicycle", "AirPlane"];
  final _placeListTrip = ["Hotel", "Restaurant", "Resort", "Villa"];

  final TextEditingController tripName = TextEditingController();
  final TextEditingController tripDestination = TextEditingController();
  final TextEditingController tripDescription = TextEditingController();
  final TextEditingController tripDate = TextEditingController();
  final TextEditingController tripRisk = TextEditingController();
  final TextEditingController tripCar = TextEditingController();
  final TextEditingController tripPlace = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool value = false;
  bool theme = false;

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Book'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField(
                    value: _nameListTrip[0],
                    items: _nameListTrip
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedValue = val as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Colors.black,
                    ),
                    dropdownColor: Colors.grey.shade100,
                    decoration: const InputDecoration(
                      labelText: "Trip Name",
                      prefixIcon: Icon(
                        Icons.airplanemode_active,
                        color: Colors.blueAccent,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: tripDestination,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: Colors.blueAccent,
                      ),
                      hintText: "TripDestination",
                      border: OutlineInputBorder(),
                      labelText: "TripDestination",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: tripDescription,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.description_outlined,
                        color: Colors.blueAccent,
                      ),
                      hintText: "TripDescription",
                      border: OutlineInputBorder(),
                      labelText: "TripDescription",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                      controller: tripDate,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.blueAccent,
                        ),
                        labelText: "Select Date",
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));

                        if (pickeddate != null) {
                          setState(() {
                            tripDate.text =
                                DateFormat('dd-MM-yyyy').format(pickeddate);
                          });
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: tripRisk,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.emergency_outlined,
                            color: Colors.blueAccent,
                          ),
                          hintText: "TripRisk",
                        ),
                      ),
                      Switch(
                        value: value,
                        onChanged: (onChanged) {
                          setState(() {
                            value = onChanged;
                          });
                        },
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    value: _carListTrip[0],
                    items: _carListTrip
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedValue = val as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Colors.black,
                    ),
                    dropdownColor: Colors.grey.shade100,
                    decoration: const InputDecoration(
                      labelText: "Trip Name",
                      prefixIcon: Icon(
                        Icons.car_crash_outlined,
                        color: Colors.blueAccent,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField(
                    value: _placeListTrip[0],
                    items: _placeListTrip
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedValue = val as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Colors.black,
                    ),
                    dropdownColor: Colors.grey.shade100,
                    decoration: const InputDecoration(
                      labelText: "Trip Place",
                      prefixIcon: Icon(
                        Icons.house_outlined,
                        color: Colors.blueAccent,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                      onPressed: saveTrip,
                      child: Text('Save',
                          style: TextStyle(
                            fontSize: fontSize,
                          ))),
                ),
                // Text(result,
                //     style: TextStyle(
                //       fontSize: fontSize,
                //     ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveTrip() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        var currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        _crudStorage.create(
          _selectedValue.toString(),
          tripName.text,
          tripDescription.text,
          tripDestination.text,
          tripDate.text,
          tripRisk.text,
          tripCar.text,
          tripPlace.text,
        );

        Navigator.pushNamed(context, RouteNames.ListTrip);
      });
    }
  }

  @override
  void initState() {
    _crudStorage = tripEntityDB(dbName: 'db.sqlite');
    _crudStorage.open();

    final tripRisk = ValueNotifier<bool>(false);
    tripRisk.addListener(() {
      setState(() {
        if (tripRisk.value) {
          theme = true;
        } else {
          theme = false;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    tripName.dispose();
    tripDestination.dispose();
    tripDescription.dispose();
    tripDate.dispose();
    tripRisk.dispose();
    tripCar.dispose();
    tripPlace.dispose();
    _crudStorage.close();
    super.dispose();
  }

  String? requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field can not be empty';
    }
    return null;
  }
}
