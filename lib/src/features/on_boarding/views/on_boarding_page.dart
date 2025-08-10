import 'package:bookify/src/features/auth/views/auth_page.dart';
import 'package:bookify/src/features/on_boarding/pages/pages.dart';
import 'package:bookify/src/features/on_boarding/widgets/page_view_indicator.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';

class OnBoardingPage extends StatefulWidget {
  /// The Route Name = '/on_boarding'
  static const routeName = '/on_boarding';

  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late final PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SystemChrome.setSystemUIOverlayStyle(
      Theme.of(context).appBarTheme.systemOverlayStyle!,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrecedentIllustration() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
    _pageController.jumpToPage(_currentPage);
  }

  Future<void> _goToForwardOrFinalizeIllustration() async {
    if (_currentPage < 3) {
      setState(() {
        _currentPage++;
      });
      _pageController.jumpToPage(_currentPage);
    } else {
      await _navigateToConfigurationsPage();
    }
  }

  Future<void> _navigateToConfigurationsPage() async {
    await Navigator.of(context).pushReplacementNamed(AuthPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  child: Text(
                    'skip-button'.i18n(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  onPressed: () async => await _navigateToConfigurationsPage(),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  children: const [
                    Illustration1Page(),
                    Illustration2Page(),
                    Illustration3Page(),
                    Illustration4Page(),
                  ],
                ),
              ),
              PageViewIndicator(
                quantity: 4,
                currentPage: _currentPage,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage != 0) ...[
                    Flexible(
                      child: BookifyOutlinedButton.expanded(
                        onPressed: _goToPrecedentIllustration,
                        color: colorScheme.primary,
                        text: 'back-button'.i18n(),
                        suffixIcon: Icons.arrow_forward_rounded,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                  Flexible(
                    key: const Key('NextButton'),
                    child: BookifyElevatedButton.expanded(
                      onPressed: () async =>
                          await _goToForwardOrFinalizeIllustration(),
                      color: colorScheme.primary,
                      text: _currentPage < 3
                          ? 'next-button'.i18n()
                          : 'finish-button'.i18n(),
                      suffixIcon: Icons.arrow_back_rounded,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
