

import 'package:flutter/material.dart';
import 'package:my_graduation/bloc/home_cubit.dart';

import '../app_responsive.dart';
import '../constants.dart';
import 'custom_profile.dart';

class CustomBody extends StatelessWidget {
  final CraftHomeCubit? cubit;
  final Widget? body;
  final String? title;

  const CustomBody({Key? key,required this.cubit,required this.body,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    var size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!AppResponsive.isMobile(context))
          Expanded(
            flex: 2,
            child:
            customProfile(cubit: cubit, context: context),
          ),
        Expanded(
          flex: !AppResponsive.isDesktop(context) ? 4 : 5,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30),
                  height: size.height / 6,
                  color: mainColor,
                  child:  Align(
                    alignment: Alignment.center,
                    child: Text(
                      title!,
                      style:const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 20),
                  width: size.width,
                  height: size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: body,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
