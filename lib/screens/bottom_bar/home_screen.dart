import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/bloc/home_cubit.dart';
import 'package:my_graduation/screens/bottom_bar/feed_screen.dart';

import '../../bloc/craft_states.dart';

class HomeScreen extends StatefulWidget {

  static const String route = '/home';


  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {


        if (state is CraftGetLocationErrorState){
          print(state.error);
        }

      },
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        return  cubit.posts != null && cubit.UserModel != null && cubit.users.isNotEmpty ?
        SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: FeedScreen(),),
          ),
        ) :
        const Scaffold(body: Center(child: CircularProgressIndicator(),),);
      },
    );
  }
}
