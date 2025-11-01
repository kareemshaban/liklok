import 'package:flutter/cupertino.dart';
import 'package:flutter_svga/flutter_svga.dart';

class GiftSVGAWidget extends StatefulWidget {
  final String giftImg;
  final VoidCallback? onComplete;
  final int? counter;

  const GiftSVGAWidget({
    super.key,
    required this.giftImg,
    this.onComplete, this.counter,
  });

  @override
  State<GiftSVGAWidget> createState() => _GiftSVGAWidgetState();
}

class _GiftSVGAWidgetState extends State<GiftSVGAWidget>
    with SingleTickerProviderStateMixin {
  late SVGAAnimationController _controller;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    print('start display');
    print(widget.giftImg);
    _controller = SVGAAnimationController(vsync: this);

    SVGAParser().decodeFromURL(widget.giftImg).then((videoItem) {
      if (!mounted) return;

      _controller.videoItem = videoItem;
      _controller.repeat(count: 1);

      _controller.addListener(() {
        if (_controller.isCompleted && mounted) {
          setState(() {
            _visible = false;
          });
          if (widget.onComplete != null) widget.onComplete!();
        }
      });

      _controller.forward();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _visible
        ? SVGAImage(
      _controller,
      fit: BoxFit.contain,
      clearsAfterStop: false,
    )
        : const SizedBox.shrink();
  }
}
