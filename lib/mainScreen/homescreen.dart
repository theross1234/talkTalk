//import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chatchat/mainScreen/chatScreen/chat_list_Screen.dart';
import 'package:chatchat/mainScreen/groups/create_group_Screen.dart';
import 'package:chatchat/mainScreen/groups/group_screen.dart';
import 'package:chatchat/mainScreen/peopleScreen.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  List<Widget> screens = [
    const ChatListScreen(),
    const GroupScreen(),
    const Peoplescreen(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // user comeback to the app
        // set the user status to online
        context.read<AuthenticationProvider>().setUserOnlineStatus(value: true);
        break;
      case AppLifecycleState.inactive:
        // user not use the app (inactive)
        // set the user status to offline
        context
            .read<AuthenticationProvider>()
            .setUserOnlineStatus(value: false);
        break;
      case AppLifecycleState.paused:
        // user put the App is in the background
        // set the user status to online
        context
            .read<AuthenticationProvider>()
            .setUserOnlineStatus(value: false);
        break;
      case AppLifecycleState.detached:
        // App is in the background
        // set the user status to offline
        context
            .read<AuthenticationProvider>()
            .setUserOnlineStatus(value: false);
        break;
      case AppLifecycleState.hidden:
        // App is in the background
        // set the user status to offline
        context
            .read<AuthenticationProvider>()
            .setUserOnlineStatus(value: false);
        break;
      default:
        // offline dans tous les cas
        // context
        // .read<AuthenticationProvider>()
        // .setUserOnlineStatus(value: false);
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
        appBar: AppBar(
          title: const Text(Constant.appName),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: userImageWidget(
                  onTap: () {
                    //Navigate to profile screen with uid as argument
                    Navigator.pushNamed(
                      context,
                      Constant.profileScreen,
                      arguments: authProvider.userModel!.uid,
                    );
                  },
                  imageUrl: authProvider.userModel!.image,
                  radius: 20,
                )),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: screens,
        ),
        floatingActionButton: currentIndex == 1
            ? FloatingActionButton(
                onPressed: () {
                  // Navigte to create group screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateGroupScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.group_add))
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            // animate to page
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            setState(() {
              currentIndex = index;
            });
            print(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_2_fill),
              label: Constant.chat,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.group),
              label: Constant.groups,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.globe),
              label: Constant.people,
            ),
          ],
        ));
  }
}
