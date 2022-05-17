import 'dart:html';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_graduation/constants.dart';
import 'package:my_graduation/screens/auth/register_screen.dart';
import '../models/boarding_model.dart';
import 'auth/login_screen.dart';
import '../helpers/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';




// to get latitude and longitude and store it in firebase

late Position cPosition;
LocationPermission? locationPermission;
checkIfLocationPermissionAllowedd() async {
  locationPermission = await Geolocator.requestPermission();

  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
  }
}
getPositionn()async{

  cPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  print('3kkkkkkkkkkkk');
}




class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/OnBoarding1.jpeg',
      title: 'مرحبا بك في موقع \nCraft Up',
      body: 'Body Screen 1',
    ),
    BoardingModel(
      image: 'assets/images/OnBoarding2.jpg',
      title: 'بإمكانك عقد اتفاقاتك العملية وإيجاد فرصة عمل تناسبك مهما كانت حرفتك',
      body: 'Body Screen 2',
    ),
    BoardingModel(
      image: 'assets/images/OnBoarding3.jpg',
      title: 'بإمكانك استخدام الموقع بكل سهولة ودون تعقيدات',
      body: 'Body Screen 3',
    ),
  ];

  bool isLast = false;

  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
      if(value){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CraftLoginScreen()),
        );
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLocationPermissionAllowedd();
    getPositionn();
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: mainColor,
            elevation: 0,
            title:const Text(
              'Craft Up',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
            actions: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  color: Colors.white,
                  child: InkWell(
                    onTap: (){
                      //Navigator.of(context).push(MaterialPageRoute(builder: (_)=>CraftLoginScreen()),);
                      Navigator.of(context).pushNamed(CraftLoginScreen.route);
                    },
                    child: Text('تسجيل الدخول',style: TextStyle(color: mainColor),),
                  ),
                ),
              ),

              const SizedBox(width: 20,),
              Center(
                child: InkWell(
                  onTap:() {
                   // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>CraftRegisterScreen()),);
                    Navigator.of(context).pushNamed(CraftRegisterScreen.route);
                  },
                  child:const Text('إنشاء حساب جديد',style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(width: 20,),
            ],
          ),
          body: Scrollbar(
            child: ListView(
              children: [

/*
                Container(
                  width: double.infinity,
                  color: mainColor,
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                  child: Row(
                    children: [
                      const Center(
                        child: Text(
                          'Craft Up',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const Spacer(),
                      MaterialButton(
                          onPressed: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_)=>CraftLoginScreen()),
                            );
                          },
                        color: Colors.white,
                          child: Text('تسجيل الدخول'),
                      ),

                      const SizedBox(width: 50,),
                      InkWell(
                        onTap:() {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_)=>CraftRegisterScreen()),
                          );
                        },
                          child:const Text('إنشاء حساب جديد',style: TextStyle(color: Colors.white),),
                      ),

                    ],
                  ),
                ),
*/

                Container(
                  width: double.infinity,
                  height: 500,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          margin: const EdgeInsets.only(top: 100),
                          child: PageView.builder(
                            controller: boardController,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (int index) {
                              if (index == boarding.length - 1) {
                                setState(() {
                                  isLast = true;
                                });
                              } else {
                                setState(() {
                                  isLast = false;
                                });
                              }
                            },
                            itemCount: boarding.length,
                            itemBuilder: (context, index) {
                              return buildBoardingItem(boarding[index]);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SmoothPageIndicator(
                          controller: boardController,
                          effect: ExpandingDotsEffect(
                            dotColor: Colors.grey,
                            activeDotColor: mainColor,
                            dotHeight: 10.0,
                            expansionFactor: 3.0,
                            dotWidth: 10.0,
                            spacing: 5,
                          ),
                          count: boarding.length,
                        ),
                      ),/*
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_)=>CraftLoginScreen()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 60),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 60,
                          child:const Center(
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              //  textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),

                Container(
                  width: size.width,
                    height: 300,
                    decoration:const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Path.png')
                      ),
                    ),
                ),

                const SizedBox(height: 20,),
                Container(
                  alignment: Alignment.center,
                  width: size.width,
                  padding: const EdgeInsets.all(20),
                  color:Colors.white,
                  child: Text(
                    'حول الموقع ',
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),


                Container(
                  width: double.infinity,
                  height: 400,
                  padding: const EdgeInsets.all(20),
                  color: mainColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      const Center(
                        child: Text(
                          'موقع  يختص بفئة الحرفيين وأصحاب المشغولات اليدوية حيث يتم  الإعلان عن الوظائف الشاغرة  واستقطاب الموظفين بصورة سهلة وسريعة',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildBoardingItem(BoardingModel model) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(model.image),
      )
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          model.title,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 28,
              color: mainColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
