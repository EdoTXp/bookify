import 'package:bookify/src/features/qr_code_scanner/views/qr_code_scanner_page.dart';
import 'package:bookify/src/features/root/views/pages/pages.dart';
import 'package:bookify/src/shared/blocs/book_bloc/book_bloc.dart';
import 'package:bookify/src/shared/constants/icons/bookify_icons.dart';
import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_bottom_bar.dart';
import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_bottom_bar_controller.dart';
import 'package:bookify/src/shared/widgets/floating_action_button/rectangle_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class RootPage extends StatefulWidget {
  /// Route Name = '/root_page'
  static const routeName = '/root_page';

  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _canExtendBody = true;

  late final BookBloc _bookBloc;
  late final FabBottomBarController _bottomBarController;

  int _currentPage = 0;

  final List<Widget> _pages = const [
    HomePage(),
    BookcaseTabViewPage(),
    ReadingsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _bookBloc = context.read<BookBloc>();
    _bottomBarController = FabBottomBarController();
  }

  @override
  void dispose() {
    _bottomBarController.dispose();
    super.dispose();
  }

  void _changePage(int page) {
    if (_currentPage == page) return;

    setState(() {
      _currentPage = page;
      _canExtendBody = (page == 0);
    });
  }

  void _returnToInitialPage() {
    _changePage(0);
    _bottomBarController.changeSelectedBottomBarItem(0);
  }

  Future<void> _navigateBackOrClose() async {
    if (_currentPage != 0) {
      _returnToInitialPage();
      return;
    }

    SystemNavigator.pop();
  }

  Future<void> _scanAndGetIsbnCode(BuildContext context) async {
    final isbn =
        await Navigator.pushNamed(
              context,
              QrCodeScannerPage.routeName,
            )
            as String?;

    if (isbn != null) {
      _bookBloc.add(FoundBooksByIsbnEvent(isbn: isbn));
      _returnToInitialPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) async {
        await _navigateBackOrClose();
      },
      child: Scaffold(
        extendBody: _canExtendBody,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOutCubicEmphasized,
          switchOutCurve: Curves.easeInOutCubicEmphasized,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(_currentPage),
            child: _pages[_currentPage],
          ),
        ),
        bottomNavigationBar: FABBottomAppBar(
          controller: _bottomBarController,
          onSelectedItem: _changePage,
          items: [
            FABBottomAppBarItem(
              unselectedIcon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label: 'home-label'.i18n(),
            ),
            FABBottomAppBarItem(
              unselectedIcon: BookifyIcons.bookcase_outlined,
              selectedIcon: BookifyIcons.bookcase,
              label: 'bookcases-label'.i18n(),
            ),
            FABBottomAppBarItem(
              unselectedIcon: Icons.auto_stories_outlined,
              selectedIcon: Icons.auto_stories_rounded,
              label: 'readings-label'.i18n(),
            ),
            FABBottomAppBarItem(
              unselectedIcon: Icons.person_outline,
              selectedIcon: Icons.person_rounded,
              label: 'profile-label'.i18n(),
            ),
          ],
        ),
        floatingActionButtonLocation: floatingItemAlignedCenterDockerPosition,
        floatingActionButton: RectangleFloatingActionButton(
          tooltip: 'FAB-tooltip'.i18n(),
          onPressed: () async => await _scanAndGetIsbnCode(context),
          child: const Icon(
            Icons.add_rounded,
            size: 40,
          ),
        ),
      ),
    );
  }
}
