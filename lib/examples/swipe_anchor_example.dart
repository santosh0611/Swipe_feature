import 'dart:math';

import 'package:example/widgets/bottom_buttons_row.dart';
import 'package:example/widgets/card_overlay.dart';
import 'package:example/widgets/example_card.dart';
import 'package:example/widgets/fade_route.dart';
import 'package:example/widgets/general_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

const _images = [
  'images/image_5.jpg',
  'images/image_3.jpg',
  'images/image_4.jpg',
];

class SwipeAnchorExample extends StatefulWidget {
  const SwipeAnchorExample._();

  static Route<void> route() {
    return FadeRoute(
      builder: (context) => const SwipeAnchorExample._(),
    );
  }

  @override
  _SwipeAnchorExampleState createState() => _SwipeAnchorExampleState();
}

class _SwipeAnchorExampleState extends State<SwipeAnchorExample> {
  late final SwipableStackController _controller;

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  void _skipCard() {
    setState(() {
      _images.removeAt(0);
      _controller.next(swipeDirection: SwipeDirection.up);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe Feature'),
      ),
      drawer: const GeneralDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SwipableStack(
                  controller: _controller,
                  stackClipBehaviour: Clip.none,
                  // If you want to change the position of anchor for cards,
                  // set [swipeAnchor].
                  swipeAnchor: SwipeAnchor.bottom,
                  onWillMoveNext: (index, swipeDirection) {
                    // Return true for the desired swipe direction.
                    switch (swipeDirection) {
                      case SwipeDirection.left:
                        return true;
                      case SwipeDirection.right:
                        return true;
                      case SwipeDirection.up:
                        return true;
                      case SwipeDirection.down:
                        return true;
                      case SwipeDirection.side:
                        return true;
                    }
                  },
                  onSwipeCompleted: (index, direction) {
                    if (direction == SwipeDirection.up) {
                      if (kDebugMode) {
                        print('The user has Strongly Agreed to the question');
                      }
                    }
                    if (direction == SwipeDirection.down) {
                      if (kDebugMode) {
                        // ignore: lines_longer_than_80_chars
                        print(
                          'The user strongly Disagreed to the question',
                        );
                      }
                    }
                    if (direction == SwipeDirection.right) {
                      if (kDebugMode) {
                        print('The user has agreed to the question');
                      }
                    }
                    if (direction == SwipeDirection.left) {
                      if (kDebugMode) {
                        print('The user has Disagreed to the question');
                      }
                    }
                    if (direction == SwipeDirection.side) {
                      if (kDebugMode) {
                        print('The user has skipped the question');
                      }
                    }
                  },
                  horizontalSwipeThreshold: 0.8,
                  // Set max value to ignore vertical threshold.
                  verticalSwipeThreshold: 1,
                  overlayBuilder: (
                    context,
                    properties,
                  ) =>
                      CardOverlay(
                    swipeProgress: properties.swipeProgress,
                    direction: properties.direction,
                  ),
                  builder: (context, properties) {
                    final itemIndex = properties.index % _images.length;
                    return ExampleCard(
                      name: 'Sample No.${itemIndex + 1}',
                      assetPath: _images[itemIndex],
                    );
                  },
                ),
              ),
            ),
            BottomButtonsRow(
              onSwipe: (direction) {
                _controller.next(swipeDirection: direction);
              },
              onRewindTap: _controller.rewind,
              canRewind: _controller.canRewind,
            ),
          ],
        ),
      ),
    );
  }
}
