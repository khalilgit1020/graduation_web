import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/app_responsive.dart';
import 'package:my_graduation/widgets/custom_appbar.dart';
import 'package:my_graduation/widgets/custom_footer.dart';
import 'package:my_graduation/widgets/custom_profile.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../widgets/build_post.dart';
import '../../widgets/show_taost.dart';

class FeedScreen extends StatefulWidget {
  static const String route = '/Feed';


  FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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


        print(size.width);

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: Colors.grey[300],
               // drawer: AppResponsive.isMobile(context) ?mainDrawer(context, cubit):null ,
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
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: cubit.posts!.isNotEmpty
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
                                            itemCount: cubit.posts!.length,
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
                                        ],
                                      ),
                                    ),
                                  )
                                  :const Center(
                                    child: CircularProgressIndicator.adaptive(),
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



}
