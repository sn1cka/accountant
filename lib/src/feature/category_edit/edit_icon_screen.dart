import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_accountant/src/core/constant/item_colors.dart';
import 'package:money_accountant/src/core/constant/item_icons.dart';
import 'package:money_accountant/src/core/constant/localization/localization.dart';
import 'package:money_accountant/src/core/ui_kit/icon_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const _colorItemSize = 32;
const _iconSize = 32.0;
const _horizontalPadding = 20.0;
const _itemSpacing = 12.0;

class IconEditScreen extends StatefulWidget {
  const IconEditScreen({
    super.key,
    this.iconIndex,
    this.colorIndex,
  });

  /// Index of icon from [CategoryIcons.icons]
  final int? iconIndex;

  /// Index of color from [CategoryColors.colors]
  final int? colorIndex;

  @override
  State<IconEditScreen> createState() => _IconEditScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('iconIndex', iconIndex))
      ..add(IntProperty('colorIndex', colorIndex));
  }
}

class _IconEditScreenState extends State<IconEditScreen> {
  final PageController _controller = PageController();

  late Color _color;
  late IconData _icon;

  @override
  void initState() {
    super.initState();

    if (widget.iconIndex != null) {
      _icon = CategoryIcons.getIndexed(widget.iconIndex!);
    } else {
      _icon = CategoryIcons.random;
    }

    if (widget.colorIndex != null) {
      _color = CategoryColors.getIndexed(widget.colorIndex!);
    } else {
      _color = CategoryColors.random;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).select_icon),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: Text(S.of(context).done),
                onPressed: () {
                  final result = (CategoryIcons.indexOf(_icon), CategoryColors.indexOf(_color));
                  Navigator.of(context).pop(result);
                },
              ),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final colorsLength = CategoryColors.length;
            final colorsPerPage =
                ((constraints.maxWidth - _horizontalPadding * 2) / (_colorItemSize + _itemSpacing)).floor();
            final pageCount = (colorsLength / colorsPerPage).ceil();

            return Column(
              children: [
                const SizedBox(height: 16),
                Column(
                  children: [
                    CategoryCard(
                      icon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          _icon,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: _iconSize,
                        ),
                      ),
                      color: _color,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                      child: Row(
                        children: [
                          Text(
                            S.of(context).color,
                            style: Theme.of(context).primaryTextTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: _ColorPicker(
                    pageCount: pageCount,
                    colorsPerPage: colorsPerPage,
                    controller: _controller,
                    onSelected: (color) => setState(() {
                      _color = color;
                    }),
                    itemSpacing: _itemSpacing,
                    selectedColor: _color,
                  ),
                ),
                SmoothPageIndicator(
                  onDotClicked: _controller.jumpToPage,
                  controller: _controller,
                  effect: WormEffect(
                    strokeWidth: 20,
                    dotHeight: 4,
                    radius: 4,
                    dotColor: Theme.of(context).primaryColorDark,
                    activeDotColor: Colors.lightBlueAccent,
                  ),
                  count: pageCount,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).icon,
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 11,
                  child: GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: CategoryIcons.length,
                    itemBuilder: (context, index) {
                      final icon = CategoryIcons.icons[index];
                      return CategoryCard(
                        onTap: () => setState(() {
                          _icon = icon;
                        }),
                        icon: Icon(icon),
                        color: icon != _icon ? Theme.of(context).primaryColorDark : Theme.of(context).focusColor,
                      );
                    },
                    padding: const EdgeInsets.only(
                      left: _horizontalPadding,
                      right: _horizontalPadding,
                      bottom: kBottomNavigationBarHeight + kFloatingActionButtonMargin,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: _itemSpacing,
                      crossAxisSpacing: _itemSpacing,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class _ColorPicker extends StatefulWidget {
  const _ColorPicker({
    required this.pageCount,
    required this.colorsPerPage,
    required this.selectedColor,
    required this.controller,
    required this.onSelected,
    required this.itemSpacing,
  });

  final double itemSpacing;

  final int pageCount;

  final int colorsPerPage;

  final Color selectedColor;

  final void Function(Color color) onSelected;

  final PageController controller;

  @override
  State<_ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<_ColorPicker> {
  @override
  Widget build(BuildContext context) => PageView.builder(
        controller: widget.controller,
        itemCount: widget.pageCount,
        itemBuilder: (context, pageIndex) {
          final startIndex = pageIndex * widget.colorsPerPage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                widget.colorsPerPage,
                (index) {
                  final neededIndex = startIndex + index;
                  final isExtraItems = neededIndex >= CategoryColors.length;
                  final color = isExtraItems ? Colors.transparent : CategoryColors.getIndexed(neededIndex);
                  return CircleAvatar(
                    key: isExtraItems ? null : GlobalObjectKey(color),
                    backgroundColor: Colors.transparent,
                    child: CategoryCard(
                      onTap: isExtraItems
                          ? null
                          : () {
                              if (widget.selectedColor != color) widget.onSelected(color);
                            },
                      color: color,
                      icon: widget.selectedColor == color
                          ? const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: CircleAvatar(backgroundColor: Colors.white),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
}
