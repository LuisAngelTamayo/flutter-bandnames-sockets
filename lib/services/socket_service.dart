import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => _socket.emit;
  Function get on => _socket.on;
  Function get off => _socket.off;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    createSocketConnection();
  }

  createSocketConnection() {
    String url = 'http://192.168.1.64:3000';
    this._socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true
    });

    //

    this._socket.on("connect", (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on("disconnect", (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //this._socket.on("emitir-mensaje", (payload) {
    //  print('nuevo mensaje:');
    //  print('nombre:         ' + payload['nombre']);
    //  print('Mensaje:         ' + payload['mensaje']);
    //  print(payload.containsKey('Mensaje2')
    //      ? payload['Mensaje2']
    //      : 'no hay'); //para preguntar si existe ese objeto y no quiebre aplicacion
    //});
  }
}
