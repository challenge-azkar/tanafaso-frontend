import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserProgressLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'المواظبة',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 45,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: LineWidget(
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'الإنجازات',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 45,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: LineWidget(
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
 Widget that represents the lines Loading in the widget.
  */
class LineWidget extends StatelessWidget {
  final double width;

  LineWidget({@required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: MediaQuery.of(context).size.height / 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
        boxShadow: [
          BoxShadow(color: Colors.black, spreadRadius: 0.2),
        ],
      ),
    );
  }
}
