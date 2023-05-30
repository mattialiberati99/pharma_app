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
  static const _pageSize = 20;

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
    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          setState(() {
            showEmoji = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return chat != null
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: ChatAppBar(
              backPressed: () {
                chatProv.setAllRead(chat!.id);
                Navigator.of(context).pushReplacementNamed('Home');
              },
              titleWidget: Row(
                children: <Widget>[
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(60),
                  //   child: CachedNetworkImage(
                  //     imageUrl: chat!.other!.image!.thumb!,
                  //     height: 50,
                  //     width: 50,
                  //   ),
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, top: 4),
                      child: AutoSizeText(
                        chat!.other!.name!,
                        style: const TextStyle(color: AppColors.lightGray1),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                ],
              ),
              backgroundColor: Colors.white,
              actions: [
                InkWell(
                    onTap: () => showDialog(
                                context: context,
                                builder: (_) => CustomDialog(
                                    title: S.current.delete_chat,
                                    description: S.current.eliminated_for_both))
                            .then((value) async {
                          if (value) {
                            var deleted =
                                await deleteChat(widget.routeArgument.id);
                            if (deleted) {
                              Navigator.of(context).pop();
                            }
                          }
                        }),
                    child: const Icon(
                      Icons.delete_forever,
                      color: AppColors.mainBlack,
                    )),
                PopupMenuButton<String>(
                  onSelected: (a) {}, //chatProv.handleReport,
                  itemBuilder: (BuildContext context) {
                    return {S.current.report_user, S.current.block_user}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.mainBlack,
                  ),
                ),
              ],
            ),
            body: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: widget.theme == EnumChatTheme.DARK
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).backgroundColor,
                              Colors.black
                            ],
                          )
                        : const LinearGradient(
                            colors: [Colors.white, Colors.white]),
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
                                    S.current
                                        .send_first_message(chat!.other!.name!),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: AppColors.primary),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0),
                            //height: 130,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: DetectableTextField(
                                    detectionRegExp: hashTagAtSignUrlRegExp,
                                    focusNode: focusNode,
                                    controller: _textEditingController,
                                    decoratedStyle:
                                        TextStyle(color: AppColors.solidBlack),
                                    basicStyle: const TextStyle(
                                        color: AppColors.primary),
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.gray8,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: S.current.typeToStartChat,
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      prefixIcon: GestureDetector(
                                        onTap: () =>
                                            ChatHelper.showUploadMediaDialog(
                                                chatProv, chat!.id!, context),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.black,
                                        ),
                                      ), //contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: AppColors.error,
                                    child: IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/ico/invia.svg',
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (_textEditingController
                                            .text.isNotEmpty) {
                                          await chatProv.sendMessage(chat!,
                                              _textEditingController.text);
                                          setState(() =>
                                              _textEditingController.clear());
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
          )
        : CircularLoadingWidget(height: 500);
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


// appBar: const CustomAppBar(
// title: "BringIt User",
// hideLogo: true,
// ),