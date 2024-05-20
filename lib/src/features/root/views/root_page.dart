import 'package:bookify/src/shared/constants/icons/bookify_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookify/src/features/qr_code_scanner/views/qr_code_scanner_page.dart';
import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_bottom_bar.dart';
import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_bottom_bar_controller.dart';
import 'package:bookify/src/shared/blocs/book_bloc/book_bloc.dart';
import 'package:bookify/src/shared/widgets/floating_action_button/rectangle_floating_action_button.dart';
import 'package:bookify/src/features/root/views/pages/pages.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  /// The Route Name = '/root_page'
  static const routeName = '/root_page';

  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  /// disable extendBody only bookcaseTabView
  bool _canExtendBody = true;

  // Can Pop the application when pageView is initialPage = HomePage.
  bool _canPop = true;

  late final BookBloc _bookBloc;
  late final PageController _pageController;
  late final FabBottomBarController _bottomBarController;

  @override
  void initState() {
    super.initState();
    _bookBloc = context.read<BookBloc>();
    _pageController = PageController();
    _bottomBarController = FabBottomBarController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set the status bar with the app theme configuration
    // without having to instantiate the Appbar widget.
    SystemChrome.setSystemUIOverlayStyle(
      Theme.of(context).appBarTheme.systemOverlayStyle!,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bottomBarController.dispose();
    super.dispose();
  }

  void _toggleExtendBody(int page) {
    setState(() {
      _canExtendBody = (page == 0) ? true : false;
    });
  }

  void _returnToInitialPage() {
    int homePage = _pageController.initialPage;

    _pageController.jumpToPage(homePage);
    _bottomBarController.changeSelectedBottomBarItem(homePage);
  }

  void _navigateBackOrClose() {
    setState(() {
      if (_pageController.page != _pageController.initialPage) {
        _canPop = false;
        _returnToInitialPage();
      } else {
        _canPop = true;
      }
    });
  }

  Future<void> _scanAndGetIsbnCode(BuildContext context) async {
    final isbn = await Navigator.pushNamed(
      context,
      QrCodeScannerPage.routeName,
    ) as String?;

    if (isbn != null) {
      _bookBloc.add(FoundBooksByIsbnEvent(isbn: isbn));
      _returnToInitialPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvoked: (_) => _navigateBackOrClose(),
      child: Scaffold(
        extendBody: _canExtendBody,
        body: PageView(
          controller: _pageController,
          onPageChanged: _toggleExtendBody,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomePage(),
            BookcaseTabViewPage(),
            ReadingsPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: FABBottomAppBar(
          onSelectedItem: _pageController.jumpToPage,
          controller: _bottomBarController,
          items: [
            FABBottomAppBarItem(
              unselectedIcon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label: 'Início',
            ),
            FABBottomAppBarItem(
              unselectedIcon: BookifyIcons.bookcase_outlined,
              selectedIcon: BookifyIcons.bookcase,
              label: 'Estantes',
            ),
            FABBottomAppBarItem(
              unselectedIcon: Icons.auto_stories_outlined,
              selectedIcon: Icons.auto_stories_rounded,
              label: 'Leituras',
            ),
            FABBottomAppBarItem(
              unselectedIcon: Icons.person_outline,
              selectedIcon: Icons.person_rounded,
              label: 'Perfil',
            ),
          ],
        ),
        floatingActionButtonLocation: floatingItemAlignedCenterDockerPosition,
        floatingActionButton: RectangleFloatingActionButton(
          tooltip: 'Abrir a página para escanear o código ISBN.',
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
