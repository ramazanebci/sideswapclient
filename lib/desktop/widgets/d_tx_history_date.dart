import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DTxHistoryDate extends StatelessWidget {
  const DTxHistoryDate({
    super.key,
    required this.dateFormatDate,
    required this.dateFormatTime,
    required this.tx,
  });

  final DateFormat dateFormatDate;
  final DateFormat dateFormatTime;
  final TransItem tx;

  @override
  Widget build(BuildContext context) {
    final timestampCopy =
        DateTime.fromMillisecondsSinceEpoch(tx.createdAt.toInt());
    return Row(children: [
      Text(dateFormatDate.format(timestampCopy)),
      Text(
        dateFormatTime.format(timestampCopy),
        style: const TextStyle(
          color: Color(0xFF709EBA),
        ),
      ),
    ]);
  }
}