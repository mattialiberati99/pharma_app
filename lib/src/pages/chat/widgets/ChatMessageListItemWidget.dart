// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../helpers/app_config.dart';
import '../chat_helper.dart';
import '../../../models/message.dart';
import 'MessageImageWidget.dart';

class ChatMessageListItem extends StatefulWidget {
  final Message message;

  ChatMessageListItem({required this.message});

  @override
  _ChatMessageListItemState createState() => _ChatMessageListItemState();
}

class _ChatMessageListItemState extends State<ChatMessageListItem> {
  Widget playerWidget = Container();
  @override
  void initState() {
    //if(widget.message.content!=null  && widget.message.content.collection=='audio')
    //initPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.message.from_user
        ? getSentMessageLayout(context)
        : getReceivedMessageLayout(context);
  }

  Widget getSentMessageLayout(context) {
    //print(message.time);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
            color: AppColors.secondColor.withOpacity(0.3),
            /*boxShadow: [
              BoxShadow(
                  color: Colors.black12, spreadRadius: 1.0, blurRadius: 10.0)
            ],*/
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //new Text(this.message.user.name, style: TextStyles.normalBlack.merge(TextStyle(fontWeight: FontWeight.w600))),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: TextEditingController(text: widget.message.text),
                style: const TextStyle(color: AppColors.primary),
                readOnly: true,
                maxLines: null,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            if (widget.message.content != null &&
                widget.message.content?.collection == 'image')
              MessageImageWidget(media: widget.message.content!)
          ],
        ),
      ),
    );
  }

  Widget getReceivedMessageLayout(context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //new Text(this.message.user.name, style: TextStyles.normalBlack.merge(TextStyle(fontWeight: FontWeight.w600))),

            /*        Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text( widget.message.text!,
                overflow: TextOverflow.fade,
                maxLines: null,
              ),
            ), */

            const SizedBox(
              height: 6,
            ),
            if (widget.message.content != null &&
                widget.message.content!.collection == 'image')
              MessageImageWidget(media: widget.message.content!)
          ],
        ),
      ),
    );
  }
}
