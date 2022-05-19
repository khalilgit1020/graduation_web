import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_graduation/app_responsive.dart';
import 'package:my_graduation/bloc/home_cubit.dart';
import 'package:my_graduation/screens/bottom_bar/new_post_screen.dart';
import 'package:my_graduation/screens/post/saved_posts_screen.dart';
import 'package:my_graduation/widgets/show_dialog.dart';
import 'package:my_graduation/widgets/styles/icon_broken.dart';

import '../constants.dart';
import '../screens/bottom_bar/feed_screen.dart';
import '../screens/bottom_bar/notifications_screen.dart';
import '../screens/bottom_bar/profile_screen.dart';
import '../screens/bottom_bar/search_screen.dart';
import '../screens/chat/chat_details.dart';
import '../screens/chat/chats_screen.dart';

AppBar customAppBar({
  context,
  required CraftHomeCubit cubit,
}) =>
    AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 100,
      backgroundColor: barColor,
      actions: [
        // user picture
        if (!AppResponsive.isMobile(context))
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(cubit.UserModel!.image!),
            ),
          ),

        const Spacer(),

        // chat
        IconButton(
          onPressed: () {
            cubit.getUsersChatList();
            showModalBottomSheet(
              context: context,
              builder: (_) => const FractionallySizedBox(
                heightFactor: 0.9,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ChatScreen(),
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
            /*Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                const ChatScreen()));*/

            //dialog(context,'المحادثات',const ChatScreen());

          },
          icon: const Icon(IconBroken.Chat),
          iconSize: 33,
          color: mainColor,
        ),
        const SizedBox(
          width: 8,
        ),

        AppResponsive.isMobile(context)
            ? Column(
                children: [
                  // search
                  IconButton(
                    onPressed: () {
/*
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>  SearchsScreen()));*/

                      dialog(context, 'البحث', SearchsScreen());
                    },
                    icon: const Icon(Icons.search),
                    iconSize: 33,
                    color: mainColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  cubit.isCrafter
                      ?

                      // saved posts
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const SavedPostsScreen()));
                          },
                          child: Text(
                            'المنشورات المحفوظة',
                            style: TextStyle(color: mainColor, fontSize: 18),
                          ),
                        )
                      :
                      // notifications
                      IconButton(
                          onPressed: () {
                            cubit.getNotifications();
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
                          icon: const Icon(Icons.notifications_outlined),
                          iconSize: 33,
                          color: mainColor,
                        ),
                ],
              )
            : Row(
                children: [
                  // search
                  IconButton(
                    onPressed: () {
                      /*
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>  SearchsScreen()));*/
                      dialog(context, 'البحث', SearchsScreen());
                    },
                    icon: const Icon(Icons.search),
                    iconSize: 33,
                    color: mainColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  cubit.isCrafter
                      ? TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const SavedPostsScreen()));
                          },
                          child: Text(
                            'المنشورات المحفوظة',
                            style: TextStyle(color: mainColor, fontSize: 18),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            /*
              cubit.getUsersChatList();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const NotificationsScreen()));*/
                            cubit.getNotifications();
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
                          icon: const Icon(Icons.notifications_outlined),
                          iconSize: 33,
                          color: mainColor,
                        ),
                ],
              ),
        const SizedBox(
          width: 8,
        ),

        AppResponsive.isMobile(context)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // رئيسية
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => FeedScreen()));
                    },
                    child: Text(
                      'الرئيسية',
                      style: TextStyle(color: mainColor, fontSize: 18),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    width: 8,
                  ),

                  // الملف الشخصي
                  TextButton(
                    onPressed: () {
                      cubit.getMyWorkImages();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ProfileScreen()));
                    },
                    child: Text(
                      'الملف الشخصي',
                      style: TextStyle(color: mainColor, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              )
            : Row(
                children: [
                  // رئيسية
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => FeedScreen()));
                    },
                    child: Text(
                      'الرئيسية',
                      style: TextStyle(color: mainColor, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),

                  // الملف الشخصي
                  TextButton(
                    onPressed: () {
                      cubit.getMyWorkImages();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ProfileScreen()));
                    },
                    child: Text(
                      'الملف الشخصي',
                      style: TextStyle(color: mainColor, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),

        if (!cubit.isCrafter)
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NewPostScreen()));
            },
            child: Text(
              'إنشاء منشور',
              style: TextStyle(color: mainColor, fontSize: 18),
            ),
          ),
        const SizedBox(
          width: 8,
        ),

        // const SizedBox(width: 10,),

        // site name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            //'Craft Up'
            child: RichText(
              text: TextSpan(
                children: [
                  //  Up
                  TextSpan(
                    text: 'Craft',
                    style: TextStyle(
                      fontSize: AppResponsive.isMobile(context) ? 20 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.withOpacity(0.7),
                      fontFamily: 'Pacifico',
                    ),
                  ),

                  TextSpan(
                    text: ' Up',
                    style: TextStyle(
                      fontSize: AppResponsive.isMobile(context) ? 20 : 32,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
