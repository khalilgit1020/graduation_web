
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/bloc/home_cubit.dart';
import 'package:my_graduation/widgets/custom_appbar.dart';
import 'package:my_graduation/widgets/custom_footer.dart';

import '../../app_responsive.dart';
import '../../bloc/craft_states.dart';
import '../../widgets/custom_profile.dart';
import '../../widgets/user_info_and_works.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
//  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();




  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        //CraftHomeCubit().getMyWorkImages();
      },
      builder: (context, state) {

        var cubit = CraftHomeCubit.get(context);

        //  cubit.getUserData();

        var userModel = cubit.UserModel!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: customAppBar(cubit: cubit,context: context),
            body: SingleChildScrollView(
              child: Column(
                children: [


                  if(!AppResponsive.isMobile(context))
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
                          child: user_gallery_or_posts(userModel, cubit),
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
                        child: customProfile(cubit: cubit,context: context),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: user_gallery_or_posts(userModel, cubit),
                      ),
                    ],
                  ),

                  customFooter(context: context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

/*
  IconButton settingsOfProfile(context, CraftUserModel userModel) {
    return IconButton(
      onPressed: () {
        userModel.userType!
            ? settingModalBottomSheet(context)
            : Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => EditProfileScreen()));
      },
      icon: const Icon(IconBroken.Edit),
      color: Colors.white,
    );
  }
*/

}