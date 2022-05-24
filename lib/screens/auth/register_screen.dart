import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/constants.dart';
import 'package:my_graduation/screens/auth/login_screen.dart';
import 'package:my_graduation/widgets/show_taost.dart';

import '../../app_responsive.dart';
import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../bloc/register_cubit.dart';
import '../../helpers/cache_helper.dart';
import '../bottom_bar/feed_screen.dart';
import '../bottom_bar/home_screen.dart';


class CraftRegisterScreen extends StatelessWidget {

  static const String route = '/register';

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  var craftTypeController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var ConfirmPasswordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => CraftRegisterCubit(),
      child: BlocConsumer<CraftRegisterCubit, CraftStates>(
        listener: (context, state) {


          if(state is CraftRegisterSuccessState){
            CacheHelper.saveData(
              key: 'uId',
              value: state.uid,
            ).then((value){
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const HomeScreen()));
             // Navigator.of(context).pushNamed(HomeScreen.route);
            }).catchError((error){
              print(error.toString());
            });
          }



          if (state is CraftCreateUserSuccessState ) {

            showToast(
              state: ToastState.SUCCESS,
              msg: 'تم تسجيل الحساب بنجاح',
            );

            CraftHomeCubit().getUserData();
            Navigator.of(context).pushReplacement(

                MaterialPageRoute(builder: (_) =>const HomeScreen()));
          }


            if (state is CraftRegisterErrorState ){
                if(state.error == '[firebase_auth/email-already-in-use] The email address is already in use by another account.' ) {
                  showToast(
                    state: ToastState.ERROR,
                    msg: 'البريد الإالكتروني الذي أدخلته موجود مسبقا,الرجاء كتابة البريد الإالكتروني اخر',
                  );
                }else{
                  showToast(
                    state: ToastState.ERROR,
                    msg: 'يوجد خطأ, الرجاء تسجيل حساب جديد مرة أخرى',
                  );
                }
              print(state.error);
            }

        },
        builder: (context, state) {

          print(size.width);

          var cubit = CraftRegisterCubit.get(context);

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
                                      padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 20),
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
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: size.width / 3,
                                        height: size.height / 2.5,
                                        decoration:const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: AssetImage('assets/images/Sign_in.png'),
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
                                  Column(
                                    children: [

                                      /*
                                Center(
                                  child: Text(
                                    'التسجيل',
                                    style: TextStyle(
                                        color: mainColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),*/

                                      // for select type of user
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              cubit.makeIsCrafterTrue();
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  'حرفيا',
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                if (cubit.isCrafter)
                                                  Container(
                                                    color: mainColor.withOpacity(0.5),
                                                    height: 4,
                                                    width: 80,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              cubit.makeIsCrafterFalse();
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  'مستخدم',
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                if (!cubit.isCrafter)
                                                  Container(
                                                    color: mainColor.withOpacity(0.10),
                                                    height: 4,
                                                    width: 80,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // for enter name
                                        /*Text(
                                    'الاسم',
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
                                            controller: nameController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال اسمك';
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'الاسم',
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
                                          height: 10,
                                        ),

                                        // for enter email
                                        /* Text(
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
                                          height: 10,
                                        ),

                                        // for enter password
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
                                            obscureText: cubit.isPassword,
                                            controller: passwordController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال كلمة السر الخاصة بك';
                                              }else if(value.length < 6 ){
                                                return 'كلمة السر قصيرة,يحب ان تكون على الأقل 6 حروف او أرقام';
                                              }
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
                                                  cubit.suffix,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        // for confirm password
                                        /*Text(
                                    'تاكيد كلمة السر',
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
                                            obscureText: cubit.isPassword,
                                            controller: ConfirmPasswordController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال تأكيد كلمة السر الخاصة بك';
                                              } else if (value !=
                                                  passwordController.text) {
                                                return 'كلمة السر غير متطابقة';
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'تاكيد كلمة السر',
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
                                                  cubit.suffix,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        // for enter address
                                        /* Text(
                                    'العنوان',
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
                                            controller: addressController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال عنوانك';
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'العنوان',
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
                                          height: 10,
                                        ),

                                        // for enter phone number
                                        /*Text(
                                    'رقم الجوال',
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
                                            controller: phoneController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال رقم هاتفك';
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'رقم الجوال',
                                              hintStyle: TextStyle(
                                                color: mainColor,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: cubit.isCrafter ? 10 : 30,
                                        ),

                                        if (cubit.isCrafter)
                                        // for enter craft type
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              /*
                                        Text(
                                          'نوع الحرفة',
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
                                                      offset: Offset(0,
                                                          2), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: TextFormField(
                                                  controller: craftTypeController,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'الرجاء إدخال حرفتك الخاصة';
                                                    }
                                                  },
                                                  decoration:  InputDecoration(
                                                    hintText: 'نوع الحرفة',
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
                                                height: 20,
                                              ),
                                            ],
                                          ),

                                        // for register button
                                        Center(
                                          child: Container(
                                            width: 200 ,
                                            decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            height: 60,
                                            child: state is CraftRegisterLoadingState
                                                ? const Center(
                                              child: CircularProgressIndicator
                                                  .adaptive(),
                                            )
                                                : TextButton(
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  cubit.userRegister(
                                                    name: nameController.text,
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                    phone: phoneController.text,
                                                    address: addressController.text,
                                                    craftType:
                                                    craftTypeController.text,
                                                    userType: cubit.isCrafter,
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'تسجيل حساب جديد',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),

                                        // for go to login page
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'لديك حساب ؟ ',
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            CraftLoginScreen()));
                                              },
                                              child: Text(
                                                'تسجيل الدخول',
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
                                flex:3,
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
                                              image: AssetImage('assets/images/Sign_in.png'),
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                    ),



                                  ],
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
                              width: size.width / 2.6,
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
                                  Column(
                                    children: [


                                      // for select type of user
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              cubit.makeIsCrafterTrue();
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  'حرفيا',
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                if (cubit.isCrafter)
                                                  Container(
                                                    color: mainColor.withOpacity(0.5),
                                                    height: 4,
                                                    width: 80,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              cubit.makeIsCrafterFalse();
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  'مستخدم',
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                if (!cubit.isCrafter)
                                                  Container(
                                                    color: mainColor.withOpacity(0.10),
                                                    height: 4,
                                                    width: 80,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // for enter name

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
                                            controller: nameController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال اسمك';
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'الاسم',
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
                                          height: 10,
                                        ),

                                        // for enter email

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
                                          height: 10,
                                        ),

                                        // for enter password

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
                                            obscureText: cubit.isPassword,
                                            controller: passwordController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال كلمة السر الخاصة بك';
                                              }else if(value.length < 6 ){
                                                return 'كلمة السر قصيرة,يحب ان تكون على الأقل 6 حروف او أرقام';
                                              }
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
                                                  cubit.suffix,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        // for confirm password

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
                                            obscureText: cubit.isPassword,
                                            controller: ConfirmPasswordController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال تأكيد كلمة السر الخاصة بك';
                                              } else if (value !=
                                                  passwordController.text) {
                                                return 'كلمة السر غير متطابقة';
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'تاكيد كلمة السر',
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
                                                  cubit.suffix,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        // for enter address

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
                                            controller: addressController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال عنوانك';
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'العنوان',
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
                                          height: 10,
                                        ),

                                        // for enter phone number

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
                                            controller: phoneController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال رقم هاتفك';
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'رقم الجوال',
                                              hintStyle: TextStyle(
                                                color: mainColor,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: cubit.isCrafter ? 10 : 30,
                                        ),

                                        if (cubit.isCrafter)
                                        // for enter craft type
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

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
                                                      offset: Offset(0,
                                                          2), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: TextFormField(
                                                  controller: craftTypeController,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'الرجاء إدخال حرفتك الخاصة';
                                                    }
                                                  },
                                                  decoration:  InputDecoration(
                                                    hintText: 'نوع الحرفة',
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
                                                height: 20,
                                              ),
                                            ],
                                          ),

                                        // for register button
                                        Center(
                                          child: Container(
                                            width: 200 ,
                                            decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            height: 60,
                                            child: state is CraftRegisterLoadingState
                                                ? const Center(
                                              child: CircularProgressIndicator
                                                  .adaptive(),
                                            )
                                                : TextButton(
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  cubit.userRegister(
                                                    name: nameController.text,
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                    phone: phoneController.text,
                                                    address: addressController.text,
                                                    craftType:
                                                    craftTypeController.text,
                                                    userType: cubit.isCrafter,
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'تسجيل حساب جديد',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),

                                        // for go to login page
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'لديك حساب ؟ ',
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            CraftLoginScreen()));
                                              },
                                              child: Text(
                                                'تسجيل الدخول',
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
                      )
                          :

                      // for mobile size
                      Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex:2,
                                child: Stack(
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
/*
                                Center(
                                  child: Container(
                                    width: size.width / 2.5,
                                    height: size.height / 1.5,
                                    decoration:const BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: AssetImage('assets/images/Sign_in.png'),
                                          fit: BoxFit.cover
                                      ),
                                    ),
                                  ),
                                ),*/
                                  ],
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
                                  Column(
                                    children: [

                                      /*
                                Center(
                                  child: Text(
                                    'التسجيل',
                                    style: TextStyle(
                                        color: mainColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),*/

                                      // for select type of user
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              cubit.makeIsCrafterTrue();
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  'حرفيا',
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                if (cubit.isCrafter)
                                                  Container(
                                                    color: mainColor.withOpacity(0.5),
                                                    height: 4,
                                                    width: 80,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              cubit.makeIsCrafterFalse();
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  'مستخدم',
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                if (!cubit.isCrafter)
                                                  Container(
                                                    color: mainColor.withOpacity(0.10),
                                                    height: 4,
                                                    width: 80,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // for enter name
                                        /*Text(
                                    'الاسم',
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
                                            controller: nameController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال اسمك';
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'الاسم',
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
                                          height: 10,
                                        ),

                                        // for enter email
                                        /* Text(
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
                                          height: 10,
                                        ),

                                        // for enter password
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
                                            obscureText: cubit.isPassword,
                                            controller: passwordController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال كلمة السر الخاصة بك';
                                              }else if(value.length < 6 ){
                                                return 'كلمة السر قصيرة,يحب ان تكون على الأقل 6 حروف او أرقام';
                                              }
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
                                                  cubit.suffix,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        // for confirm password
                                        /*Text(
                                    'تاكيد كلمة السر',
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
                                            obscureText: cubit.isPassword,
                                            controller: ConfirmPasswordController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال تأكيد كلمة السر الخاصة بك';
                                              } else if (value !=
                                                  passwordController.text) {
                                                return 'كلمة السر غير متطابقة';
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'تاكيد كلمة السر',
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
                                                  cubit.suffix,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),


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
                                            controller: addressController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال عنوانك';
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'العنوان',
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
                                          height: 10,
                                        ),

                                        // for enter phone number
                                        /*Text(
                                    'رقم الجوال',
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
                                            controller: phoneController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء إدخال رقم هاتفك';
                                              }
                                            },
                                            decoration:  InputDecoration(
                                              hintText: 'رقم الجوال',
                                              hintStyle: TextStyle(
                                                color: mainColor,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: cubit.isCrafter ? 10 : 30,
                                        ),

                                        if (cubit.isCrafter)
                                        // for enter craft type
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              /*
                                        Text(
                                          'نوع الحرفة',
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
                                                      offset: Offset(0,
                                                          2), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: TextFormField(
                                                  controller: craftTypeController,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'الرجاء إدخال حرفتك الخاصة';
                                                    }
                                                  },
                                                  decoration:  InputDecoration(
                                                    hintText: 'نوع الحرفة',
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
                                                height: 20,
                                              ),
                                            ],
                                          ),

                                        // for register button
                                        Center(
                                          child: Container(
                                            width: 200 ,
                                            decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            height: 60,
                                            child: state is CraftRegisterLoadingState
                                                ? const Center(
                                              child: CircularProgressIndicator
                                                  .adaptive(),
                                            )
                                                : TextButton(
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  cubit.userRegister(
                                                    name: nameController.text,
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                    phone: phoneController.text,
                                                    address: addressController.text,
                                                    craftType:
                                                    craftTypeController.text,
                                                    userType: cubit.isCrafter,
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'تسجيل حساب جديد',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),

                                        // for go to login page
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'لديك حساب ؟ ',
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            CraftLoginScreen()));
                                              },
                                              child: Text(
                                                'تسجيل الدخول',
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
                      )


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
