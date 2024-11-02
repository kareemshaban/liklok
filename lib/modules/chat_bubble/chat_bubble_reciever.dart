import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message ;
  const ChatBubble({
    super.key ,
    required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width:  MediaQuery.of(context).size.width * 0.5,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Container(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(10.0),
                  topEnd: Radius.circular(10.0),
                  bottomEnd: Radius.circular(10.0),
                ),
                color: Colors.grey[700] ,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style:const TextStyle(fontSize: 16.0 , color: Colors.white),
                    maxLines: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
