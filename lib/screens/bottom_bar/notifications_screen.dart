import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/models/craft_user_model.dart';
import 'package:my_graduation/models/post_model.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../other_user_profile.dart';
import '../post/post_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
              children: [
                const Text(
                  'الإشعارات',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const Divider(
                  height: 50,
                ),
                Expanded(
                  child: cubit.notificationPosts!.isNotEmpty
                      ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cubit.notificationPosts!.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(
                              height: 8,
                            ),
                        itemBuilder: (context, index) {
                          return buildNotification(
                            context: context,
                            model: cubit.notificationPosts![index],
                            user: cubit.notificationUsers![index],
                            cubit: cubit,
                          );
                        },
                      ),
                    ),
                  )
                      : const Expanded(
                        child: Center(
                    child: Text(
                        'لا يوجد لديك إشعارات بعد...',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                    ),
                  ),
                      ),
                ),
              ],
            ),
        );
      },
    );
  }

  Widget buildNotification({
    required BuildContext context,
    required PostModel model,
    required CraftUserModel user,
    required CraftHomeCubit cubit,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            cubit.getOtherWorkImages(id: user.uId);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OtherUserProfile(
                  userModel: user,
                )));
          },
          child: CircleAvatar(
            radius: 25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: CachedNetworkImage(
                height: double.infinity,
                width: double.infinity,
                imageUrl: user.image!,
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
          width: 12,
        ),
        Expanded(
          flex: 6,
          child: InkWell(
            onTap: () {
              //cubit.getCommentModel(userId: postId);
              cubit.getComments(postId: model.postId);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PostScreen(model: model)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '  علق على منشورك ',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}