import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/chat_provider.dart';
import 'ChatMessageListItemWidget.dart';

class MessageList extends ConsumerWidget {
  final String chatId;
  const MessageList({required this.chatId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final chatProv=ref.watch(chatProvider);
    return NotificationListener<ScrollNotification>(
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        itemCount: chatProv.chats[chatId]!.messages.length,
        itemBuilder:
            (BuildContext context, int index) {
          return ChatMessageListItem(
            message: chatProv.chats[chatId]!.messages[index],
          );
        },
      ),
      onNotification:
          (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels ==
            scrollInfo.metrics.maxScrollExtent) {
          if(!chatProv.loading) {
            chatProv.loadOlderMessages(chatProv.chats[chatId]!);
          }
        }
        return true;
      },
    );
  }
}
