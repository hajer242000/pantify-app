import 'package:flutter/material.dart';
import 'package:plant_app/utils/dimensions.dart';

class ExpandUpTile extends StatefulWidget {
  final Widget title;
  final Widget subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final bool initiallyExpanded;
  final Duration duration;
  final EdgeInsets headerPadding;
  const ExpandUpTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 200),
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 0),
    this.content,
  });

  @override
  State<ExpandUpTile> createState() => _ExpandUpTileState();
}

class _ExpandUpTileState extends State<ExpandUpTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> size = CurvedAnimation(
    parent: animationController,
    curve: Curves.easeInOut,
  );

  bool open = false;

  @override
  void initState() {
    open = widget.initiallyExpanded;
    if (open) animationController.value = 1;
    super.initState();
  }

  void _toggle() {
    setState(() {
      open = !open;
    });
    open ? animationController.forward() : animationController.reverse();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: open ? 250 : 150,
      width: width(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 202, 201, 201),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10.0),
      child: open
          ? Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizeTransition(
                        sizeFactor: size,
                        axisAlignment: -1.0,
                        child: widget.content,
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 20,
                  color: const Color.fromARGB(255, 220, 219, 219),
                ),
                Expanded(child: constPart()),
              ],
            )
          : Padding(
            padding: const EdgeInsets.all(20.0),
            child: constPart(),
          ),
    );
  }

  InkWell constPart() {
    return InkWell(
      onTap: _toggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
       
          Row(
            children: [
              if (widget.leading != null) widget.leading!,
              Expanded(child:  widget.subtitle),
          
              RotationTransition(
                turns: Tween<double>(begin: 0, end: 0.5).animate(size),
                child: widget.trailing ?? const Icon(Icons.expand_more),
              ),
            ],
          ),
          SizedBox(height: 10),
          widget.title
        ],
      ),
    );
  }
}
