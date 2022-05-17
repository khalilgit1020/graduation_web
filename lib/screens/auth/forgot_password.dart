import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_graduation/bloc/reset_passord_cubit.dart';
import 'package:my_graduation/constants.dart';

import '../../app_responsive.dart';
import '../../bloc/craft_states.dart';
import '../../widgets/show_taost.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => CraftResetPasswordCubit(),
      child: BlocConsumer<CraftResetPasswordCubit, CraftStates>(
        listener: (context, state) {

          if (state is CraftResetPasswordSuccessState ){

            showToast(
              state: ToastState.SUCCESS,
              msg: 'تم إرسال رسالة الى بريدك الإلكتروني, يرجى تفقدها',
            );

          }

          if (state is CraftResetPasswordErrorState ){

            showToast(
              state: ToastState.ERROR,
              msg: 'لا يوجد حساب لهذا البريد الإلكتروني',
            );
            print(state.error);

          }


        },
        builder: (context, state) {
          var cubit = CraftResetPasswordCubit.get(context);

          print(size.width);

          return SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: Colors.white,
                body:Scrollbar(
                  child: ListView(
                    children: [
                      AppResponsive.isDesktop(context) ?
                      Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex:6,
                                child: Column(
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.all(50.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'Craft Up',
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: mainColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Center(
                                      child: Container(
                                        width: size.width / 2.5,
                                        height: size.height / 1.5,
                                        decoration:const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: AssetImage('assets/images/forgot_password.jpg'),
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex:4,
                                child: Container(
                                  color: mainColor,
                                  height: size.height,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: size.width / 2.7,
                              height: 600,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: mainColor,
                                    width: 1.5,
                                  )
                              ),
                              padding: const EdgeInsets.only(left: 40,right: 40,top: 20),
                              margin: const EdgeInsets.only(left: 70.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // icon to get back
                                  Text(
                                    'نسيت كلمة السر',
                                    style: TextStyle(
                                        color: mainColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),

                                  // the email icon
                                  Center(
                                    child: Image.asset(
                                      'assets/images/re_email.png',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  const Center(
                                    child: Text(
                                      'انتظر الرسالة على البريد الالكتروني',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Text(
                                    'أدخل بريدك الالكتروني',
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: mainColor,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                      /*boxShadow:const [
                              BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0.1,
                              blurRadius: 4,
                              offset: Offset(0, 2), // changes position of shadow
                              ),
                              ],*/
                                    ),
                                    child: TextFormField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'الرجاء إدخال الإيميل الخاص بك';
                                        } else if (!value.contains('@')) {
                                          return 'الرجاء إدخال الإيميل بالصيغة الرسمية';
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        //  label: Text('البريد الالكتروني'),
                                        //  prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Center(
                                    child: Container(
                                      width: 200 ,
                                      height:40,
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          cubit.resetPassword(email: emailController.text);
                                        },
                                        child: const Text(
                                          'تأكيد',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ) :

                      AppResponsive.isTablet(context) ?
                      Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex:6,
                                child: Stack(
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.all(50.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'Craft Up',
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: mainColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Center(
                                      child: Container(
                                        width: size.width / 2.5,
                                        height: size.height / 1.5,
                                        decoration:const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: AssetImage('assets/images/forgot_password.jpg'),
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex:4,
                                child: Container(
                                  color: mainColor,
                                  height: size.height,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: size.width / 2.7,
                              height: 600,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: mainColor,
                                    width: 1.5,
                                  )
                              ),
                              padding: const EdgeInsets.only(left: 40,right: 40,top: 20),
                              margin: const EdgeInsets.only(left: 70.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // icon to get back
                                  Text(
                                    'نسيت كلمة السر',
                                    style: TextStyle(
                                        color: mainColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),

                                  // the email icon
                                  Center(
                                    child: Image.asset(
                                      'assets/images/re_email.png',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  const Center(
                                    child: Text(
                                      'انتظر الرسالة على البريد الالكتروني',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Text(
                                    'أدخل بريدك الالكتروني',
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: mainColor,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                      /*boxShadow:const [
                              BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0.1,
                              blurRadius: 4,
                              offset: Offset(0, 2), // changes position of shadow
                              ),
                              ],*/
                                    ),
                                    child: TextFormField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'الرجاء إدخال الإيميل الخاص بك';
                                        } else if (!value.contains('@')) {
                                          return 'الرجاء إدخال الإيميل بالصيغة الرسمية';
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        //  label: Text('البريد الالكتروني'),
                                        //  prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Center(
                                    child: Container(
                                      width: 200 ,
                                      height:40,
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          cubit.resetPassword(email: emailController.text);
                                        },
                                        child: const Text(
                                          'تأكيد',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                          :

                      // for mobile size
                      Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex:2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'Craft Up',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: mainColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex:2,
                                child: Container(
                                  color: mainColor,
                                  height: size.height,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: size.width / 1.6,
                              height: 600,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: mainColor,
                                    width: 1.5,
                                  )
                              ),
                              padding: const EdgeInsets.only(left: 40,right: 40,top: 20),
                              margin: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // icon to get back
                                  Text(
                                    'نسيت كلمة السر',
                                    style: TextStyle(
                                        color: mainColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),

                                  // the email icon
                                  Center(
                                    child: Image.asset(
                                      'assets/images/re_email.png',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  const Center(
                                    child: Text(
                                      'انتظر الرسالة على البريد الالكتروني',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Text(
                                    'أدخل بريدك الالكتروني',
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: mainColor,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                      /*boxShadow:const [
                              BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0.1,
                              blurRadius: 4,
                              offset: Offset(0, 2), // changes position of shadow
                              ),
                              ],*/
                                    ),
                                    child: TextFormField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'الرجاء إدخال الإيميل الخاص بك';
                                        } else if (!value.contains('@')) {
                                          return 'الرجاء إدخال الإيميل بالصيغة الرسمية';
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        //  label: Text('البريد الالكتروني'),
                                        //  prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Center(
                                    child: Container(
                                      width: 200 ,
                                      height:40,
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          cubit.resetPassword(email: emailController.text);
                                        },
                                        child: const Text(
                                          'تأكيد',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                      ,

                    ],
                  ),
                )


              ),
            ),
          );
        },
      ),
    );
  }
}
