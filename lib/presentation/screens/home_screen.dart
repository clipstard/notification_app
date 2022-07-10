import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/data/models/consent.dart';
import 'package:notification_app/data/models/custom_field.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/providers/otp_provider.dart';
import 'package:notification_app/data/repositories/authentication_repository.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';
import 'package:notification_app/data/repositories/otp_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/logic/bloc/loyalty_program/loyalty_program_bloc.dart';
import 'package:notification_app/logic/bloc/otp/otp_bloc.dart';
import 'package:notification_app/logic/form_submission_status.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/change_password_screen.dart';
import 'package:notification_app/presentation/screens/empty_screen.dart';
import 'package:notification_app/presentation/screens/reset_email_screen.dart';
import 'package:notification_app/presentation/widgets/alert.dart';
import 'package:notification_app/presentation/widgets/app_switch.dart';
import 'package:notification_app/presentation/widgets/bottom_nav_bar.dart';
import 'package:notification_app/presentation/widgets/floating_input.dart';
import 'package:notification_app/presentation/widgets/get_in_touch.dart';
import 'package:notification_app/presentation/widgets/profile_completion.dart';
import 'package:notification_app/presentation/widgets/useful_links.dart';
import 'package:notification_app/presentation/wrappers/otp_container.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/services/local_storage_service.dart';

part 'package:notification_app/presentation/screens/home_screen/top_rewards_tab.dart';
part 'package:notification_app/presentation/screens/home_screen/all_rewards_tab.dart';
part 'package:notification_app/presentation/screens/home_screen/my_codes_tab.dart';
part 'package:notification_app/presentation/screens/home_screen/my_settings_tab.dart';

enum HomeNavbarIndex {
  TopRewards,
  AllRewards,
  MyCodes,
  Settings,
}

class HomeScreen extends StatefulWidget {
  HomeScreen({
    this.optIn = false,
    this.activeTab = HomeNavbarIndex.TopRewards,
  });

  final bool optIn;
  final HomeNavbarIndex activeTab;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> tabNavigatorKey = GlobalKey();
  HomeNavbarIndex currentTab = HomeNavbarIndex.TopRewards;

  @override
  void initState() {
    currentTab = widget.activeTab;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        currentTab = widget.activeTab;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      bottomNavigationBar: BottomNavBar(
        onTabChanged: (HomeNavbarIndex tabName) {
          setState(() {
            currentTab = tabName;
          });
        },
      ),
      body: _tabPage,
    );
  }

  Widget get _tabPage {
    switch (currentTab) {
      case HomeNavbarIndex.AllRewards:
        return AllRewardsTab();
      case HomeNavbarIndex.MyCodes:
        return MyCodesTab();
      case HomeNavbarIndex.Settings:
        return MySettingsTab();
      default:
        return TopRewardsTab(optIn: widget.optIn);
    }
  }
}
