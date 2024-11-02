import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BannerDetailsScreen extends StatefulWidget {
  final String url ;
  const BannerDetailsScreen({super.key , required this.url});

  
  @override
  State<BannerDetailsScreen> createState() => _BannerDetailsScreenState();
}

class _BannerDetailsScreenState extends State<BannerDetailsScreen> {
  final controller = WebViewController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.loadRequest(Uri.parse(widget.url));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null ,
      body: WebViewWidget(controller: controller),
    );
  }
}
