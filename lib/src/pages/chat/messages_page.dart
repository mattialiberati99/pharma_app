import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/pages/chat/widgets/Avatar.dart';

import '../../components/bottomNavigation.dart';
import '../../models/message_data.dart';

class MessagesPage extends StatelessWidget {
  bool noty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onTap: () => Navigator.of(context).pushNamed('Notifiche'),
            child: noty
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Chat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: _delegate,
                itemCount: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _delegate(BuildContext context, int index) {
    return _MessageTile(
      messageData: MessageData(
        senderName: 'Dott. Bianchi',
        message: 'prova messaggio',
        messageDate: DateTime(2023, 8, 7, 15, 30),
        dateMessage: 'prova dateMessage',
        profilePicture: 'https://picsum.photos/seed/1241/300/300',
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({super.key, required this.messageData});

  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Avatar.medium(url: messageData.profilePicture),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              messageData.senderName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                letterSpacing: 0.2,
                wordSpacing: 1.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 20,
              child: Text(
                messageData.message,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.gray1),
              ),
            ),
          ],
        ))
      ],
    );
  }
}
