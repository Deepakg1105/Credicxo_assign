import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:credicxo_assignment_task/apibloc.dart';

class TrackLyrics extends StatefulWidget {
  final commontrack_id;
  final track_id;

  TrackLyrics({this.commontrack_id, this.track_id});

  @override
  _TrackLyricsState createState() => _TrackLyricsState();
}

class _TrackLyricsState extends State<TrackLyrics> {
  var trackbloc;
  var lyrics;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      trackbloc = ApiBloc(id: "${widget.commontrack_id}");
      lyrics = ApiBloc(id: "${widget.track_id}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lyrics"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        initialData: ConnectivityResult.wifi,
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> con) {
          trackbloc.eventsink.add(ApiAction.TrackInfo);
          lyrics.eventsink.add(ApiAction.Lyrics);

          if (!con.hasData) {
            return Text("No data");
          }
          if ("${con.data}" == "ConnectivityResult.none") {
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
          return StreamBuilder(
            stream: trackbloc.apistream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              lyrics.eventsink.add(ApiAction.Lyrics);
              var myList = snapshot.data!
                  as Map<dynamic, dynamic>; // <-- Your data using 'as'

              return ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          "${myList['message']['body']['track']['track_name']}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Artist",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          "${myList['message']['body']['track']['artist_name']}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Album Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          "${myList['message']['body']['track']['album_name']}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Explicit",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          myList['message']['body']['track']['explicit'] == 0
                              ? "False"
                              : "True",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rating",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          "${myList['message']['body']['track']['track_rating']}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: lyrics.apistream,
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var list = snapshot.data! as Map<dynamic,
                            dynamic>; // <-- Your data using 'as'
                        print('hello: ' + list.toString());
                        return Container(
                          padding: EdgeInsets.all(6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lyrics:-",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              Text(
                                list['message']['body']['lyrics'] ??
                                    "api error",
                                style: TextStyle(fontSize: 20.0),
                              )
                            ],
                          ),
                        );
                      }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    trackbloc.dispose();
    lyrics.dispose();
  }
}
