import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/bloc/home_cubit.dart';
import 'package:my_graduation/constants.dart';
import 'package:my_graduation/models/craft_user_model.dart';
import 'package:my_graduation/screens/chat/chat_details.dart';

import '../app_responsive.dart';
import '../bloc/craft_states.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_footer.dart';
import '../widgets/custom_profile.dart';
import '../widgets/user_info_and_works.dart';
import 'settings_screen/image_zoom_screen.dart';

class OtherUserProfile extends StatelessWidget {
  final CraftUserModel userModel;

  OtherUserProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.grey[300],
              appBar: customAppBar(cubit: cubit, context: context),
              body: SingleChildScrollView(
                child: Column(
                  children: [

                    if(!AppResponsive.isMobile(context))
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: customOtherProfile(
                              cubit: cubit,
                              context: context,
                              userModel: userModel,
                            ),
                          ),
                          Expanded(
                            flex: !AppResponsive.isDesktop(context) ? 4 : 5,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: otherUserGalleryOrPosts(userModel, cubit),
                            ),
                          ),
                        ],
                      ),

                    if(AppResponsive.isMobile(context))
                      Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 60.0,left: 60,top: 10,bottom: 8),
                            child: customOtherProfile(
                              cubit: cubit,
                              context: context,
                              userModel: userModel,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: otherUserGalleryOrPosts(userModel, cubit),
                          ),
                        ],
                      ),


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

  Column userPicture(context, Size size, CraftUserModel userModel) {
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
                          tag: 'profile 1'.toString(),
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

  Column userInfoAndWorks(
    Size size,
    CraftUserModel userModel,
    CraftHomeCubit cubit,
    BuildContext context,
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
                      InkWell(
                        onTap: () {
                          cubit.getMessage(receiverId: userModel.uId!);
                          cubit.getOtherLocation(userId: userModel.uId!);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChatDetailsScreen(userModel: userModel)));
                        },
                        child: Container(
                          width: size.width / 4.5,
                          height: size.height / 25,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'مراسلة',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
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
        userModel.userType!
            ? Expanded(
                child: RefreshIndicator(
                onRefresh: () {
                  return cubit.getOtherWorkImages(id: userModel.uId);
                },
                child: cubit.otherWorkGallery.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
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
                                        url: url,
                                      )));
                            },
                            child: Hero(
                              tag: index.toString(),
                              child: CachedNetworkImage(
                                imageUrl: url,
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
                          'لا يوجد لديه صور في معرضه الخاص بعد',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ))
            : Expanded(
                child: Center(
                  child: Stack(
                    children: [
                      Align(
                        alignment: const Alignment(-2, -0.7),
                        child: Image.asset('assets/images/profile2.png'),
                      ),
                      Align(
                        alignment: const Alignment(0, -1),
                        child: Image.asset('assets/images/profile.png'),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
