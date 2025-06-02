import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
    final supabase = Supabase.instance.client;
    final List<Map<String, dynamic>> _messages = [];
    final TextEditingController _controller = TextEditingController();

    void _loadMessages() async{
      final data = await supabase
                    .from('messages')
                    .select()
                    .order('created_at', ascending: false);
      setState(() {
        _messages.clear();
        _messages.addAll(List<Map<String, dynamic>>.from(data));
      });
    }

    @override
  void initState() {
    super.initState();
    _loadMessages();
    _subscribeToMessages();
  }

    void _subscribeToMessages() {
      supabase
      .channel('public:messages')
          .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            setState(() {
              _messages.insert(0, payload.newRecord);
            });
          }
      ).subscribe();
    }

    void _sendMessage() async{
      final text = _controller.text.trim();
      final user = supabase.auth.currentUser;
      if (text.isNotEmpty && user != null) {
        await supabase.from("messages").insert({
          'user_id': user.id,
          'content': text,
          'email': user.email
        });
        _controller.clear();
      }
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('채팅')),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final userId = supabase.auth.currentUser?.id;
                  final email = supabase.auth.currentUser?.email;
                  final isMine = msg['user_id'] == userId;
                  final senderText = isMine ? "나" : email.toString();




                  return ListTile(
                    title: Text(
                        msg['content'] ?? '',
                        textAlign: isMine ? TextAlign.end : TextAlign.start
                  ),
                    subtitle: Text(
                      senderText,
                      textAlign: isMine? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600]
                      ),

                    ),

                  );
                }
              ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12 ),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: "메세지 입력 ...",
                        border: OutlineInputBorder()
                      ),
                    )
                ),
                const SizedBox(width: 8),
                IconButton(
                    onPressed:  _sendMessage,
                    icon: const Icon(Icons.send)
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

