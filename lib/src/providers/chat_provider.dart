import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../repository/chat_repository.dart' as chatRepo;
import '../models/chat.dart';
import '../models/message.dart';

final chatProvider = ChangeNotifierProvider<ChatProvider>((ref) {
  return ChatProvider();
});

class ChatProvider with ChangeNotifier {
  Map<String, Chat> chats = {};
  bool loading = false;

  get unread=>chats.values.where((Chat value) =>value.non_read_count>0).length;

  ChatProvider() {
    Future.delayed(Duration.zero, () async {
      addAll(await chatRepo.getUserChats());
    });
    //### non serve perchè aggiunto al main
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    //   //Fluttertoast.showToast(msg: message.notification!.title!);
    //   await receiveMessage(message);
    //   notifyListeners();
    // });
  }

  add(Chat chat) {
    try {
      chats[chat.id] != null;
    } catch (e) {
      chats[chat.id!] = chat;
    }
    notifyListeners();
  }

  addAll(List<Chat> chats) {
    print(chats.length);
    print('##########');
    this.chats.addEntries(chats.map((e) => MapEntry(e.id!, e)));
    notifyListeners();
  }

  del(Chat chat) {
    chats.remove(chat.id);
    notifyListeners();
  }

  clear() {
    chats.clear();
    notifyListeners();
  }

  Future<Chat?> getChatWithUser(id) async {
    print(id);
    for (Chat chat in chats.values) {
      print(chat.other!.id);

      if (chat.other!.id == id) {
        return chat;
      }
    }
    Chat? newChat = await chatRepo.createNewChat(id);
    if (newChat != null) {
      chats[newChat.id!] = newChat;
      notifyListeners();
      return newChat;
    } else {
      return null;
    }
  }

  // Future<Chat?> getChatWithRestaurant(id) async {
  //   print(id);
  //   for (Chat chat in chats.values) {
  //     print(chat.restaurant!.id);
  //
  //     if (chat.restaurant!.id == id) {
  //       return chat;
  //     }
  //   }
  //   Chat? newChat = await chatRepo.createNewChat(id);
  //   if (newChat != null) {
  //     chats[newChat.id!] = newChat;
  //     notifyListeners();
  //     return newChat;
  //   } else {
  //     return null;
  //   }
  // }

  Future<Chat?> getChat(id) async {
    var chat = chats[id];
    if (chat==null || chat.messages.isEmpty || chat.messages.length < 10) {
      chats[id]=await chatRepo.getUserChat(id);
      chat = chats[id];
      chat!.messages= await chatRepo.getChatMessages(id, 0);
    }
    return chat;
  }

  removeUnreadOfChat(String chatId) {
    chats[chatId]!.messages.forEach((element) { element.messageRead=true;});
    notifyListeners();
  }

  int unreadOfChat(String chatId) => chats[chatId]!
      .messages
      .where((element) => !element.from_user && !element.messageRead)
      .length;

  Future<bool> sendMessage(Chat chat, String text) async {
    print(chat.id);
    //print(chat.restaurant!.name);
    Message message = Message();
    message.text = text;
    message.chat_id = chat.id;
    message = await chatRepo.pushMessage(message);
    chat.messages.insert(0, message);
    chat.lastMessage = message;
    notifyListeners();
    return true;
  }

  void loadOlderMessages(Chat chat) async {
    if (chat.messages.length % 20 != 0) {
      //sono in fondo alla lista perchè non è stato completato l'ultimo blocco da 20
    } else {
      loading = true;
      final messages =
          await chatRepo.getChatMessages(chat.id!, chat.messages.length);
      chat.messages.addAll(messages);
      loading = false;
      notifyListeners();
    }
  }

  receiveMessage(RemoteMessage message) async {
    String chatId = message.data['id'];
    String messageId = message.data['message_id'];
    Message? newMessage = await chatRepo.getChatMessage(chatId, messageId);
    if (newMessage != null) {
      chats[chatId]!.messages.insert(0, newMessage);
      chats[chatId]!.lastMessage = newMessage;
      chats[chatId]!.non_read_count+=1;
    }

    notifyListeners();
    return true;
  }

  setAllRead(chatId) {
    chats[chatId]!.non_read_count = 0;
    chatRepo.setMessagesOfChatRead(chatId);
    notifyListeners();
  }

  void sendImageMessage(String chatId,File? file) async{
      Message message = new Message()
        ..data = file!.path

        ..chat_id = chatId;
      message = await chatRepo.pushContentMessage(message);
      chats[chatId]!.messages.insert(0, message);
      chats[chatId]!.lastMessage = message;
      notifyListeners();

  }
}