// ignore_for_file: file_names, unused_import, camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class tripConstants {
  static const String emptyString = "";
  static const String newTripId = "0";
}

class tripEntity implements Comparable {
  final int id;
  final String name;
  final String destination;
  final String description;
  final String date;
  final String risk;
  final String car;
  final String place;

  const tripEntity(
      {required this.id,
      required this.name,
      required this.destination,
      required this.description,
      required this.date,
      required this.risk,
      required this.car,
      required this.place});

  // String get fullName => '$name $date';

  void test() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/db.sqlite';
  }

  tripEntity.fromRow(Map<String, Object?> row)
      : id = row['ID'] as int,
        name = row['NAME'] as String,
        description = row['DESCRIPTION'] as String,
        destination = row['DESTINATION'] as String,
        date = row['DATE'] as String,
        risk = row['RISK'] as String,
        car = row['CAR'] as String,
        place = row['PLACE'] as String;

  @override
  int compareTo(covariant tripEntity other) => other.id.compareTo(id);

  @override
  bool operator == (covariant tripEntity other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'tripEntity, id = $id, name: $name, description: $description, destination: $destination, date: $date, risk: $risk, car: $car, place: $place';
}

class tripEntityDB {
  final String dbName;
  Database? _db;
  List<tripEntity> _trip = [];
  final _streamController = StreamController<List<tripEntity>>.broadcast();

  tripEntityDB({required this.dbName});

  Future<List<tripEntity>> _fetchTrip() async {
    final db = _db;
    if (db == null) {
      return [];
    }
    try {
      final read = await db.query(
        'TRIP',
        distinct: true,
        columns: [
          'ID',
          'NAME',
          'DESCRIPTION',
          'DESTINATION',
          'DATE',
          'RISK',
          'CAR',
          'PLACE'
        ],
        orderBy: 'ID',
      );

      final trip = read.map((row) => tripEntity.fromRow(row)).toList();
      print("Trip: " + trip.toString());
      return trip;
    } catch (e) {
      print('Error fetching trip = $e');
      return [];
    }
  }

  Future<bool> close() async {
    final db = _db;
    if (db == null) {
      return false;
    }
    await db.close();
    return true;
  }

  Future<bool> open() async {
    if (_db != null) {
      return true;
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$dbName';

    try {
      final db = await openDatabase(path);
      _db = db;

      //create table
      const create = '''CREATE TABLE IF NOT EXISTS TRIP (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        NAME STRING NOT NULL,
        DESCRIPTION STRING NOT NULL,
        DESTINATION STRING NOT NULL,
        DATE STRING NOT NULL,
        RISK STRING NOT NULL,
        CAR STRING NOT NULL,
        PLACE STRING NOT NULL
      )''';

      await db.execute(create);
      print('Done create');

      //read all exsisting Trip objects from the db
      _trip = await _fetchTrip();
      print('Done read');
      _streamController.add(_trip);
      print('Done write');
      print(_trip);
      return true;
    } catch (e) {
      print('Error = $e');
      return false;
    }
  }

  Future<bool> create(String name, String description, String destination,
      String date, String risk, String car, String place, String text) async {
    final db = _db;
    if (db == null) {
      return false;
    }

    try {
      final id = await db.insert('TRIP', {
        'NAME': name,
        'DESCRIPTION': description,
        'DESTINATION': destination,
        'DATE': date,
        'RISK': risk,
        'CAR': car,
        'PLACE': place
      });
      final trip = tripEntity(
          id: id,
          name: name,
          description: description,
          destination: destination,
          date: date,
          risk: risk,
          car: car,
          place: place);
      print(trip);
      _trip.add(trip);
      print(_trip);
      _streamController.add(_trip);
      return true;
    } catch (e) {
      print('Error in creating trip = $e');
      return false;
    }
  }

  Future<bool> update(tripEntity trip) async {
    final db = _db;
    if (db == null) {
      return false;
    }
    try {
      final updateCount = await db.update(
        'TRIP',
        {
          'NAME': trip.name,
          'DESCRIPTION': trip.description,
          'DESTINATION': trip.destination,
          'DATE': trip.date,
          'RISK': trip.risk,
          'CAR': trip.car,
          'PLACE': trip.place,
        },
        where: 'ID = ?',
        whereArgs: [trip.id],
      );

      if (updateCount == 1) {
        _trip.removeWhere((other) => other.id == trip.id);
        _trip.add(trip);
        _streamController.add(_trip);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Faild to update with, error = $e');
      return false;
    }
  }

  Future<bool> delete(tripEntity trip) async {
    final db = _db;
    if (db == null) {
      return false;
    }
    try {
      final deleteCount = await db.delete(
        'TRIP',
        where: 'ID = ?',
        whereArgs: [trip.id],
      );

      if (deleteCount == 1) {
        _trip.remove(trip);
        _streamController.add(_trip);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Delete failed with error = $e');
      return false;
    }
  }

  Future<bool> showDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value is bool) {
        return value;
      } else {
        return false;
      }
    });
  }

  Stream<List<tripEntity>> all() =>
      _streamController.stream.map((trip) => trip..sort());
}
