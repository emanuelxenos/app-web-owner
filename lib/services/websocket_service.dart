import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/local/local_config.dart';

part 'websocket_service.g.dart';

@Riverpod(keepAlive: true)
WebSocketService webSocketService(WebSocketServiceRef ref) {
  final localConfig = ref.read(localConfigProvider);
  final service = WebSocketService(localConfig);
  ref.onDispose(() => service.disconnect());
  return service;
}

class WebSocketService {
  final LocalConfig _localConfig;
  WebSocketChannel? _channel;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;
  Timer? _reconnectTimer;

  WebSocketService(this._localConfig);

  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  bool get isConnected => _isConnected;

  void connect(String token) {
    try {
      final host = _localConfig.serverHost;
      final port = _localConfig.serverPort;
      final uri = Uri.parse('ws://$host:$port/ws?token=$token');

      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;

      _channel!.stream.listen(
        (data) {
          try {
            final json = jsonDecode(data as String) as Map<String, dynamic>;
            _messageController.add(json);
          } catch (e) {
            if (kDebugMode) print('WS parse error: $e');
          }
        },
        onError: (error) {
          if (kDebugMode) print('WS error: $error');
          _isConnected = false;
          _scheduleReconnect(token);
        },
        onDone: () {
          _isConnected = false;
          _scheduleReconnect(token);
        },
      );
    } catch (e) {
      if (kDebugMode) print('WS connect error: $e');
      _isConnected = false;
    }
  }

  void _scheduleReconnect(String token) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_isConnected) connect(token);
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
