import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/constants/typography.dart';

class AppCarouselSlider extends StatefulWidget {
  final List<Widget> items;
  final double startIndex;

  AppCarouselSlider({required this.items, this.startIndex = 0});

  @override
  State<StatefulWidget> createState() => _AppCarouselSliderState(startIndex);

  static Container carouselSlide(
    BuildContext context, {
    required String mainText,
    required String descriptionText,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: TextTypography.h1_d_mb),
            child: Text(
              mainText,
              style: TextTypography.h1_d,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: TextTypography.body_copy_mb),
            child: Text(
              descriptionText,
              style: TextTypography.body_copy,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppCarouselSliderState extends State<AppCarouselSlider> {
  double currentItemIndex = 0;

  _AppCarouselSliderState(double currentItemIndex) {
    this.currentItemIndex = currentItemIndex;
  }

  final double _dotSize = 20;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        _buildCarousel(),
        _buildDotsIndicator(),
      ],
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      items: _carouselContent(),
      options: CarouselOptions(
          height: 240,
          autoPlay: false,
          enlargeCenterPage: true,
          viewportFraction: 1,
          enableInfiniteScroll: _slidesCount >= 1,
          onPageChanged: (int index, _) {
            setState(() {
              currentItemIndex = index.toDouble();
            });
          }),
    );
  }

  Widget _buildDotsIndicator() {
    return _slidesCount > 0
        ? DotsIndicator(
            dotsCount: _slidesCount,
            position: currentItemIndex,
            decorator: DotsDecorator(
              color: Color.fromRGBO(255, 255, 255, 0.5),
              // Inactive color
              activeColor: Colors.black87,
              spacing: EdgeInsets.fromLTRB(12, 0, 12, 0),
              size: Size(_dotSize, _dotSize),
              activeSize: Size(_dotSize, _dotSize),
            ),
          )
        : SizedBox.shrink();
  }

  List<Widget> _carouselContent() {
    return widget.items
        .map(
          (Widget item) => Builder(
            builder: (BuildContext builderContext) => Container(
              width: MediaQuery.of(builderContext).size.width,
              decoration: BoxDecoration(color: Colors.transparent),
              child: item,
            ),
          ),
        )
        .toList();
  }

  int get _slidesCount {
    return widget.items.length;
  }
}
