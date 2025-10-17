import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameModal extends StatefulWidget {
  final int id ;
  final double height_ratio ;
  const GameModal({super.key , required this.id , required this.height_ratio});

  @override
  State<GameModal> createState() => _GameModalState();
}

class _GameModalState extends State<GameModal> {

  String url = '';
  AppUser? user ;
  late final WebViewController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      url = '${GAMETESTSERVER}?mimi=0&showMiniExitBtn=1&appKey=${GAMEAPPKEY}&token=${user!.token}&gameId=${widget.id}';
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));


  }

  @override

  Widget build(BuildContext context) {
    return  SafeArea(
      child: Container(
          height: MediaQuery.sizeOf(context).height * widget.height_ratio,
          decoration: BoxDecoration(color: Colors.white.withAlpha(200),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
              border: Border(top: BorderSide(width: 4.0, color: MyColors.secondaryColor),) ),
            child:WebViewWidget(controller: _controller),
      
      
        ),
    );
  }
}
