import 'package:flutter/material.dart';

class DashBoardItem<Data extends Object, AcceptanceData extends Object> extends StatelessWidget {
  static const _iconRadius = 32.0;
  static const _draggingRadius = 40.0;

  final String? title;
  final String? subtitle;
  final Color color;
  final Widget child;
  final Data? data;
  final void Function(AcceptanceData data)? onAccept;
  final VoidCallback? onTap;

  const DashBoardItem({
    required this.child,
    super.key,
    this.data,
    this.title,
    this.subtitle,
    this.color = Colors.red,
    this.onAccept,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: _iconRadius * 2,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Column(
            children: [
              if (title != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              DragTarget<AcceptanceData>(
                onWillAcceptWithDetails: (details) => details.data != this.data && onAccept != null,
                onAcceptWithDetails: (details) => onAccept?.call(details.data),
                builder: (context, candidateData, rejectedData) => Draggable<Data>(
                  maxSimultaneousDrags: data != null ? 1 : 0,
                  data: data,
                  childWhenDragging: Container(
                    height: _iconRadius * 2,
                    width: _iconRadius * 2,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: color),
                      shape: BoxShape.circle,
                    ),
                    child: child,
                  ),
                  feedback: CircleAvatar(
                    radius: _draggingRadius,
                    backgroundColor: color,
                    child: child,
                  ),
                  child: CircleAvatar(
                    radius: _iconRadius,
                    backgroundColor: candidateData.isNotEmpty ? Colors.green : color,
                    child: child,
                  ),
                ),
              ),
              if (subtitle != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
}
