import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:connectivity_plus/connectivity_plus.dart';

enum ApiAction { Tracklist, TrackInfo, Lyrics }

class ApiBloc {
  var bo;
  final _stateStream = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get apisink => _stateStream.sink;
  Stream<dynamic> get apistream => _stateStream.stream;

  final _eventStream = StreamController<ApiAction>();
  StreamSink<ApiAction> get eventsink => _eventStream.sink;
  Stream<ApiAction> get eventStream => _eventStream.stream;
  Client client = Client();
  ApiBloc({id}) {
    eventStream.listen((event) async {
      if (event == ApiAction.Tracklist) {
        var response = await client.get(Uri.parse(
            "https://api.musixmatch.com/ws/1.1/chart.tracks.get?f_has_lyrics=0&apikey=a470dd5b8b4d02ccd64310c2eec6b94e"));
        var resdec = jsonDecode(response.body);
        bo = resdec;
      } else if (event == ApiAction.TrackInfo) {
        var response = await client.get(Uri.parse(
            // "https://api.musixmatch.com/ws/1.1/track.get?track_id=$id&apikey=a470dd5b8b4d02ccd64310c2eec6b94e"));
            "https://api.musixmatch.com/ws/1.1/track.get?commontrack_id=$id&apikey=a470dd5b8b4d02ccd64310c2eec6b94e"));
        var resdec = jsonDecode(response.body);
        bo = resdec;
        apisink.add(bo);
      } else if (event == ApiAction.Lyrics) {
        var response = await client.get(Uri.parse(
            "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$id&apikey=a470dd5b8b4d02ccd64310c2eec6b94e"));
        var resdec = jsonDecode(response.body);
        bo = resdec;
        apisink.add(bo);
      }
      apisink.add(bo);
    });
  }

  void dispose() {
    _stateStream.close();
    _eventStream.close();
  }
}

class TrackBloc {
  var bo;
  final _stateStream = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get apisink => _stateStream.sink;
  Stream<dynamic> get apistream => _stateStream.stream;

  final _eventStream = StreamController<ApiAction>();
  StreamSink<ApiAction> get eventsink => _eventStream.sink;
  Stream<ApiAction> get eventStream => _eventStream.stream;
  Client client = Client();

  TrackBloc({id}) {
    eventStream.listen((event) async {
      if (event == ApiAction.TrackInfo) {
        var response = await client.get(Uri.parse(
            "https://api.musixmatch.com/ws/1.1/track.get?track_id=$id&apikey=eff0f105c06f3a5381a627d6a6eb95ec"));
        var resdec = jsonDecode(response.body);
        bo = resdec;
      }
    });
  }

  void dispose() {
    _stateStream.close();
    _eventStream.close();
  }
}
