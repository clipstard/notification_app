import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notification_app/constants/assets.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/dimension.dart';

enum LogoTheme {
  dark,
  gradient,
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    this.title,
    this.color,
    this.logoTheme = LogoTheme.gradient,
    this.brightness = Brightness.light,
    this.displayLeading = true,
    this.leading,
  });

  final Widget? title;
  final Widget? leading;
  final Color? color;
  final LogoTheme? logoTheme;
  final Brightness? brightness;
  final bool displayLeading;

  @override
  Widget build(BuildContext context) {
    final double appBarToolbarOffsetTop = Dimension.appBarHeight -
        Dimension.appBarToolbarHeight -
        Dimension.appBarBottomHeight;

    return AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: appBarToolbarOffsetTop),
          child: _getTitleWidget(),
        ),
        centerTitle: true,
        brightness: brightness,
        backgroundColor: color ?? Colors.transparent,
        elevation: 0,
        toolbarHeight: Dimension.appBarToolbarHeight + appBarToolbarOffsetTop,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Dimension.appBarBottomHeight),
          child: Container(),
        ),
        automaticallyImplyLeading: displayLeading,
        leading: displayLeading
            ? Padding(
                padding: EdgeInsets.only(top: 8),
                child: leading ?? _buildBackButton(context),
              )
            : null);
  }

  @override
  Size get preferredSize => Size.fromHeight(Dimension.appBarHeight);

  Widget _getTitleWidget() {
    if (this.title != null) {
      return this.title!;
    }

    switch (logoTheme) {
      case LogoTheme.dark:
        return SvgPicture.asset(
          Assets.logo,
          height: Dimension.appBarLogoHeight,
        );
      case LogoTheme.gradient:
      default:
        return Image.asset(
          Assets.logoColored,
          height: Dimension.appBarLogoHeight,
        );
    }
  }

  Widget _buildBackButton(BuildContext context) {
    final NavigatorState _navigatorState = Navigator.of(context);

    return _navigatorState.canPop()
        ? IconButton(
            color: Colors.green,
            iconSize: 20,
            icon: Icon(
              Icons.arrow_back,
              color: ColorPalette.liquorice,
            ),
            onPressed: () => _navigatorState.maybePop(),
          )
        : Container();
  }
}
