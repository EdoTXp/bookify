import 'package:bookify/src/features/auth/views/auth_page.dart';
import 'package:bookify/src/features/on_boarding/pages/pages.dart';
import 'package:bookify/src/features/on_boarding/widgets/page_view_indicator.dart';
import 'package:bookify/src/shared/services/app_services/lock_screen_orientation_service/lock_screen_orientation_service.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

     LockScreenOrientationService.lockOrientationScreen(
      orientation: Orientation.portrait,
    );

    _pageController = PageController();
    _currentPage = 0;
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
    super.dispose();
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
                    'Pular',
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
                    Ilustration1Page(),
                    Ilustration2Page(),
                    Ilustration3Page(),
                    Ilustration4Page(),
                  ],
                ),
              ),
              PageViewIndicator(
                quantity: 4,
                currentPage: _currentPage,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage != 0) ...[
                    Flexible(
                      child: BookifyOutlinedButton.expanded(
                        onPressed: () {
                          if (_currentPage > 0) {
                            setState(() {
                              _currentPage--;
                            });
                          }
                          _pageController.jumpToPage(_currentPage);
                        },
                        color: colorScheme.primary,
                        text: 'Voltar',
                        suffixIcon: Icons.arrow_forward_rounded,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                  Flexible(
                    child: BookifyElevatedButton.expanded(
                      onPressed: () async {
                        if (_currentPage < 3) {
                          setState(() {
                            _currentPage++;
                          });
                          _pageController.jumpToPage(_currentPage);
                        } else {
                          await _navigateToConfigurationsPage();
                        }
                      },
                      color: colorScheme.primary,
                      text: _currentPage < 3 ? 'Avançar' : 'Finalizar',
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
