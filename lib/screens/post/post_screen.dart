
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/constants.dart';
import 'package:my_graduation/models/comment_model.dart';
import 'package:my_graduation/widgets/custom_appbar.dart';
import 'package:my_graduation/widgets/custom_footer.dart';
import 'package:my_graduation/widgets/styles/icon_broken.dart';

import '../../app_responsive.dart';
import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../models/post_model.dart';
import '../../widgets/custom_profile.dart';
import '../../widgets/show_taost.dart';
import '../other_user_profile.dart';

class PostScreen extends StatefulWidget {
  final PostModel model;

  const PostScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

  class _PostScreenState extends State<PostScreen> {
  var commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
      // cubit.getComments(postId: widget.model.postId);

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // getComments(postId: postId);
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftWriteCommentSuccessState) {
          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم إضافة التعليق',
          );
        }
      },
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);
        print(cubit.specialUser!.length + 1);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: customAppBar(context: context ,cubit: cubit),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:2,
                        child:customProfile(cubit: cubit,context: context),
                      ),
                      Expanded(
                        flex:!AppResponsive.isDesktop(context)? 4: 5,
                        child: Container(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          /*decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),*/
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width,
                                  height: size.height / 8.5,
                                  color: mainColor,
                                  child:const Center(
                                    child: Text(
                                      'تفاصيل الوظيفة',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.width / 15,
                                ),

                                // post title
                                Center(
                                  child: Text(
                                    widget.model.jobName!,
                                    style: const TextStyle(
                                        fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: size.width / 30,
                                ),

                                // post details
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.model.location!,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Divider(),
                                      Text(
                                        '${widget.model.salary!} \$',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.width / 30,
                                ),

                                // post text
                                Center(
                                  child: Container(
                                    height: size.height / 3,
                                    width: size.width / 1.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    margin: const EdgeInsets.all(10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        widget.model.text!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.width / 10,
                                ),

                                // for enter comment
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    width: size.width / 3.5,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: commentController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'تعليقك فارغ,يرجى ادخال تعليق مناسب للمنشور';
                                              }
                                              return null;
                                            },
                                            onChanged: (String value) {
                                              if (!RegExp(r'^[ ]*$')
                                                  .hasMatch(value)) {
                                                cubit.enableCommentButton(
                                                    comment: value);
                                              } else {
                                                cubit.unableCommentButton(
                                                    comment: value);
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              label: Text('اكتب تعليقك هنا'),
/*suffixIcon: Icon(
                                              IconBroken.Send,
                                              color: Colors.blue,
                                            ),*/
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: cubit.currentComment == ''
                                              ? null
                                              : () {
                                            cubit.sendComment(
                                              text: commentController.text
                                                  .toString(),
                                              postId: widget.model.postId,
                                            );
                                            commentController.clear();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          }
                                          /*(){
                                              if(commentController.text.isNotEmpty){
                                                cubit.sendComment(
                                                  text: commentController.text.toString(),
                                                  postId: model.postId,
                                                );
                                              }
                                            }*/
                                          ,
                                          color: cubit.currentComment == ''
                                              ? Colors.grey
                                              : Colors.blue,
                                          icon: const Icon(IconBroken.Send),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                FadeIn(
                                  duration: const Duration(milliseconds: 100),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                      'رؤية التعليقات ',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: mainColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                FadeIn(
                                  duration: const Duration(milliseconds: 100),
                                  child:
                                  Container(
                                    color: mainColor,
                                    width: double.infinity,
                                    height: 2,
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                if (cubit.comments!.isNotEmpty)
                                  FadeIn(
                                    duration: const Duration(milliseconds: 100),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: ListView.separated(
                                        reverse: true,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: cubit.comments!.length,
                                        separatorBuilder: (context, index) => FadeIn(
                                          duration: const Duration(milliseconds: 100),
                                          child:
                                          Container(
                                            color: Colors.grey[300],
                                            width: double.infinity,
                                            height: 2,
                                          ),
                                        ),
                                        itemBuilder: (context, index) {
                                          // cubit.getComments(postId: model.postId);

                                          return buildComment(
                                              context: context,
                                              index: index,
                                              model: cubit.comments![index],
                                              cubit: cubit);
                                        },
                                      ),
                                    ),
                                  ),
                                if (cubit.comments!.isEmpty)
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'لا توجد تعليقات حتى الآن',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(fontSize: 17, height: 1),
                                        ),
                                        Text(
                                          'كن أول من يعلق',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(fontSize: 14, height: 1.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  customFooter(context: context),
                ],
              ),
            ) ,
          ),
        );
      },
    );
  }

  Widget buildComment({
    required BuildContext context,
    required int index,
    required CommentModel model,
    required CraftHomeCubit cubit,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              cubit.getOtherPosts(userId: model.userId!);
              cubit.getOtherWorkImages(id: model.userId).then((value) {
                if (model.userId != cubit.UserModel!.uId) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => OtherUserProfile(
                          userModel: cubit.specialUser![model.userId]!)));
                }
              });
            },
            child: CircleAvatar(
              radius: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: CachedNetworkImage(
                  height: double.infinity,
                  width: double.infinity,
                  imageUrl: cubit.specialUser![model.userId]!.image!,
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
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Text(
                cubit.specialUser![model.userId]!.name!,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                model.comment.toString(),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}