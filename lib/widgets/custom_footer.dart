
import 'package:flutter/material.dart';

import '../app_responsive.dart';
import '../constants.dart';

Container customFooter({required context})=> Container(

  padding: const EdgeInsets.only(right: 20.0,top: 100,left: 20,bottom: 20),
  height: 400,
  color: barColor,
  child: Center(
    child:AppResponsive.isMobile(context) ?
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // site name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    //  Up
                    TextSpan(
                      text:'Craft',
                      style: TextStyle(
                        fontSize:
                        AppResponsive.isMobile(context) ?20: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.withOpacity(0.7),
                        fontFamily: 'Pacifico',
                      ),),

                    TextSpan(
                      text:' Up',
                      style: TextStyle(
                        fontSize:
                        AppResponsive.isMobile(context) ?20: 32,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontFamily: 'Pacifico',
                      ),),
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                'موقع  يختص بفئة الحرفيين وأصحاب المشغولات اليدوية\n حيث يتم  الإعلان عن الوظائف الشاغرة  واستقطاب الموظفين\n بصورة سهلة وسريعة',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8)
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const Divider(),

        // contact us

        Padding(
          padding: const EdgeInsets.only(right: 20.0,top: 40,left: 20,bottom: 20),
          child: Column(
            children: [
              const Text(
                'اتصل بنا',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8,),
              Text(
                '+972595242216',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8)
                ),
                textAlign: TextAlign.center,
              ),
              SelectableText(
                'khg270991@gmail.com',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8)
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    ):
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // site name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    //  Up
                    TextSpan(
                      text:'Craft',
                      style: TextStyle(
                        fontSize:
                        AppResponsive.isMobile(context) ?20: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.withOpacity(0.7),
                        fontFamily: 'Pacifico',
                      ),),

                    TextSpan(
                      text:' Up',
                      style: TextStyle(
                        fontSize:
                        AppResponsive.isMobile(context) ?20: 32,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontFamily: 'Pacifico',
                      ),),
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                'موقع  يختص بفئة الحرفيين وأصحاب المشغولات اليدوية\n حيث يتم  الإعلان عن الوظائف الشاغرة  واستقطاب الموظفين\n بصورة سهلة وسريعة',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8)
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const VerticalDivider(),

        // contact us

        Padding(
          padding: const EdgeInsets.only(right: 20.0,top: 40,left: 20,bottom: 20),
          child: Column(
            children: [
              const Text(
                'اتصل بنا',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8,),
              Text(
                '+972595242216',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8)
                ),
                textAlign: TextAlign.center,
              ),
              SelectableText(
                'khg270991@gmail.com',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.8)
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);