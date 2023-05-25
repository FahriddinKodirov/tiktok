import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tiktok/data/model/chat_page_arguments.dart';
import 'package:tiktok/view_model/chat_view_model.dart';

class StikerWidget extends StatefulWidget {
  final ChatPageArguments arguments;
  final TextEditingController textEditingController;
  final ScrollController listScrollController;
  final ChatProvider chatProvider;
  final String currentUserId;
  final String groupChatId;


  const StikerWidget({super.key, required this.arguments, required this.textEditingController, required this.listScrollController, required this.currentUserId, required this.groupChatId, required this.chatProvider});

  @override
  State<StikerWidget> createState() => _StikerWidgetState();
}

class _StikerWidgetState extends State<StikerWidget> {

   late ChatProvider chatProvider;

   void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      widget.textEditingController.clear();
      chatProvider.sendMessage(content, type, widget.groupChatId, widget.currentUserId, widget.arguments.peerId);
      if (widget.listScrollController.hasClients) {
        widget.listScrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
      }
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send', backgroundColor: const Color(0xffaeaeae));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xffE8E8E8), width: 0.5)), color: Colors.white),
        padding: const EdgeInsets.all(5),
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => onSendMessage('mimi1', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi1.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi2', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi2.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi3', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi3.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => onSendMessage('mimi4', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi4.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi5', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi5.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi6', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi6.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi7', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi7.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi8', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi8.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi9', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi9.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}