import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/bloc/home_cubit.dart';
import 'package:my_graduation/models/post_model.dart';
import 'package:my_graduation/screens/post/post_screen.dart';

import '../app_responsive.dart';
import '../bloc/craft_states.dart';
import '../constants.dart';
import '../screens/other_user_profile.dart';


class BuildPost extends StatelessWidget {
  final PostModel? model;
  final CraftHomeCubit cubit;

//  final CraftUserModel userModel;

   BuildPost({Key? key, required this.model,required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),

              // name and photo of user
              Row(
                children: [
                  InkWell(
                    onTap: () {


                      cubit.getOtherPosts(userId: model!.uId!);
                      print( model!.uId!);
                      cubit.getOtherWorkImages(id: model!.uId).then((value) {

                          if (model!.uId == cubit.UserModel!.uId) {
                            //cubit.changeBottomNv(3);
                            print('its your profile');
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => OtherUserProfile(
                                    userModel: cubit.specialUser![model!.uId]!)));
                          }

                      }).catchError((error) {
                        if (kDebugMode) {
                          print(error.toString());
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: mainColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CachedNetworkImage(
                          height: double.infinity,
                          width: double.infinity,
                          imageUrl: model!.image!,
                          placeholder: (context, url) => CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.grey[300],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    model!.name!,
                    style:  TextStyle(
                      fontSize:AppResponsive.isMobile(context) ? 12:18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              // post text
              InkWell(
                  onTap: () {
                    cubit.getComments(postId: model!.postId!).then((value) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PostScreen(model: model!)));
                    });
                    },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(
                    model!.text!,
                    style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),

              // post details
              Card(
                elevation: 10,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shadowColor: Colors.black45,
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: InkWell(onTap: () {

                        cubit.getComments(postId: model!.postId!).then((value) {

                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => PostScreen(model: model!)));

                        });
                      },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.only(
                                right: 20.0, top: 20, bottom: 20, left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Text(
                                    model!.jobName!,
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_sharp),
                                    const SizedBox(width: 8),
                                    Text(
                                      model!.location!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money_sharp),
                                    const SizedBox(width: 8),
                                    Text(
                                      model!.salary!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (cubit.isCrafter)
                      Expanded(
                        flex: 1,
                          child: IconButton(
                            onPressed: () {
                              print(
                                  '${cubit.mySavedPostsDetails!.length} | ${cubit.mySavedPostsId!.length}');
                              cubit.savePost(postId: model!.postId);
                            },
                            icon: cubit.mySavedPostsId!
                                .any((element) => element == model!.postId)
                                ? Icon(
                              Icons.bookmark_sharp,
                              color: mainColor,
                            )
                                : const Icon(Icons.bookmark_outline_sharp),
                          ),
                      ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }
}

/*

Widget buildPost({
  required BuildContext context,
  required PostModel model,
  required CraftHomeCubit cubit,
}) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),

        // name and photo of user
        Row(
          children: [
            InkWell(
              onTap: () {
                print( model.uId!);
                cubit.getOtherWorkImages(id: model.uId).then((value) {
                  cubit.getOtherPosts(userId: model.uId!).then((value) {

                    if (model.uId == cubit.UserModel!.uId) {
                      cubit.changeBottomNv(3);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => OtherUserProfile(
                              userModel: cubit.specialUser![model.uId]!)));
                    }

                  } );
                }).catchError((error) {
                  if (kDebugMode) {
                    print(error.toString());
                  }
                });
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: mainColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    height: double.infinity,
                    width: double.infinity,
                    imageUrl: model.image!,
                    placeholder: (context, url) => CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.grey[300],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              model.name!,
              style:  TextStyle(
                fontSize:AppResponsive.isMobile(context) ? 12:18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        // post text
        InkWell(
          onTap: () {
            cubit.getComments(postId: model.postId);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PostScreen(model: model)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              model.text!,
              style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
        ),

        // post details
        Card(
          elevation: 5,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: Colors.grey[100],
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: InkWell(
                  onTap: () {
                    cubit.getComments(postId: model.postId);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PostScreen(model: model)));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.only(
                          right: 20.0, top: 20, bottom: 20, left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              model.jobName!,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on_sharp),
                              const SizedBox(width: 8),
                              Text(
                                model.location!,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.attach_money_sharp),
                              const SizedBox(width: 8),
                              Text(
                                model.salary!,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (cubit.isCrafter)
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      print(
                          '${cubit.mySavedPostsDetails!.length} | ${cubit.mySavedPostsId!.length}');
                      cubit.savePost(postId: model.postId);
                    },
                    icon: cubit.mySavedPostsId!
                        .any((element) => element == model.postId)
                        ? Icon(
                      Icons.bookmark_sharp,
                      color: mainColor,
                    )
                        : const Icon(Icons.bookmark_outline_sharp),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}
*/
