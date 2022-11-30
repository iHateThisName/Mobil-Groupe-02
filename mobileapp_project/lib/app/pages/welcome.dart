import 'package:flutter/material.dart';
import 'package:mobileapp_project/app/pages/landing_page.dart';
import 'package:mobileapp_project/app/models/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';



class OnWelcome extends StatefulWidget {
  @override
  _OnWelcomeState createState() => _OnWelcomeState();
}

class _OnWelcomeState extends State<OnWelcome> {

  bool isLocationEnabled = false;
  bool isLocationEnabledChecked = false;
  Location _locationTracker = Location();

  Future<void> checkIsLocationEnabled() async {
    isLocationEnabled = await _locationTracker.serviceEnabled();
    setState(() {});
    if (isLocationEnabled) {
      await _locationTracker.getLocation();
    }
    setState(() {
      isLocationEnabledChecked = true;
    });
  }

  List<WelcomePage> screens = <WelcomePage>[
    WelcomePage(
        img: 'images/hvor-kan-jeg-drite-logo.png',
        text: "Hjelp, jeg må på do!",
        button: Colors.blue,
        bg: Colors.blueGrey,
        desc: ""),
    WelcomePage(
      img: 'images/toiletmarker4.png',
      text: "Se etter toalettmarkørene",
      button: Colors.blue,
      bg: Colors.blueGrey,
      desc: "",
    ),
  ];
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
    checkIsLocationEnabled();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeWelcomeInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onWelcome', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    isLocationEnabledChecked;

    return Scaffold(
      backgroundColor: currentIndex % 2 == 0 ? Colors.white : Colors.blue,
      appBar: AppBar(
        backgroundColor: currentIndex % 2 == 0 ? Colors.white : Colors.blue,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () async {
                await _storeWelcomeInfo();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LandingPage()));
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: currentIndex % 2 == 0 ? Colors.black : Colors.white,
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
            itemCount: screens.length,
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(screens[index].img!),
                  Container(
                    height: 10.0,
                    child: ListView.builder(
                        itemCount: screens.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                width: currentIndex == index ? 25.0 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? Colors.brown
                                      : Colors.brown,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  Text(
                    screens[index].text!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                      color: index % 2 == 0 ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    screens[index].desc!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: index % 2 == 0 ? Colors.black : Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await _storeWelcomeInfo();
                      int indx = screens.length;
                      if (index == indx - 1) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LandingPage()));
                      }
                      _pageController.nextPage(
                          duration: Duration(microseconds: 300),
                          curve: Curves.bounceIn);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      decoration: BoxDecoration(
                          color: index % 2 == 0 ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Next",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: index % 2 == 0
                                      ? Colors.white
                                      : Colors.blue)),
                          SizedBox(width: 15.0),
                          Icon(
                            Icons.arrow_forward_sharp,
                            color: index % 2 == 0 ? Colors.white : Colors.blue,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
