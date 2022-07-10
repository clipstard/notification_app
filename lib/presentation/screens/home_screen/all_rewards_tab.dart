part of 'package:notification_app/presentation/screens/home_screen.dart';

class AllRewardsTab extends StatelessWidget {
  const AllRewardsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      child: Container(
        child: Heading(AppLocalizations.of(context)!.all_rewards_screen_title),
      ),
    );
  }
}
