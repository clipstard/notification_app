part of 'package:notification_app/presentation/screens/home_screen.dart';

class MyCodesTab extends StatelessWidget {
  const MyCodesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      child: Container(
        child: Heading(AppLocalizations.of(context)!.my_codes_screen_title),
      ),
    );
  }
}
