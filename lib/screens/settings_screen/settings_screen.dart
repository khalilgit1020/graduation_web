import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_graduation/helpers/cache_helper.dart';
import 'package:my_graduation/screens/auth/login_screen.dart';
import 'package:my_graduation/screens/bottom_bar/profile_screen.dart';
import 'package:my_graduation/widgets/custom_body.dart';
import 'package:my_graduation/widgets/show_dialog.dart';

import '../../app_responsive.dart';
import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../helpers/custom_scroll_behavior.dart';
import '../../models/craft_user_model.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/show_taost.dart';
import '../../widgets/styles/icon_broken.dart';
import 'image_zoom_screen.dart';

class SettingsProfileScreen extends StatefulWidget {
  SettingsProfileScreen({Key? key}) : super(key: key);

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  var suggestionController = TextEditingController();
  var addressController = TextEditingController();
  var craftTypeController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();

  final ScrollController controller = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    addressController.dispose();
    suggestionController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
    craftTypeController.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftUploadWorkImageSuccessState) {
          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم إضافة الصورة',
          );
        }

        if (state is CraftDeleteWorkImageSuccessState) {
          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم حذف الصورة',
          );
        }

        if (state is CraftWriteSuggestionSuccessState) {
          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم إرسال اقتراحك بنجاح',
          );
        }

        if (state is CraftUserUpdateSuccessState) {
          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم تعديل البيانات الشخصية',
          );

          CraftHomeCubit.get(context).getUserData();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ProfileScreen()));
        }

        if (state is CraftLogoutSuccessState) {
          CacheHelper.removeData(key: 'uId').then((value) {
            if (value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CraftLoginScreen()));
            }
          });
        }
      },
      builder: (context, state) {
        // var userModel = CraftHomeCubit.get(context).UserModel;
        var cubit = CraftHomeCubit.get(context);

        var userModel = CraftHomeCubit.get(context).UserModel!;
        var profileImage = CraftHomeCubit.get(context).profileImage;

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.grey[300],
              appBar: customAppBar(context: context, cubit: cubit),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomBody(
                        cubit: cubit,
                        body: body(cubit, userModel, size, context,
                            profileImage, state),
                        title: 'الإعدادات'),
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

  Column userPicture(Size size, CraftUserModel userModel, profileImage) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 4, color: Colors.blue.shade200),
          ),
          child: CircleAvatar(
              radius: 30, backgroundImage: NetworkImage('${userModel.image}')),
        ),
      ],
    );
  }

  SingleChildScrollView body(CraftHomeCubit cubit, userModel, size, context,
          profileImage, state) =>
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // for project details
            const ExpansionTile(
              title: Text(
                'معلومات الموقع',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                ExpansionTile(
                  title: Text(
                    'سياسة الاستخدام ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'يمنع استخدام  خدمات الموقع باي طريقة تخل بقوانين فلسطين , جميع محتويات الموقع هيحقوق ملكية فكرية محفوظة ويمنع استخدامها باي شكل من أي اطراف اخرى',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'شروط العضوية:\n اختيار اسم لائق ومناسب خلال عملية التسجيل\n يلتزم العضو بعدم مشاركة معلومات عضويته ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'عن الموقع',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'موقع يختص بفئة الحرفيين وأصحاب المشغولات اليدوية حيث يتم  الإعلان عن الوظائف الشاغرة واستقطاب الموظفين بصورة سهلة وسريعة',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'مميزات الموقع:\n يمكن استخدامه للإعلان او التقدم لوظيفة مباشرة بشكل مجاني\n يلتزم العضو بعدم مشاركة معلومات عضويته ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // write suggestion
            ExpansionTile(
              title: const Text(
                'كتابة اقتراح',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: AppResponsive.isTablet(context)
                            ? size.width / 3
                            : size.width / 2.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0.1,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextFormField(
                          maxLines: null,
                          minLines: 12,
                          controller: suggestionController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'تأكد من إدخال اقتراح جيد';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'أدخل محتوى الاقتراح',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      MaterialButton(
                        minWidth: size.width / 6,
                        height: 55,
                        color: mainColor,
                        onPressed: () {
                          var date = DateTime.now();
                          cubit.writeSuggestion(
                            date: date.toString(),
                            content: suggestionController.text,
                            uId: cubit.UserModel!.uId,
                          );
                        },
                        child: const Text(
                          'إرسال',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // WriteSuggetion(),
              ],
            ),

            //  Edit Profile
            ExpansionTile(
              title: const Text(
                'تعديل البيانات الشخصية',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // for user picture
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Container(
                                width: AppResponsive.isMobile(context)
                                    ? size.width / 4
                                    : size.width / 6,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                height: 60,
                                child: state is CraftUserUpdateLoadingState
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          cubit.profileImage == null
                                              ? cubit.updateUser(
                                                  name:
                                                      nameController.text == ''
                                                          ? userModel.name
                                                          : nameController.text,
                                                  phone: phoneController.text ==
                                                          ''
                                                      ? userModel.phone
                                                      : phoneController.text,
                                                  address: addressController
                                                              .text ==
                                                          ''
                                                      ? userModel.address
                                                      : addressController.text,
                                                  craftType: craftTypeController
                                                              .text ==
                                                          ''
                                                      ? userModel.craftType
                                                      : craftTypeController
                                                          .text,
                                                )
                                              : cubit.uploadProfileImage(
                                                  name:
                                                      nameController.text == ''
                                                          ? userModel.name
                                                          : nameController.text,
                                                  phone: phoneController.text ==
                                                          ''
                                                      ? userModel.phone
                                                      : phoneController.text,
                                                  address: addressController
                                                              .text ==
                                                          ''
                                                      ? userModel.address
                                                      : addressController.text,
                                                  craftType: craftTypeController
                                                              .text ==
                                                          ''
                                                      ? userModel.craftType
                                                      : craftTypeController
                                                          .text,
                                                );
                                        },
                                        child: const Text(
                                          'حفظ التغييرات',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                              ),
                            ),

                            // for edit button
                            Column(
                              children: [
                                userPicture(size, userModel, profileImage),
                                TextButton(
                                  onPressed: () {
                                    cubit.getProfileImage();
                                  },
                                  child: const Text(
                                    'تغيير الصورة الشخصيَّة',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // for enter name
                            Container(
                              width: AppResponsive.isMobile(context)
                                  ? size.width / 2.7
                                  : size.width / 4,
                              child: Column(
                                children: [
                                  Text(
                                    'الاسم',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 0.1,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: nameController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'الرجاء إدخال اسمك';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        //  label: Text('البريد الالكتروني'),
                                        //  prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // for enter address
                            Container(
                              width: AppResponsive.isMobile(context)
                                  ? size.width / 2.7
                                  : size.width / 4,
                              child: Column(
                                children: [
                                  Text(
                                    'العنوان',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 0.1,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: addressController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'الرجاء إدخال عنوانك';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        if (userModel.userType == true)
                          Container(
                            width: AppResponsive.isMobile(context)
                                ? size.width / 2.7
                                : size.width / 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // for enter job name
                                Text(
                                  'نوع الحرفة',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                  child: TextFormField(
                                    controller: craftTypeController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'الرجاء إدخال حرفتك الخاصة';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      // label: Text(name),
                                      //  prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // for enter phone number
                            Container(
                              width: AppResponsive.isMobile(context)
                                  ? size.width / 2.7
                                  : size.width / 4,
                              child: Column(
                                children: [
                                  Text(
                                    'رقم الجوال',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 0.1,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'الرجاء إدخال رقم هاتفك';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // for enter email
                            Container(
                              width: AppResponsive.isMobile(context)
                                  ? size.width / 2.7
                                  : size.width / 4,
                              child: Column(
                                children: [
                                  Text(
                                    'البريد الالكتروني',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 0.1,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      initialValue: userModel.email!,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                      enabled: false,
                                      //   controller: emailController,

                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        //  label: Text('البريد الالكتروني'),
                                        //  prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // edit gallery works
            if (cubit.isCrafter)
              ExpansionTile(
                title: const Text(
                  'تعديل معرض اعمالي',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  IconButton(
                    onPressed: () {
                      cubit.getWorkImage();
                      // cubit.openPicker();
                    },
                    icon: const Icon(Icons.add_a_photo_outlined),
                    color: mainColor,
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  if (state is CraftUploadWorkImageLoadingState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 5,
                  ),
                  ScrollConfiguration(
                    behavior: MyCustomScrollBehavior(),
                    child: SizedBox(
                      height: 250,
                      child: cubit.myWorkGallery.isNotEmpty
                          ? ListView.builder(
                              controller: controller,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              scrollDirection: Axis.horizontal,
                              itemCount: cubit.myWorkGallery.length,
                              itemBuilder: (context, index) {
                                var url = cubit.myWorkGallery[index]['image'];

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ImageZoomScreen(
                                                        tag: index.toString(),
                                                        url: url!,
                                                      )));
                                        },
                                        child: Container(
                                          height: 180,
                                          width: 200,
                                          decoration: BoxDecoration(
                                              // color: mainColor,
                                              border: Border.all(width: 1)),
                                          child: Hero(
                                            tag: index.toString(),
                                            child: CachedNetworkImage(
                                              imageUrl: url!,
                                              placeholder: (context, url) =>
                                                  Container(
                                                color: Colors.grey[300],
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          deleteImageDialog(context, cubit,
                                              cubit.myWorkGallery[index]['id']);
                                        },
                                        icon: const Icon(
                                          IconBroken.Delete,
                                          color: Colors.red,
                                        ),
                                        iconSize: 25,
                                      ),
                                    ],
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
                                    color: mainColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                  )
                ],
              ),

            buildListTileForSettings(IconBroken.Logout, 'تسجيل الخروج', () {
              logUotDialog(context, cubit);
            }),
          ],
        ),
      );

  Column buildListTileForSettings(IconData icon, title, Function() onTap) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          color: mainColor,
          width: double.infinity,
          height: 2,
        ),
      ],
    );
  }
}
