import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/screens/post/post_screen.dart';

import '../../app_responsive.dart';
import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../models/post_model.dart';
import '../../widgets/build_post.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/custom_profile.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.grey[300],
              appBar: customAppBar(context: context, cubit: cubit),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  height: size.height / 6,
                                  color: mainColor,
                                  child:const  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'المنشورات المحفوظة',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width,
                                  height: size.height,
                                  child: cubit.posts!.isNotEmpty
                                      ? body1(cubit)
                                      :body2(),
                                ),
                              ],
                            ),
                          ),
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

  Padding body2() {
    return const Padding(
      padding: EdgeInsets.only(top: 200.0),
      child: Center(
        child: Text(
          'لا يوجد لديك منشورات محفوظة',
        ),
      ),
    );
  }

  SingleChildScrollView body1(CraftHomeCubit cubit) {
    return SingleChildScrollView(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cubit.mySavedPostsDetails!.length,
        separatorBuilder: (context, index) =>
        const SizedBox(height: 30,),
        itemBuilder: (context, index) {
          return BuildPost(
            // context: context,
            model: cubit.posts![index],
            cubit: cubit,
            // userModel: UserModel!,
          );
        },
      ),
    );
  }

}
