import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketCryptoRepository {
  final String apiUrl =
      "wss://ws.eodhistoricaldata.com/ws/crypto?api_token=demo";

  WebSocketChannel? _channel;
  Map<String, dynamic>? _latestPrices;
  StreamController<Map<String, dynamic>>? _priceStreamController;
  DateTime? _lastReceivedTime;

  Future<void> connect() async {
    _channel = WebSocketChannel.connect(Uri.parse(apiUrl));
    _priceStreamController = StreamController<Map<String, dynamic>>.broadcast();

    _channel?.sink.add(jsonEncode({
      "action": "subscribe",
      "symbols": "ETH-USD,BTC-USD",
    }));

    _listenForUpdates();
  }

  void _listenForUpdates() {
    if (_channel == null) {
      throw Exception("WebSocket is not connected. Call connect() first.");
    }

    _channel!.stream.listen((message) {
      final data = jsonDecode(message);
      _latestPrices = data;
      _lastReceivedTime = DateTime.now();
      if (kDebugMode) {
        print(data);
      }
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_latestPrices != null && _lastReceivedTime != null) {
        if (DateTime.now().difference(_lastReceivedTime!).inSeconds < 1) {
          _priceStreamController?.add(_latestPrices!);
        }
      }
    });
  }

  Stream<Map<String, dynamic>> getCryptoPrices() {
    if (_priceStreamController == null) {
      throw Exception("WebSocket is not connected. Call connect() first.");
    }
    if (kDebugMode) {
      print(_priceStreamController);
    }
    return _priceStreamController!.stream;
  }

  void disconnect() {
    _channel?.sink.close();
    _priceStreamController?.close();
  }
}
