import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0A0A0F)),
    home: const ChatScreen(), debugShowCheckedModeBanner: false));

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  WebSocketChannel? _channel;
  final _serverCtrl = TextEditingController(text: 'wss://multi-client-51uu.onrender.com/');
  final _msgCtrl = TextEditingController(), _msgs = <String>[];
  bool _connected = false;

  void _connect() {
    try {
      _channel?.sink.close();
      _channel = WebSocketChannel.connect(Uri.parse(_serverCtrl.text.trim()));
      _channel!.sink.add('User_${DateTime.now().millisecond % 1000}');
      setState(() => _connected = true);
      _channel!.stream.listen((m) => setState(() => _msgs.add(m.toString())),
        onError: (e) => setState(() { _connected = false; _msgs.add('System: Error ($e)'); }),
        onDone: () => setState(() { _connected = false; _msgs.add('System: Disconnected'); }));
    } catch (e) { setState(() { _connected = false; _msgs.add('System: Failed ($e)'); }); }
  }

  void _send() {
    if (_msgCtrl.text.trim().isEmpty) return;
    if (!_connected) _connect();
    _channel?.sink.add(_msgCtrl.text.trim());
    setState(() { _msgs.add('You: ${_msgCtrl.text.trim()}'); _msgCtrl.clear(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF0D0D1A),
        title: const Text('WebSocket Chat', style: TextStyle(color: Color(0xFF00FFB2))),
        actions: [IconButton(icon: Icon(Icons.dns, color: _connected ? const Color(0xFF00FFB2) : Colors.red),
          onPressed: () => showDialog(context: context, builder: (c) => AlertDialog(title: const Text('Server URL'),
            content: TextField(controller: _serverCtrl),
            actions: [TextButton(onPressed: () { Navigator.pop(c); _connect(); }, child: const Text('Connect'))])))]),
      body: Column(children: [
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: _msgs.length,
          itemBuilder: (c, i) {
            final m = _msgs[i], isMe = m.startsWith('You:'), isSys = m.startsWith('System:');
            return Align(alignment: isSys ? Alignment.center : (isMe ? Alignment.centerRight : Alignment.centerLeft),
              child: Container(margin: const EdgeInsets.symmetric(vertical: 3), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: isSys ? Colors.red.withValues(alpha: 0.2) : (isMe ? const Color(0xFF00FFB2) : const Color(0xFF1E1E3A)), borderRadius: BorderRadius.circular(10)),
                child: Text(m, style: TextStyle(color: isSys ? Colors.redAccent : (isMe ? Colors.black : Colors.white), fontSize: 13))));
          })),
        Container(padding: const EdgeInsets.all(8), color: const Color(0xFF0D0D1A), child: SafeArea(
          child: Row(children: [
            Expanded(child: TextField(controller: _msgCtrl, style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(hintText: _connected ? "Message..." : "Disconnected. Type/Send to connect...", filled: true, fillColor: const Color(0xFF1E1E3A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 12)))),
            IconButton(icon: Icon(Icons.send, color: _connected ? const Color(0xFF00FFB2) : Colors.grey), onPressed: _send),
          ]))),
      ]),
    );
  }
}