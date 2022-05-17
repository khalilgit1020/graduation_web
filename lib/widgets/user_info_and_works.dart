import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_graduation/widgets/build_post.dart';

import '../bloc/home_cubit.dart';
import '../constants.dart';
import '../models/craft_user_model.dart';
import '../screens/settings_screen/image_zoom_screen.dart';

Column UserInfoAndWorks(
  Size size,
  CraftUserModel userModel,
  CraftHomeCubit cubit,
) {
  return Column(
    children: [
      SizedBox(
        height: size.height / 8.5,
      ),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Card(
            elevation: 5,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 20,
                    ),
                    textUser(userModel.name, 20),
                    if (userModel.craftType != '')
                      textUser(userModel.craftType, 14),
                    textUser('${userModel.address} | ${userModel.phone}', 14),
                    textUser(userModel.email, 14),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      user_gallery_or_posts(userModel, cubit),
    ],
  );
}

Column user_gallery_or_posts(CraftUserModel userModel, CraftHomeCubit cubit) {
  return userModel.userType!
      ? Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 12),
              child: Text(
                'معرض الأعمال',
                style: TextStyle(
                    fontSize: 25,
                    color: mainColor
                ),
              ),
            ),
          ),
          Container(
            color: mainColor,
            width: double.infinity,
            height: 2,
          ),

          Container(
              height: 550,
              child: cubit.myWorkGallery.isNotEmpty
                  ? GridView.builder(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 3,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: cubit.myWorkGallery.length,
                      itemBuilder: (context, index) {
                        var url = cubit.myWorkGallery[index]['image'];

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ImageZoomScreen(
                                      tag: index.toString(),
                                      url: url!,
                                    )));
                          },
                          child: Hero(
                            tag: index.toString(),
                            child: CachedNetworkImage(
                              imageUrl: url!,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'لا يوجد لديك صور في معرضك الخاص, أضف بعض الصور...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
        ],
      )
      : Column(
    children: [
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 12),
          child: Text(
            'إعلاناتي',
            style: TextStyle(
                fontSize: 25,
                color: mainColor
            ),
          ),
        ),
      ),
      Container(
        color: mainColor,
        width: double.infinity,
        height: 2,
      ),

      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: cubit.myPosts!.isNotEmpty
            ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                ListView.separated(
                  reverse: true,
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount: cubit.myPosts!.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 30,),
                  itemBuilder: (context, index) {
                    return BuildPost(
                      model: cubit.myPosts![index],
                      //context: context,
                      cubit: cubit
                    );
                  },
                ),
              ],
            ),
          ),
        )
            :Center(
          child: Text(
            'لا يوجد لديك إعلانات بعد, قم بنشر اعلان ما...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}




Column otherUserGalleryOrPosts(CraftUserModel userModel, CraftHomeCubit cubit) {
  return userModel.userType!
      ? Column(
    children: [
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 12),
          child: Text(
            'معرض الأعمال',
            style: TextStyle(
                fontSize: 25,
                color: mainColor
            ),
          ),
        ),
      ),
      Container(
        height: 2,
        width: double.infinity,
        color: mainColor,
      ),

      Container(
        height: 550,
        child: cubit.otherWorkGallery.isNotEmpty
            ? GridView.builder(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 3,
            crossAxisSpacing: 18,
            mainAxisSpacing: 14,
          ),
          itemCount: cubit.otherWorkGallery.length,
          itemBuilder: (context, index) {
            var url = cubit.otherWorkGallery[index]['image'];

            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ImageZoomScreen(
                      tag: index.toString(),
                      url: url!,
                    )));
              },
              child: Hero(
                tag: index.toString(),
                child: CachedNetworkImage(
                  imageUrl: url!,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        )
            : Center(
          child: Text(
            'لا يوجد لديك صور في معرضك الخاص, أضف بعض الصور...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  )
      : Column(
    children: [
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 12),
          child: Text(
            'إعلاناته الشخصية',
            style: TextStyle(
                fontSize: 25,
                color: mainColor
            ),
          ),
        ),
      ),
      Container(
        height: 2,
        width: double.infinity,
        color: mainColor,
      ),

      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: cubit.otherPosts.isNotEmpty
            ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                ListView.separated(
                  reverse: true,
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount: cubit.otherPosts.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 30,),
                  itemBuilder: (context, index) {
                    return BuildPost(
                        model: cubit.otherPosts[index],
                       // context: context,
                        cubit: cubit
                    );
                  },
                ),
              ],
            ),
          ),
        )
            :Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'لا يوجد لديه إعلانات بعد...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ],
  );
}


Center textUser(userModel, double size) {
  return Center(
    child: Text(
      userModel,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Column UserPicture(context, Size size, CraftUserModel userModel) {
  return Column(
    children: [
      SizedBox(
        height: size.height / 16,
      ),
      Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 4, color: Colors.blue.shade200),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ImageZoomScreen(
                        tag: 'profile'.toString(),
                        url: userModel.image!,
                      )));
            },
            child: CircleAvatar(
              radius: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: CachedNetworkImage(
                  height: double.infinity,
                  width: double.infinity,
                  imageUrl: userModel.image!,
                  placeholder: (context, url) => CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.grey[300],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

