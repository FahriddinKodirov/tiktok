import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/data/model/chat_page_arguments.dart';
import 'package:tiktok/data/model/message_chat.dart';
import 'package:tiktok/screen/chat/chat/chat_page.dart';
import 'package:tiktok/screen/chat/full_photo/full_photo_page.dart';
import 'package:tiktok/view_model/chat_view_model.dart';
import 'package:intl/intl.dart';


class ChatBuildItem extends StatefulWidget {
  final ChatPageArguments arguments;
  final List<QueryDocumentSnapshot> listMessage;
  final String currentUserId;
  final DocumentSnapshot document;
  final int index;

  const ChatBuildItem({super.key, required this.currentUserId, required this.document, required this.index, required this.arguments, required this.listMessage});

  @override
  State<ChatBuildItem> createState() => _ChatBuildItemState();
}

class _ChatBuildItemState extends State<ChatBuildItem> {

  @override
  Widget build(BuildContext context) {
    if (widget.document != null) {
      MessageChat messageChat = MessageChat.fromDocument(widget.document);
      if (messageChat.idFrom == widget.currentUserId) {
        // Right (my message)
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            messageChat.type == TypeMessage.text
                // Text
                ? Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    width: 200,
                    decoration: BoxDecoration(color: const Color(0xffE8E8E8), borderRadius: BorderRadius.circular(8)),
                    margin: EdgeInsets.only(bottom: isLastMessageRight(widget.index) ? 20 : 10, right: 10),
                    child: Text(
                      messageChat.content,
                      style: const TextStyle(color: Color(0xffaeaeae)),
                    ),
                  )
                : messageChat.type == TypeMessage.image
                    // Image
                    ? Container(
                        margin: EdgeInsets.only(bottom: isLastMessageRight(widget.index) ? 20 : 10, right: 10),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullPhotoPage(
                                  url: messageChat.content,
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
                          child: Material(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              messageChat.content,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xffE8E8E8),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: const Color(0xfff5a623),
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stackTrace) {
                                return Material(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.asset(
                                    'images/img_not_available.jpeg',
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    // Sticker
                    : Container(
                        margin: EdgeInsets.only(bottom: isLastMessageRight(widget.index) ? 20 : 10, right: 10),
                        child: Image.asset(
                          'images/${messageChat.content}.gif',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
          ],
        );
      } else {
        // Left (peer message)
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  isLastMessageLeft(widget.index)
                      ? Material(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            widget.arguments.peerAvatar,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: const Color(0xfff5a623),
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return const Icon(
                                Icons.account_circle,
                                size: 35,
                                color: Color(0xffaeaeae),
                              );
                            },
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(width: 35),
                  messageChat.type == TypeMessage.text
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          width: 200,
                          decoration:
                              BoxDecoration(color: const Color(0xff203152), borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            messageChat.content,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : messageChat.type == TypeMessage.image
                          ? Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullPhotoPage(url: messageChat.content),
                                    ),
                                  );
                                },
                                style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0))),
                                child: Material(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    messageChat.content,
                                    loadingBuilder:
                                        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration:const BoxDecoration(
                                          color: Color(0xffaeaeae),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        width: 200,
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: const Color(0xfff5a623),
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, object, stackTrace) => Material(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child:  Image.asset(
                                        'images/img_not_available.jpeg',
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(bottom: isLastMessageRight(widget.index) ? 20 : 10, right: 10),
                              child: Image.asset(
                                'images/${messageChat.content}.gif',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                ],
              ),

              // Time
              isLastMessageLeft(widget.index)
                  ? Container(
                      margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                      child: Text(
                        DateFormat('dd MMM kk:mm')
                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageChat.timestamp))),
                        style: const TextStyle(color: Color(0xffaeaeae), fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && widget.listMessage[index - 1].get('idFrom') == widget.currentUserId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && widget.listMessage[index - 1].get('idFrom') != widget.currentUserId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }
}