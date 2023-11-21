// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_height_plugin/keyboard_height_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import '../../../generated/l10n.dart';
import '../../elements/CircularLoadingWidget.dart';
import 'chat_helper.dart';
import 'widgets/ChatAppBar.dart';
import '../../dialogs/CustomDialog.dart';
import '../../helpers/app_config.dart';
import '../../helpers/formatDateView.dart';
import '../../models/chat.dart';
import '../../models/message.dart';
import '../../models/route_argument.dart';
import '../../providers/chat_provider.dart';
import '../../repository/chat_repository.dart';
import 'widgets/MessageList.dart';

enum EnumChatTheme { LIGHT, DARK }

class ChatPage extends ConsumerStatefulWidget {
  ChatPage({
    Key? key,
    required this.routeArgument,
  }) : super(key: key);
  final RouteArgument routeArgument;
  final EnumChatTheme theme = EnumChatTheme.LIGHT;
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends ConsumerState<ChatPage> {
  final _textEditingController = TextEditingController();
  int? currentDay, prevDay;

  bool showEmoji = false;

  FocusNode focusNode = FocusNode();
  late ChatProvider chatProv;
  Chat? chat;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      chatProv = ref.watch(chatProvider);
      chat = await chatProv.getChat(widget.routeArgument.id);
      setState(() {});
    });
    super.initState();
    currentDay = prevDay = -1;
    focusNode.addListener(() {
      if (focusNode.hasFocus) setState(() => showEmoji = false);
    });
  }

  @override
  void dispose() {
    chatProv.setAllRead(widget.routeArgument.id);
    super.dispose();
  }

  Future<bool> onBackPress() {
    if (showEmoji) {
      setState(() {
        showEmoji = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    if (chat == null) return CircularLoadingWidget(height: 500);
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 246, 245, 1),
      resizeToAvoidBottomInset: true,
      appBar: ChatAppBar(
        titleWidget: InkWell(
          onTap: () => Navigator.of(context)
              .pushReplacementNamed('Store', arguments: chat!.shop!),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CachedNetworkImage(
                  imageUrl: chat!.shop!.image!.thumb!,
                  height: 40,
                  width: 40,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 4, top: 4),
                  child: AutoSizeText(
                    chat!.shop!.name!,
                    style: ExtraTextStyles.bigBlack,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              launch('tel://${chat!.shop!.mobile}');
            },
          ),
        ],
        // actions: [
        //   InkWell(
        //       onTap: () => showDialog(
        //                   context: context,
        //                   builder: (_) => CustomDialog(
        //                       title: S.current.delete_chat,
        //                       description: S.current.eliminated_for_both))
        //               .then((value) async {
        //             if (value) {
        //               var deleted =
        //                   await deleteChat(widget.routeArgument.id);
        //               if (deleted) {
        //                 Navigator.of(context).pop();
        //               }
        //             }
        //           }),
        //       child: Icon(
        //         Icons.delete_forever,
        //         color: AppColors.mainBlack,
        //       )),
        //   PopupMenuButton<String>(
        //     onSelected: (a) {}, //chatProv.handleReport,
        //     itemBuilder: (BuildContext context) {
        //       return {S.current.report_user, S.current.block_user}
        //           .map((String choice) {
        //         return PopupMenuItem<String>(
        //           value: choice,
        //           child: Text(choice),
        //         );
        //       }).toList();
        //     },
        //     icon: Icon(
        //       Icons.more_vert,
        //       color: AppColors.mainBlack,
        //     ),
        //   ),
        // ],
      ),
      body: Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: widget.theme == EnumChatTheme.DARK
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Theme.of(context).backgroundColor, Colors.black],
                    )
                  : LinearGradient(colors: [Colors.white, Colors.white]),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: chat!.messages.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 48.0, horizontal: 24.0),
                          child: Container(
                            child: Text(
                              S.current.send_first_message(chat!.shop!.name!),
                              textAlign: TextAlign.center,
                              style: ExtraTextStyles.bigGreyW,
                            ),
                          ))
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MessageList(chatId: chat!.id!)),
                ),

                // ( &&
                //         !chat.user!.has_blocked! &&
                //         !chat.other!.has_blocked!)
                //TODO - blocked
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    //height: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                margin: EdgeInsets.only(
                                    left: 2, right: 2, bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: DetectableTextField(
                                  detectionRegExp: hashTagAtSignUrlRegExp,
                                  focusNode: focusNode,
                                  controller: _textEditingController,
                                  decoratedStyle: ExtraTextStyles.normalBlack,
                                  basicStyle: ExtraTextStyles.normalBlack,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  minLines: 1,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Scrivi il messaggio",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    prefixIcon: GestureDetector(
                                      onTap: () =>
                                          ChatHelper.showUploadMediaDialog(
                                              chatProv, chat!.id!, context),
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_textEditingController.text.isEmpty)
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              /*decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),*/
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.emoji_emotions,
                                                  color: Colors.grey.shade400,
                                                ),
                                                onPressed: () {
                                                  focusNode.unfocus();
                                                  focusNode.canRequestFocus =
                                                      false;
                                                  setState(() {
                                                    showEmoji = !showEmoji;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 0,
                                            right: 0,
                                            left: 2,
                                          ),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: AppColors.primary,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.send,
                                                color: Colors.white,
                                              ),
                                              onPressed: () async {
                                                if (_textEditingController
                                                    .text.isNotEmpty) {
                                                  await chatProv.sendMessage(
                                                      chat!,
                                                      _textEditingController
                                                          .text);
                                                  setState(() =>
                                                      _textEditingController
                                                          .clear());
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //contentPadding: EdgeInsets.all(5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                // : Center(
                //     child: Padding(
                //     padding: const EdgeInsets.only(bottom: 24.0),
                //     child: Container(
                //       child: Column(
                //         children: [
                //           Text(
                //             S.current.blocked,
                //             style: TextStyles.normalWhite,
                //           ),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           if (chat.user!.has_blocked!)
                //             MaterialButton(
                //               child: Text(S.current.unlock),
                //               onPressed: () {
                //                 chat.user!.has_blocked =
                //                     false;
                //                 //_con.updateConversation();
                //               },
                //             )

                ,
                if (showEmoji)
                  Container(
                    height: 200,
                    //width: 300,
                    child: EmojiPicker(
                      onEmojiSelected: (emoji, category) {
                        _textEditingController.text += category.emoji;
                      },
                    ),
                  ),
              ],
            )),
      ),
    );
  }

  Widget buildDayHeading(Message message) {
    prevDay = currentDay;
    currentDay = message.updated_at?.day;
    if (currentDay != prevDay || currentDay == -1) {
      return Padding(
        padding: const EdgeInsets.all(30),
        child: RichText(
          text: TextSpan(
            text: formatDateToDateView(message.updated_at!),
            style: const TextStyle(color: AppColors.primary),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
