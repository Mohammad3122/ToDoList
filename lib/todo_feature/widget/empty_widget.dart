import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:practice_bloc/tools/media_query.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/empty.json',
            width: getWidth(context, 1),
          ),
          Text(
            'لیست خالی است',
            style: TextStyle(
              fontFamily: 'nasim',
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
