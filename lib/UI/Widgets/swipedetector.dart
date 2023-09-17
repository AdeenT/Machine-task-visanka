import 'package:flutter/material.dart';

class SwipeConfiguration {
  //Vertical swipe configuration options
  double verticalSwipeMaxWidthThreshold = 50.0;
  double verticalSwipeMinDisplacement = 100.0;
  double verticalSwipeMinVelocity = 300.0;

  //Horizontal swipe configuration options
  double horizontalSwipeMaxHeightThreshold = 50.0;
  double horizontalSwipeMinDisplacement = 100.0;
  double horizontalSwipeMinVelocity = 300.0;

  SwipeConfiguration({
    required double verticalSwipeMaxWidthThreshold,
    required double verticalSwipeMinDisplacement,
    double? verticalSwipeMinVelocity,
    double? horizontalSwipeMaxHeightThreshold,
    double? horizontalSwipeMinDisplacement,
    double? horizontalSwipeMinVelocity,
  }) {
    this.verticalSwipeMaxWidthThreshold = verticalSwipeMaxWidthThreshold;

    this.verticalSwipeMinDisplacement = verticalSwipeMinDisplacement;

    this.verticalSwipeMinVelocity = verticalSwipeMinVelocity!;

    this.horizontalSwipeMaxHeightThreshold = horizontalSwipeMaxHeightThreshold!;

    this.horizontalSwipeMinDisplacement = horizontalSwipeMinDisplacement!;

    this.horizontalSwipeMinVelocity = horizontalSwipeMinVelocity!;
  }
}

class SwipeDetector extends StatelessWidget {
  final Widget child;
  final Function()? onSwipeUp;
  final Function()? onSwipeDown;
  final Function()? onSwipeLeft;
  final Function()? onSwipeRight;
  final SwipeConfiguration? swipeConfiguration;

  SwipeDetector(
      {required this.child,
      this.onSwipeUp,
      this.onSwipeDown,
      this.onSwipeLeft,
      this.onSwipeRight,
      SwipeConfiguration? swipeConfiguration})
      : this.swipeConfiguration = swipeConfiguration == null
            ? SwipeConfiguration(
                verticalSwipeMaxWidthThreshold: 50,
                verticalSwipeMinDisplacement: 100)
            : swipeConfiguration;

  @override
  Widget build(BuildContext context) {
    //Vertical drag details
    DragStartDetails? startVerticalDragDetails;
    DragUpdateDetails? updateVerticalDragDetails;

    //Horizontal drag details
    DragStartDetails? startHorizontalDragDetails;
    DragUpdateDetails? updateHorizontalDragDetails;

    return GestureDetector(
      child: child,
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        double dx = updateVerticalDragDetails!.globalPosition.dx -
            startVerticalDragDetails!.globalPosition.dx;
        double dy = updateVerticalDragDetails!.globalPosition.dy -
            startVerticalDragDetails!.globalPosition.dy;
        double velocity = endDetails.primaryVelocity ?? 0;

        //Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx > swipeConfiguration!.verticalSwipeMaxWidthThreshold) return;
        if (dy < swipeConfiguration!.verticalSwipeMinDisplacement) return;
        if (positiveVelocity < swipeConfiguration!.verticalSwipeMinVelocity)
          return;

        if (velocity < 0) {
          //Swipe Up
          onSwipeUp!();
        } else {
          //Swipe Down
          onSwipeDown!();
        }
      },
      onHorizontalDragStart: (dragDetails) {
        startHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragUpdate: (dragDetails) {
        updateHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragEnd: (endDetails) {
        double dx = updateHorizontalDragDetails!.globalPosition.dx -
            startHorizontalDragDetails!.globalPosition.dx;
        double dy = updateHorizontalDragDetails!.globalPosition.dy -
            startHorizontalDragDetails!.globalPosition.dy;
        double velocity = endDetails.primaryVelocity ?? 0;

        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        print("$dx $dy $velocity $positiveVelocity");

        if (dx < swipeConfiguration!.horizontalSwipeMinDisplacement) return;
        if (dy > swipeConfiguration!.horizontalSwipeMaxHeightThreshold) return;
        if (positiveVelocity < swipeConfiguration!.horizontalSwipeMinVelocity)
          return;

        if (velocity < 0) {
          //Swipe Up
          onSwipeLeft!();
        } else {
          //Swipe Down
          onSwipeRight!();
        }
      },
    );
  }
}
