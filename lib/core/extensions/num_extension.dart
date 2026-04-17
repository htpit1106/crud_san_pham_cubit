import 'package:flutter/material.dart';

extension NumExtension on num {
  // Duration
  Duration get seconds => Duration(seconds: toInt());
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get microseconds => Duration(microseconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
  Duration get hours => Duration(hours: toInt());
  Duration get days => Duration(days: toInt());
  Duration get weeks => Duration(days: toInt() * 7);
  Duration get months => Duration(days: toInt() * 30);
  Duration get years => Duration(days: toInt() * 365);

  // SizedBox
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());

  // Padding
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());
  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get paddingOnlyLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get paddingOnlyRight => EdgeInsets.only(right: toDouble());
  EdgeInsets get paddingOnlyTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get paddingOnlyBottom => EdgeInsets.only(bottom: toDouble());

  // BorderRadius
  BorderRadius get radius => BorderRadius.circular(toDouble());
  BorderRadius get radiusTop =>
      BorderRadius.vertical(top: Radius.circular(toDouble()));
  BorderRadius get radiusBottom =>
      BorderRadius.vertical(bottom: Radius.circular(toDouble()));
  BorderRadius get radiusLeft =>
      BorderRadius.horizontal(left: Radius.circular(toDouble()));
  BorderRadius get radiusRight =>
      BorderRadius.horizontal(right: Radius.circular(toDouble()));
}
