import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:credicxo_assignment_task/apibloc.dart';
import 'package:credicxo_assignment_task/screens/tracklyrics.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var apibloc = ApiBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credicxco MusixMatch"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snap) {
          apibloc.eventsink.add(ApiAction.Tracklist);

          if (!snap.hasData) {
            return Text("No data");
          }
          if ("${snap.data}" == "ConnectivityResult.none") {
            return Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(
                        Icons.wifi_off_outlined,
                        color: Colors.black,
                        size: 50.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        'You\'re offline!',
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: Text(
                        'Check your connection and try again when you\'re back online',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ));
          }
          apibloc.eventsink.add(ApiAction.Tracklist);
          return StreamBuilder(
            stream: apibloc.apistream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == "ConnectivityResult.none") {
                return Text("No Internet Connection");
              } else {
                var myList = snapshot.data! as Map<dynamic, dynamic>;
                return Container(
                  child: ListView.builder(
                      itemCount: myList['message']['body']['track_list'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            shape: Border(
                                bottom:
                                    BorderSide(color: Colors.black, width: 2.5),
                                right: BorderSide(
                                    color: Colors.black, width: 2.5)),
                            elevation: 10.0,
                            child: ListTile(
                              onTap: () {
                                print(
                                    "hello2: ${myList['message']['body']['track_list'][index]['track']}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TrackLyrics(
                                              commontrack_id:
                                                  "${myList['message']['body']['track_list'][index]['track']['commontrack_id']}",
                                              track_id:
                                                  "${myList['message']['body']['track_list'][index]['track']['commontrack_id']}",
                                            )));
                              },
                              minVerticalPadding: 15.0,
                              leading: Icon(
                                Icons.library_music,
                                size: 30.0,
                              ),
                              minLeadingWidth: 20,
                              trailing: Text(
                                  "${myList['message']['body']['track_list'][index]['track']['artist_name']}"),
                              title: Text(
                                  "${myList['message']['body']['track_list'][index]['track']['track_name']}"),
                              subtitle: Text(
                                  "${myList['message']['body']['track_list'][index]['track']['album_name']}"),
                              horizontalTitleGap: 5.0,
                            ),
                          ),
                        );
                      }),
                );
              }
            },
          );
        },
      ),
    );
  }
}
