import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/app_responsive.dart';
import 'package:my_graduation/models/post_model.dart';
import 'package:my_graduation/widgets/custom_appbar.dart';
import 'package:my_graduation/widgets/custom_footer.dart';
import 'package:my_graduation/widgets/custom_profile.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../widgets/build_post.dart';
import '../../widgets/show_taost.dart';
import '../other_user_profile.dart';
import '../post/post_screen.dart';

class FeedScreen extends StatefulWidget {
  static const String route = '/Feed';

  FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftSavePostSuccessState) {
          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم حفظ المنشور بنجاح',
          );

          if (kDebugMode) {
            print('تم الحفظ بنجاح');
          }
        }

        if (state is CraftGetPostErrorState) {
          if (kDebugMode) {
            print('${state.error.toString()} +++++++++');
          }
        }

        if (state is CraftGetAllUsersErrorState) {
          if (kDebugMode) {
            print('${state.error.toString()} +++++++++');
          }
        }
      },
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        // var UserModel = CraftHomeCubit.get(context).UserModel;

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.grey[300],
              // drawer: AppResponsive.isMobile(context) ?mainDrawer(context, cubit):null ,
              appBar: customAppBar(context: context, cubit: cubit),
              body: SingleChildScrollView(
                child: Column(
                  children: [


                    !AppResponsive.isMobile(context) ?
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: customProfile(cubit: cubit, context: context),
                        ),
                        Expanded(
                          flex: !AppResponsive.isDesktop(context) ? 4 : 5,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: cubit.posts!.isNotEmpty
                                ? SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ListView.separated(
                                            reverse: true,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: cubit.posts!.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              height: 30,
                                            ),
                                            itemBuilder: (context, index) {
                                              return buildPost(
                                                context: context,
                                                model: cubit.posts![index],
                                                cubit: cubit,
                                                // userModel: UserModel!,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                          ),
                        ),
                      ],
                    ):
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: cubit.posts!.isNotEmpty
                          ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              ListView.separated(
                                reverse: true,
                                shrinkWrap: true,
                                physics:
                                const NeverScrollableScrollPhysics(),
                                itemCount: cubit.posts!.length,
                                separatorBuilder:
                                    (context, index) =>
                                const SizedBox(
                                  height: 30,
                                ),
                                itemBuilder: (context, index) {
                                  return buildPost(
                                    context: context,
                                    model: cubit.posts![index],
                                    cubit: cubit,
                                    // userModel: UserModel!,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                          : const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                    ,
                    customFooter(context: context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPost({
    required BuildContext context,
    required PostModel model,
    required CraftHomeCubit cubit,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                  cubit.getOtherPosts(userId: model.uId!);
                  print(model.uId!);
                  cubit.getOtherWorkImages(id: model.uId).then((value) {
                    if (model.uId == cubit.UserModel!.uId) {
                      //cubit.changeBottomNv(3);
                      print('its your profile');
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => OtherUserProfile(
                              userModel: cubit.specialUser![model.uId]!)));
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
                style: TextStyle(
                  fontSize: AppResponsive.isMobile(context) ? 12 : 18,
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
              cubit.getComments(postId: model.postId!);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PostScreen(model: model)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(
                model.text!,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w700),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: InkWell(
                    onTap: () {
                      cubit.getComments(postId: model.postId!);
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
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
}
