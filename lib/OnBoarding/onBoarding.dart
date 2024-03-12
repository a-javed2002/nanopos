import 'package:flutter/material.dart';
import 'package:nanopos/OnBoarding/widgets.dart';
import 'package:nanopos/consts/consts.dart';
import 'package:nanopos/views/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  final settings;
  const OnBoardingScreen({Key? key, this.settings = false}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;
  int page = 0;

  // _setOnboardingStatus({required status}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('onboardingDone', status);
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
                page = index;
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                page == 0
                    ? ElevatedButton(
                        onPressed: () {
                          // _setOnboardingStatus(status: true);
                          // if (widget.settings) {
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => SettingsScreen(),
                          //     ),
                          //   );
                          // } else {
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => LoginPage(),
                          //     ),
                          //   );
                          // }
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Skip",
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,color: Colors.white),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfff3b98a),
                          // primary: Colors.transparent, // Set background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  20.0), // Add top-left border radius
                            ),
                          ),
                          // side: BorderSide(color: mainColor, width: 2.0),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _controller.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Back",
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,color: Colors.white),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.transparent, // Set background color
                          backgroundColor: Color(0xfff3b98a),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  20.0), // Add top-left border radius
                            ),
                          ),
                          // side: BorderSide(color: mainColor, width: 2.0),
                        ),
                      ),
                onLastPage
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Done",
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,color: Colors.white),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF753411),
                          // primary: mainColor, // Set background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  20.0), // Add top-left border radius
                            ),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (_controller.page != null &&
                              _controller.page! < 2) {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,color: Colors.white ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF753411),
                          // primary: mainColor, // Set background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  20.0), // Add top-left border radius
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
