import 'package:flutter/material.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';

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
      body: _tabPage,
    );
  }

  Widget get _tabPage {
    return Container();
  }
}
