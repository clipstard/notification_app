part of 'package:notification_app/presentation/screens/additional_info_screen.dart';

class BirthdayTab extends StatefulWidget {
  final Function(bool hasSkipped) goToNext;

  const BirthdayTab(
    this.goToNext, {
    Key? key,
  }) : super(key: key);

  @override
  _BirthdayTabState createState() => _BirthdayTabState();
}

class _BirthdayTabState extends State<BirthdayTab> {
  late AppLocalizations _translate;

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: Dimension.xAxisPadding,
        right: Dimension.xAxisPadding,
        bottom: Dimension.yAxisPadding,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BirthdayForm(() {
              widget.goToNext(false);
            }),
            _buildSkip(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkip() {
    return Link(_translate.birthday_form_skip, onTap: () {
      widget.goToNext(true);
    });
  }
}
