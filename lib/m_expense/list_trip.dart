// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:m_expense/m_expense/add_trip.dart';
import 'package:m_expense/m_expense/route_names.dart';

import 'data/tripEntity.dart';

class ListTrip extends StatefulWidget {
  const ListTrip({Key? key}) : super(key: key);

  @override
  State<ListTrip> createState() => _ListTripState();
}

class _ListTripState extends State<ListTrip> {
  late final tripEntityDB _crudStorage;
  late final tripEntityDB _tripDelete;

  @override
  void initState() {
    _crudStorage = tripEntityDB(dbName: 'db.sqlite');
    _crudStorage.open();
    _tripDelete = tripEntityDB(dbName: 'db.sqlite');
    _tripDelete.open();
    super.initState();
  }

  @override
  void dispose() {
    _crudStorage.close();
    _tripDelete.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List trip'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.AddTrip);
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
            stream: _crudStorage.all(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                  if (snapshot.data == null) {
                    print(snapshot);
                    print("We are here: 1");
                    return const Center(child: CircularProgressIndicator());
                  }
                  print("We are here: 2");
                  final trips = snapshot.data as List<tripEntity>;
                  print(trips);
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: trips.length,
                          itemBuilder: (context, index) {
                            final t = trips[index];
                            print(t);
                            return ListTile(
                              onTap: () {
                                print(t.id);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddTrip(theTrip: t),
                                    ));
                              },
                              leading: CircleAvatar(child: Text('${t.id}')),
                              title: Text('${t.place}',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 25.0,
                                  )),
                              trailing: TextButton(
                                onPressed: () async {
                                  // _tripDelete.showDeleteDialog(context);
                                  // if(_tripDelete) {
                                  //   _crudStorage.delete(trip)
                                  // }
                                },
                                child: const Icon(
                                  Icons.disabled_by_default_rounded,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            }));
    // home: Welcome(),
  }

  // void deleleTrip() {

  // }
}
