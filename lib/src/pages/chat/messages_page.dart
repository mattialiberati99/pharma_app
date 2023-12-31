import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/helpers/formatDateView.dart';
import 'package:pharma_app/src/pages/chat/widgets/Avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/providers/notification_provider.dart';

import '../../../generated/l10n.dart';
import '../../components/bottomNavigation.dart';
import '../../dialogs/CustomDialog.dart';
import '../../models/chat.dart';
import '../../models/message_data.dart';
import '../../models/route_argument.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../repository/chat_repository.dart';

class MessagesPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    final chatProv = ref.watch(chatProvider);
    final notificationProv = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 246, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
          color: const Color(0xFF333333),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('Notifiche');
            },
            child: notificationProv.notifications.isNotEmpty
                ? const ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    child: Image(
                        width: 24,
                        height: 24,
                        image:
                            AssetImage('assets/immagini_pharma/icon_noti.png')),
                  )
                : const ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    child: Image(
                        image: AssetImage('assets/immagini_pharma/bell.png')),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(sel: SelectedBottom.chat),
      body: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chat',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Check if chats are != 0
            chatProv.chats.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemBuilder: (_, i) => _delegate(
                          chatProv.chats.values.elementAt(i),
                          chatProv,
                          context),
                      itemCount: chatProv.chats.length,
                    ),
                  )
                : const Text(
                    "Nessuna chat disponibile al momento",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _delegate(Chat chat, ChatProvider chatProv, BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return showDialog(
            context: context,
            builder: (_) => CustomDialog(
                title: S.current.delete_chat,
                description: S.current.eliminated_for_both)).then((value) {
          if (value) {
            chatProv.del(chat);
            /* var deleted = await deleteChat(chat.id);
            if (deleted) {
              Navigator.of(context).pop();
              chatProv.chats.remove(chat.id);
            } */
          }
        });
        ;
      },
      direction: DismissDirection.endToStart,
      child: _MessageTile(
        chat: chat,
        chatProv: chatProv,
        messageData: MessageData(
          senderName: chat.shop!.name ?? '',
          message: chat.lastMessage?.text ?? '',
          messageDate: DateTime(2023, 8, 7, 15, 30),
          dateMessage: chat.lastMessage != null
              ? formatDateToDateView(chat.lastMessage!.updated_at!)
              : '',
          profilePicture: chat.shop!.image!.thumb!,
        ),
      ),
    );
  }
}

class _MessageTile extends ConsumerStatefulWidget {
  const _MessageTile(
      {super.key,
      required this.messageData,
      required this.chat,
      required this.chatProv});

  final MessageData messageData;
  final Chat chat;
  final ChatProvider chatProv;

  @override
  ConsumerState<_MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends ConsumerState<_MessageTile> {
  @override
  Widget build(BuildContext context) {
    final chatProv = ref.watch(chatProvider);
    return GestureDetector(
      onTap: () {
        // widget.chatProv.removeUnreadOfChat(widget.chat.id!);
        Navigator.of(context).pushNamed('ChatPage',
            arguments: RouteArgument(id: widget.chat.id));
        chatProv.setAllRead(widget.chat.id);
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom:
                BorderSide(color: Color.fromRGBO(244, 246, 245, 1), width: 10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avatar.medium(url: widget.messageData.profilePicture),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        widget.messageData.senderName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        widget.messageData.message,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.gray1),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      widget.messageData.dateMessage.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray1,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    if (widget.chat.non_read_count > 0)
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${widget.chat.non_read_count}',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
