import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_chat/chat.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
    );
  }
}

// Abstract base event for chat
abstract class ChatEvent {}

// Specific event for sending a message
class SendMessage extends ChatEvent {
  SendMessage(this.message);
  final ChatMessage message;
}

// Chat state representing messages
class ChatState {
  ChatState({required this.messages});
  final List<ChatMessage> messages;
}

// Chat BLoC to manage state
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState(messages: [])) {
    on<SendMessage>((event, emit) {
      final updatedMessages = List<ChatMessage>.from(state.messages)
        ..add(event.message);
      emit(ChatState(messages: updatedMessages));
    });
  }
}

// Main chat screen
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat App'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  buildWhen: (previous, current) =>
                      previous.messages != current.messages,
                  builder: (context, state) {
                    return SfChat(
                      messages: state.messages,
                      outgoingUser: '123-001',
                      actionButton: ChatActionButton(
                        onPressed: (String newMessage) {
                          context.read<ChatBloc>().add(
                                SendMessage(
                                  ChatMessage(
                                    text: newMessage,
                                    time: DateTime.now(),
                                    author: const ChatAuthor(
                                      id: '123-001',
                                      name: 'John Doe',
                                    ),
                                  ),
                                ),
                              );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

