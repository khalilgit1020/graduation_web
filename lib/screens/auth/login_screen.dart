import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/app_responsive.dart';
import 'package:my_graduation/bloc/home_cubit.dart';
import 'package:my_graduation/bloc/login_cubit.dart';
import 'package:my_graduation/constants.dart';
import 'package:my_graduation/main.dart';
import 'package:my_graduation/screens/auth/forgot_password.dart';
import 'package:my_graduation/screens/bottom_bar/home_screen.dart';
import 'package:my_graduation/screens/auth/register_screen.dart';

import '../../bloc/craft_states.dart';
import '../../helpers/cache_helper.dart';
import '../../widgets/show_taost.dart';
import '../bottom_bar/feed_screen.dart';

class CraftLoginScreen extends StatefulWidget {
  static const String route = '/login';

  @override
  State<CraftLoginScreen> createState() => _CraftLoginScreenState();
}

class _CraftLoginScreenState extends State<CraftLoginScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();


  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    //  var cubit = SocialLoginCubit.get(context);

    return BlocProvider(
      create: (context) => CraftLoginCubit(),
      child: BlocConsumer<CraftLoginCubit, CraftStates>(
        listener: (context, state) {
          if (state is CraftLoginSuccessState) {
            print('تم التسجيل بنجاح');
            CacheHelper.saveData(
              key: 'uId',
              value: state.uid,
            ).then((value) {
              uId = state.uid;
              CraftHomeCubit().getUserData();
             // CraftHomeCubit().getNotifications();
             // CraftHomeCubit().getUsersChatList();
              //Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyApp(widget: const HomeScreen())));
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MyApp(widget: HomeScreen())));

            }).catchError((error) {
              print(error.toString());
            });
          }

          if (state is CraftLoginErrorState) {
            if (state.error ==
                '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
              showToast(
                state: ToastState.ERROR,
                msg:
                    'يوجد خطا في البريد الإلكتروني او كلمة المرور, الرجاء التأكد منهم',
              );
            } else if (state.error ==
                '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
              showToast(
                state: ToastState.ERROR,
                msg: 'لا يوجد حساب لهذا البريد الألكتروني, قد يكون تم حذفه',
              );
            } else {
              showToast(
                state: ToastState.ERROR,
                msg: 'يوجد خطأ, الرجاء تسجيل حساب جديد مرة أخرى',
              );
            }
            print(state.error);
          }
        },
        builder: (context, state) {
          var cubit = CraftLoginCubit.get(context);
          print(size.width);


          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
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

                                    Center(
                                      child: Container(
                                        width: size.width / 2.5,
                                        height: size.height / 1.5,
                                        decoration:const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: AssetImage('assets/images/team.jpg'),
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
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'مرحبا ! مرحبا بعودتك ',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: 18
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'سجل دخول بياناتك التي قمت بادخالها اثناء تسيجلك',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: 18
                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        const SizedBox(
                                          height: 30,
                                        ),

                                        // for email field

                                        Container(

                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                spreadRadius: 0.1,
                                                blurRadius: 4,
                                                offset: Offset(
                                                    0, 2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            //autofillHints: true,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال الإيميل الخاص بك';
                                              } else if (!value.contains('@')) {
                                                return 'الرجاء إدخال الإيميل بالصيغة الرسمية';
                                              }else{
                                                return null;
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'البريد الالكتروني',
                                              hintStyle: TextStyle(
                                                color: mainColor,
                                              ),
                                              border: InputBorder.none,
                                              //  label: Text('البريد الالكتروني'),
                                              //  prefixIcon: Icon(Icons.email_outlined),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),

                                        // for password field
                                        /*Text(
                                      'كلمة السر',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),*/
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                spreadRadius: 0.1,
                                                blurRadius: 4,
                                                offset: Offset(
                                                    0, 2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            obscureText: cubit.isPasswordShown,
                                            controller: passwordController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال كلمة السر الخاصة بك';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'كلمة السر',
                                              hintStyle: TextStyle(
                                                color: mainColor,
                                              ),
                                              border: InputBorder.none,
                                              //label:const Text('كلمة السر'),
                                              // prefixIcon:const Icon(Icons.lock_outline),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  cubit.changePasswordVisibility();
                                                },
                                                icon: Icon(
                                                  cubit.suffixIcon,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (_) => ForgotPassword()));
                                          },
                                          child: Text(
                                            'هل نسيت كلمة السر ؟',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                              color: mainColor,
                                            ),
                                          ),
                                        ),

                                        // for login button
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Center(
                                          child: Container(
                                            width: 200,

                                            decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            height: 60,
                                            child: state is CraftLoginLoadingState
                                                ? const Center(
                                                child:
                                                CircularProgressIndicator.adaptive())
                                                : TextButton(
                                              onPressed: () {
                                                if (formKey.currentState!.validate()) {
                                                  cubit.userLogin(
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'تسجيل الدخول',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),

                                        // go to sign up page
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'ليس لديك حساب ؟',
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            CraftRegisterScreen()));
                                              },
                                              child: Text(
                                                'تسجيل مستخدم جديد',
                                                style: TextStyle(color: mainColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                                flex:2,
                                child: Column(
                                  children: [
                                    Padding(
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

                                    Center(
                                      child: Container(
                                        width: size.width / 2.5,
                                        height: size.height / 1.5,
                                        decoration:const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: AssetImage('assets/images/team.jpg'),
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex:1,
                                child: Container(
                                  color: mainColor,
                                  height: size.height,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
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
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'مرحبا ! مرحبا بعودتك ',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: 18
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'سجل دخول بياناتك التي قمت بادخالها اثناء تسيجلك',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: 18
                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [/*
                                    Center(
                                      child: Text(
                                        'تسجيل الدخول',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                          color: mainColor,
                                        ),
                                      ),
                                    ),*/
                                        const SizedBox(
                                          height: 30,
                                        ),

                                        // for email field
                                        /*Text(
                                      'البريد الالكتروني',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),*/
                                        Container(

                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                spreadRadius: 0.1,
                                                blurRadius: 4,
                                                offset: Offset(
                                                    0, 2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال الإيميل الخاص بك';
                                              } else if (!value.contains('@')) {
                                                return 'الرجاء إدخال الإيميل بالصيغة الرسمية';
                                              }else{
                                                return null;
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'البريد الالكتروني',
                                              hintStyle: TextStyle(
                                                color: mainColor,
                                              ),
                                              border: InputBorder.none,
                                              //  label: Text('البريد الالكتروني'),
                                              //  prefixIcon: Icon(Icons.email_outlined),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),

                                        // for password field
                                        /*Text(
                                      'كلمة السر',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),*/
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                spreadRadius: 0.1,
                                                blurRadius: 4,
                                                offset: Offset(
                                                    0, 2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            obscureText: cubit.isPasswordShown,
                                            controller: passwordController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال كلمة السر الخاصة بك';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'كلمة السر',
                                              hintStyle: TextStyle(
                                                color: mainColor,
                                              ),
                                              border: InputBorder.none,
                                              //label:const Text('كلمة السر'),
                                              // prefixIcon:const Icon(Icons.lock_outline),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  cubit.changePasswordVisibility();
                                                },
                                                icon: Icon(
                                                  cubit.suffixIcon,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (_) => ForgotPassword()));
                                          },
                                          child: Text(
                                            'هل نسيت كلمة السر ؟',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                              color: mainColor,
                                            ),
                                          ),
                                        ),

                                        // for login button
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Center(
                                          child: Container(
                                            width: 200,

                                            decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            height: 60,
                                            child: state is CraftLoginLoadingState
                                                ? const Center(
                                                child:
                                                CircularProgressIndicator.adaptive())
                                                : TextButton(
                                              onPressed: () {
                                                if (formKey.currentState!.validate()) {
                                                  cubit.userLogin(
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'تسجيل الدخول',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),

                                        // go to sign up page
                                        Center(
                                          child: Column(
                                            children: [
                                              const Text(
                                                'ليس لديك حساب ؟',
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              CraftRegisterScreen()));
                                                },
                                                child: Text(
                                                  'تسجيل مستخدم جديد',
                                                  style: TextStyle(color: mainColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'مرحبا ! مرحبا بعودتك ',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: 18
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'سجل دخول بياناتك التي قمت بادخالها اثناء تسيجلك',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: 18
                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        const SizedBox(
                                          height: 30,
                                        ),

                                        // for email field

                                        Container(

                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                spreadRadius: 0.1,
                                                blurRadius: 4,
                                                offset: Offset(
                                                    0, 2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال الإيميل الخاص بك';
                                              } else if (!value.contains('@')) {
                                                return 'الرجاء إدخال الإيميل بالصيغة الرسمية';
                                              }else{
                                                return null;
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'البريد الالكتروني',
                                              hintStyle: TextStyle(
                                                color: mainColor,
                                              ),
                                              border: InputBorder.none,
                                              //  label: Text('البريد الالكتروني'),
                                              //  prefixIcon: Icon(Icons.email_outlined),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),

                                        // for password field

                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                spreadRadius: 0.1,
                                                blurRadius: 4,
                                                offset: Offset(
                                                    0, 2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            obscureText: cubit.isPasswordShown,
                                            controller: passwordController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال كلمة السر الخاصة بك';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'كلمة السر',
                                              hintStyle: TextStyle(
                                                color: mainColor,
                                              ),
                                              border: InputBorder.none,
                                              //label:const Text('كلمة السر'),
                                              // prefixIcon:const Icon(Icons.lock_outline),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  cubit.changePasswordVisibility();
                                                },
                                                icon: Icon(
                                                  cubit.suffixIcon,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (_) => ForgotPassword()));
                                          },
                                          child: Text(
                                            'هل نسيت كلمة السر ؟',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                              color: mainColor,
                                            ),
                                          ),
                                        ),

                                        // for login button
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Center(
                                          child: Container(
                                            width: 200,

                                            decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            height: 60,
                                            child: state is CraftLoginLoadingState
                                                ? const Center(
                                                child:
                                                CircularProgressIndicator.adaptive())
                                                : TextButton(
                                              onPressed: () {
                                                if (formKey.currentState!.validate()) {
                                                  cubit.userLogin(
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'تسجيل الدخول',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),

                                        // go to sign up page
                                        Center(
                                          child: Column(
                                            children: [
                                              const Text(
                                                'ليس لديك حساب ؟',
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              CraftRegisterScreen()));
                                                },
                                                child: Text(
                                                  'تسجيل مستخدم جديد',
                                                  style: TextStyle(color: mainColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
