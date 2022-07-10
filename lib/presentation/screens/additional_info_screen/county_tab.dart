part of 'package:notification_app/presentation/screens/additional_info_screen.dart';

class CountyTab extends StatefulWidget {
  final Function(bool hasSkipped) callback;

  const CountyTab(
    this.callback, {
    Key? key,
  }) : super(key: key);

  @override
  _CountyTabState createState() => _CountyTabState();
}

class _CountyTabState extends State<CountyTab> {
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
            CountyForm(() {
              widget.callback(false);
            }),
            _buildSkip(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkip() {
    return Link(_translate.county_form_skip, onTap: () {
      widget.callback(true);
    });
  }
}
