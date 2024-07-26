import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// [CategoryIcons] is a util for Icons used categories
/// such as expenses, income
abstract final class CategoryIcons {
  /// Count of icons
  static int get length => icons.length;

  /// returns random [IconData] from predefined list
  static IconData get random => icons[Random().nextInt(length)];

  /// returns [IconData] predefined in list
  static IconData getIndexed(int index) {
    assert(index >= 0 && index < length, 'Icon index in getIndexed is $index and out of range 0..${length - 1}');
    return icons[index];
  }

  /// The first index of element in this list. return -1 if value not found
  static int indexOf(IconData icon) => icons.indexOf(icon);

  /// All available icons
  static const icons = [
    /// Icons from the Material package
    Icons.account_balance,
    Icons.attach_money,
    Icons.euro_outlined,
    Icons.credit_card,
    Icons.monetization_on,
    Icons.account_circle,
    Icons.account_balance_wallet,
    Icons.money,
    Icons.show_chart,
    Icons.settings,
    Icons.lock,
    Icons.payment,
    Icons.receipt,
    Icons.timeline,
    Icons.trending_up,
    Icons.trending_down,
    Icons.shopping_cart,
    Icons.attach_file,
    Icons.wifi,
    Icons.bluetooth,
    Icons.language,
    Icons.report,
    Icons.phone,
    Icons.mail,
    Icons.notifications,
    Icons.star,
    Icons.favorite,
    Icons.lightbulb_outline,
    Icons.thumb_up,
    Icons.thumb_down,
    Icons.headset,
    Icons.mic,
    Icons.volume_up,
    Icons.camera,
    Icons.photo,
    Icons.photo_camera,
    Icons.movie,
    Icons.local_movies,
    Icons.music_note,
    Icons.play_circle_filled,
    Icons.stop,

    /// Icons from the CupertinoIcons package
    CupertinoIcons.globe,
    CupertinoIcons.profile_circled,
    CupertinoIcons.creditcard,
    CupertinoIcons.person,
    CupertinoIcons.square_arrow_right,
    CupertinoIcons.square_arrow_up,
    CupertinoIcons.square_list,
    CupertinoIcons.square_grid_2x2,
    CupertinoIcons.lock_fill,
    CupertinoIcons.lock_open_fill,
    CupertinoIcons.checkmark_seal,
    CupertinoIcons.xmark_seal,
    CupertinoIcons.heart_fill,
    CupertinoIcons.star_fill,
    CupertinoIcons.bell_fill,
    CupertinoIcons.bolt_fill,
    CupertinoIcons.house,
    CupertinoIcons.house_fill,
    CupertinoIcons.person_badge_plus,
    CupertinoIcons.phone,
    CupertinoIcons.mail,
    CupertinoIcons.news,
    CupertinoIcons.music_note,
    CupertinoIcons.mic,
    CupertinoIcons.ant_fill,
    CupertinoIcons.calendar,
    CupertinoIcons.chart_bar,
    CupertinoIcons.chart_pie,
  ];
}
