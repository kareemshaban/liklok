import 'package:LikLok/models/Relation.dart';
import 'package:LikLok/shared/network/remote/RelationsServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatBubble extends StatefulWidget {
  final String message ;
  final int sender_id ;
  final int current_user_id ;
  final int reciver_id ;

  const ChatBubble({
    super.key ,
    required this.message,
    required this.sender_id,
    required this.current_user_id,
    required this.reciver_id

  });


  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {

 late RelationModel relationModel ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRelation();
  }
 int isCompleted = 1;

 getRelation() async {
   if  (widget.message.contains('YOU CAN DECLINE OR ACCEPT')){
     String relation = widget.message.substring(widget.message.indexOf('RELATION_ID') + 11, widget.message.length);
     print('widget.sender_id2');
     print(widget.sender_id);
     print('widget.reciver_id2');
     print(widget.reciver_id);
     bool res = await RelationsServices().getRelation(widget.sender_id, int.parse(relation), widget.reciver_id);
     setState(() {
       if(res){
         isCompleted = 1 ;
       } else {
         isCompleted = 0 ;
       }
     });
   }


 }

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
                  (widget.message.contains('YOU CAN DECLINE OR ACCEPT')) ? Text(
                    widget.message.substring(0 , widget.message.indexOf('YOU CAN DECLINE OR ACCEPT')),
                    style:const TextStyle(fontSize: 16.0 , color: Colors.white),
                    maxLines: 20,
                    overflow: TextOverflow.ellipsis,
                  ):
                  Text(
                    widget.message,
                    style:const TextStyle(fontSize: 16.0 , color: Colors.white),
                    maxLines: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                  (widget.message.contains('YOU CAN DECLINE OR ACCEPT')) ? Center(
                    child: (widget.sender_id == widget.current_user_id && isCompleted == 0) ?  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        print('showAlertDialog');

                        showAlertDialog(context);
                      },
                      child: Container(
                        height: 40.0,

                        margin: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        child:  Center(child: Text("Take Action" , style: TextStyle(color: Colors.white),)),
                      ),
                    ) : Container(),
                  ) : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("accept_btn".tr , style: TextStyle(color: Colors.green),),
      onPressed: () {
        acceptRelation();

      },
    );
    Widget cancelButton = TextButton(
      child: Text("cancel_btn".tr , style: TextStyle(color: Colors.red),),
      onPressed: () {
        refuseRelation();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: MyColors.darkColor,
      title: Text("relation_dialog_title".tr , style: TextStyle(color: MyColors.primaryColor),),
      content: Text("relation_dialog_msg".tr , style: TextStyle(color: MyColors.whiteColor),),
      actions: [
        okButton,
        cancelButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  acceptRelation() async{
    String relation = widget.message.substring(widget.message.indexOf('RELATION_ID') , widget.message.length);
    print(relation);

    //bool res = await RelationsServices().acceptRelation(current_user_id, relation, reciver_id);



  }

  refuseRelation(){

  }
}
