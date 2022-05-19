
import 'package:flutter/material.dart';
import 'package:my_graduation/app_responsive.dart';
import 'package:my_graduation/bloc/home_cubit.dart';
import 'package:my_graduation/widgets/show_dialog.dart';

import '../constants.dart';
import '../models/craft_user_model.dart';
import '../screens/bottom_bar/feed_screen.dart';
import '../screens/bottom_bar/notifications_screen.dart';
import '../screens/chat/chat_details.dart';
import '../screens/post/saved_posts_screen.dart';
import '../screens/settings_screen/settings_screen.dart';

Container customProfile ({context,cubit}) =>  Container(
  margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 50),
  padding: const EdgeInsets.all(12),
  //height: 700,
  decoration: BoxDecoration(
    color: mainColor,
    borderRadius: BorderRadius.circular(40),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'ملفك الشخصي',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 10,),

      // user picture
      Container(
        decoration: BoxDecoration(
          // color: mainColor,
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.white,
              width: 3
          ),
        ),
        child: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(cubit.UserModel!.image!),

        ),
      ),
      const SizedBox(height: 10,),

      // user name
      Text(
        cubit.UserModel!.name!,
        style:const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 10,),

      // user craft
      if(cubit.UserModel!.craftType! !='' )
        Column(
          children: [
            Text(
              cubit.UserModel!.craftType!,
              style:const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4,),
          ],
        ),

      // user address and email

      Text(
        AppResponsive.isMobile(context) ?
        '${cubit.UserModel!.address!}  \n  ${cubit.UserModel!.email!}'
        :
        '${cubit.UserModel!.address!}  _  ${cubit.UserModel!.email!}',
        style:const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20,),


      Container(
        margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 6),
        color: Colors.white,
        width: double.infinity,
        height: 2,
      ),

      ListTile(
        leading:const Icon(Icons.fiber_new_outlined,color: Colors.white,),
        title: InkWell(
          onTap:(){
            Navigator.of(context).push(
                MaterialPageRoute(builder:(_)=> FeedScreen() )
            );
          },
          child:const Text('أحدث الوظائف',style: TextStyle(color: Colors.white,fontSize: 12,),),
        ),
      ),

      ListTile(
          leading:cubit.UserModel!.userType! ?
          const Icon(Icons.bookmark,color: Colors.white,) :
          const Icon(Icons.notifications,color: Colors.white,),
          title: InkWell(
            onTap:(){

              cubit.UserModel!.userType! ?
              Navigator.of(context).push(
                  MaterialPageRoute(builder:(_)=> const SavedPostsScreen())):
              showModalBottomSheet(
                context: context,
                builder: (_) => const FractionallySizedBox(
                  heightFactor: 0.9,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: NotificationsScreen(),
                  ),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    topLeft: Radius.circular(25.0),
                  ),
                ),
                isScrollControlled: true,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                  minWidth: MediaQuery.of(context).size.width * 0.5,
                ),
              );


            },
            child: Text(
              cubit.UserModel!.userType! ? 'المحفوظات':'التنبيهات',
              style:const TextStyle(color: Colors.white,fontSize: 12,),),
          )

      ),


      Container(
        margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 6),
        color: Colors.white,
        width: double.infinity,
        height: 2,
      ),

      ListTile(
        leading:const Icon(Icons.settings,color: Colors.white,),
        title: InkWell(
          onTap:(){
            cubit.getMyWorkImages();
            Navigator.of(context).push(
                MaterialPageRoute(builder:(_)=> SettingsProfileScreen() )
            );

          },
          child:const Text('الاعدادات ',style: TextStyle(color: Colors.white,fontSize: 12,),),
        ),
      ),

    ],
  ),
);


Container customOtherProfile ({
  required BuildContext context,
  required CraftHomeCubit cubit,
  required CraftUserModel userModel,

}) =>  Container(
  margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 50),
  padding: const EdgeInsets.all(12),
  //height: 700,
  decoration: BoxDecoration(
    color: mainColor,
    borderRadius: BorderRadius.circular(40),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'بيانات المستخدم الشخصية',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 10,),

      // user picture
      Container(
        decoration: BoxDecoration(
          // color: mainColor,
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.white,
              width: 3
          ),
        ),
        child: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(userModel.image!),

        ),
      ),
      const SizedBox(height: 10,),

      // user name
      Text(
        userModel.name!,
        style:const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 10,),

      // user craft
      if(userModel.craftType! !='' )
        Column(
          children: [
            Text(
              userModel.craftType!,
              style:const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4,),
          ],
        ),

      // user address and email

      Text(
        AppResponsive.isMobile(context) ?
        '${userModel.address!}  \n  ${userModel.email!}'
            :
        '${userModel.address!}  _  ${userModel.email!}',
        style:const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 15,),

      const Divider(
        color: Colors.white,
      ),
      const SizedBox(height: 15,),

      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
        ),
        child: InkWell(
          onTap:() {
            cubit.getMessage(receiverId: userModel.uId!);
            cubit.getOtherLocation(userId: userModel.uId!);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ChatDetailsScreen(userModel: userModel)));
          },
          // color: Colors.white,
          child:Container(
            width: MediaQuery.of(context).size.width / 7,
            child:const Center(
              child:  Text(
                'مراسلة',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),


    ],
  ),
);
