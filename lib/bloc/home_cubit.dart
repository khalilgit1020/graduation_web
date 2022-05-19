import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_graduation/models/comment_model.dart';
import 'package:my_graduation/screens/bottom_bar/profile_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:my_graduation/screens/bottom_bar/search_screen.dart';
import 'package:my_graduation/screens/post/saved_posts_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../helpers/cache_helper.dart';
import '../models/chat_model.dart';
import '../models/craft_user_model.dart';
import '../models/post_model.dart';
import '../screens/bottom_bar/feed_screen.dart';
import '../screens/bottom_bar/notifications_screen.dart';
import 'craft_states.dart';

class CraftHomeCubit extends Cubit<CraftStates> {
  CraftHomeCubit() : super(CraftInitialState());

  static CraftHomeCubit get(context) => BlocProvider.of(context);

  CraftUserModel? UserModel;
  bool isCrafter = true;

  void getUserData() {
    emit(CraftGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      UserModel = CraftUserModel.fromJson(value.data()!);
      getUsers();
      if (kDebugMode) {
        print('${UserModel!.name} ++++++++');
        print('${UserModel!.uId} ++++++++');
      }

      if (UserModel!.userType!) {
        isCrafter = true;
        emit(CraftMakeIsCrafterTrueState());
      } else {
        isCrafter = false;
        emit(CraftMakeIsCrafterFalseState());
      }

      //getNotifications();
      // getUsersChatList();
      getMyWorkImages();
    }).catchError((error) {
      emit(CraftGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List crafterScreens = [
    FeedScreen(),
    // const NotificationsScreen(),
    const SavedPostsScreen(),
    SearchsScreen(),
    ProfileScreen(),
  ];

  List userScreens = [
    FeedScreen(),
    const NotificationsScreen(),
    //const SavedPostsScreen(),
    SearchsScreen(),
    ProfileScreen(),
  ];

  List<String> titles = const [
    'الرئيسية',
    'الإشعارات',
    'جديد',
    'المحفوظات',
    'البروفايل',
  ];

  bool isEmpty = true;

  checkEmpty({
    required String text,
    required String name,
    required String location,
    required String salary,
  }) {
    if (text.isNotEmpty &&
        name.isNotEmpty &&
        location.isNotEmpty &&
        salary.isNotEmpty) {
      isEmpty = false;
    } else {
      isEmpty = true;
    }
  }

  void createPost({
    required String? dateTime,
    required String? text,
    required String? jobName,
    required String? location,
    required String? salary,
  }) {
    emit(CraftCreatePostLoadingState());

    PostModel model = PostModel(
      name: UserModel!.name,
      image: UserModel!.image,
      uId: UserModel!.uId,
      dateTime: dateTime,
      text: text,
      salary: salary,
      jobName: jobName,
      location: location,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      value.update({
        'postId': value.id,
      }).then((value) {
        getPosts();
      });
      emit(CraftCreatePostSuccessState());
    }).catchError((error) {
      emit(CraftCreatePostErrorState());
    });
  }

  List<PostModel>? posts = [];
  List<PostModel>? myPosts = [];
  Map<String, PostModel>? specificPost = {};
  List<CommentModel>? comments = [];

  List<PostModel> otherPosts = [];

  void getOtherPosts({
    required String userId,
  }) async {
    emit(CraftGetOtherPostLoadingState());

    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      otherPosts = [];

      for (var element in value.docs) {
        if (element.data()['uId'] == userId) {
          print('+++++++ ${element.data()}');
          otherPosts.add(PostModel.fromJson(element.data()));
        }
      }

      print(otherPosts.length);
      emit(CraftGetOtherPostSuccessState());
    });
  }

  bool enableComment({required String text}) {
    if (text == '') {
      emit(CraftChangeCommentStateState());
      return false;
    } else {
      emit(CraftChangeCommentStateState());
      return true;
    }
  }

  void sendComment({
    required String? text,
    required String? postId,
    // required String?
  }) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'comment': text,
      'userId': uId,
      'date': DateTime.now().toString(),
      'postId': postId,
    }).then((value) {
      value.update({
        'commentId': value.id,
      });
      emit(CraftWriteCommentSuccessState());
    }).catchError((error) {
      emit(CraftWriteCommentErrorState(error.toString()));
    });
  }

  void getPosts() {
    emit(CraftGetPostLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      posts = [];
      specificPost = {};
      myPosts = [];

      for (var element in event.docs) {
        if (element.data()['uId'] == UserModel!.uId) {
          myPosts!.add(PostModel.fromJson(element.data()));
        }

        posts!.add(PostModel.fromJson(element.data()));
        specificPost!.addAll(
            {element.data()['postId']: PostModel.fromJson(element.data())});

        //getComments(postId: element.data()['postId']);

      }
      getNotifications();
      getMySavedPostsId();
      emit(CraftGetPostSuccessState());
    });
  }

  void getComments({required String? postId}) {
    emit(CraftGetPostCommentsUserLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId!)
        .collection('comments')
        .orderBy('date')
        .snapshots()
        .listen((value) {
      comments = [];
      usersComment = [];
      for (var element in value.docs) {
        comments!.add(CommentModel.fromJson(element.data()));
        usersComment!.add(specialUser![element.data()['userId']]!);
      }

      emit(CraftGetPostCommentsSuccessState());
    });
  }

  List<CraftUserModel>? usersComment = [];

  List notifications = [];
  CraftUserModel? notificationUserModel;

  giveSpecificUserNotification({
    required String? id,
  }) async {
    emit(CraftGetPostCommentsNotificationUserLoadingState());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      notificationUserModel = CraftUserModel.fromJson(value.data()!);
      //notifications!.add(CraftUserModel.fromJson(value.data()!));

      emit(CraftGetPostCommentsNotificationUserSuccessState());
    }).catchError((error) {
      emit(CraftGetPostCommentsNotificationUserErrorState(error.toString()));
    });
  }

  /*PostModel? notificationPostModel;

  getPostScreenFromNotification({required String? id}) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .get()
        .then((value) {
      notificationPostModel = PostModel.fromJson(value.data()!);
    }).catchError((error) {});
  }*/

  List<CraftUserModel>? notificationUsers = [];
  List<PostModel>? notificationPosts = [];

  Future<void> getNotifications() async {
    emit(CraftGetNotificationsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      notificationUsers = [];
      notificationPosts = [];
      for (var element in value.docs) {
        if (UserModel!.uId == element['uId']) {
          element.reference
              .collection('comments')
              .orderBy('date')
              .get()
              .then((val) {
            for (var el in val.docs) {
              if (UserModel!.uId != el['userId']) {
                notifications.add({
                  'userId': el['userId'],
                  'postId': el['postId'],
                });
                notificationUsers!.insert(0, specialUser![el['userId']]!);
                notificationPosts!.insert(
                    0,
                    posts!.firstWhere(
                        (element) => element.postId == el['postId']));

                // giveSpecificUserNotification(id: el['userId']);
              }
              emit(CraftGetNotificationsSuccessState());
            }
          }).catchError((error) {});
        }
      } //emit(CraftGetNotificationsSuccessState());
    }).catchError((error) {
      emit(CraftGetNotificationsErrorState());
    });
  }

  CraftUserModel? commentUserModel;

  giveSpecificUser({
    required String? id,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      commentUserModel = CraftUserModel.fromJson(value.data()!);
      emit(CraftGetPostCommentsUserSuccessState());
    }).catchError((error) {
      emit(CraftGetPostCommentsUserErrorState(error.toString()));
    });
  }

  void openPicker() async {
    FilePickerResult? result;

    result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      //allowedExtensions: ['jpg','png','webp','jpeg']
    );

    if (result != null) {
      print(result);
      var uploadFile = result.files.single.bytes!;

      String fileName = result.files.single.name;
      print('${fileName}+++++');

      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(const Uuid().v1() + '.png');

      final firebase_storage.UploadTask uploadTask =
          reference.putData(uploadFile);

      uploadTask.whenComplete(() async {
        String image = await uploadTask.snapshot.ref.getDownloadURL();
        print('${image}555');
      });
    }
  }

  var profileImage;

  Future getProfileImage() async {
    FilePickerResult? result;

    result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      //allowedExtensions: ['jpg','png','webp','jpeg']
    );

    if (result != null) {
      print(result);
      profileImage = result.files.single.bytes!;

      String fileName = result.files.single.name;
      print('${fileName}+++++');

      emit(CraftProfileImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image');
      }

      emit(CraftProfileImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String? name,
    required String? phone,
    String? bio,
    required String? address,
    required String? craftType,
  }) {
    emit(CraftUserUpdateLoadingState());

    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('users/' + const Uuid().v1() + '.png');

    final firebase_storage.UploadTask uploadTask =
        reference.putData(profileImage);

    uploadTask.whenComplete(() async {
      String profile = await uploadTask.snapshot.ref.getDownloadURL();
      print('${profile}555');

      updateUser(
        name: name,
        phone: phone,
        address: address,
        craftType: craftType,
        image: profile,
      );
      getUserData();

      emit(CraftUploadProfileImageSuccessState());
    });
  }

  String? workImage;

  Future getWorkImage() async {
    emit(CraftUploadWorkImageLoadingState());

    FilePickerResult? result;

    result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      //allowedExtensions: ['jpg','png','webp','jpeg']
    );

    if (result != null) {
      print(result);
      var uploadFile = result.files.single.bytes!;

      String fileName = result.files.single.name;
      print('${fileName}+++++');

      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('workGallery/' + const Uuid().v1() + '.png');

      final firebase_storage.UploadTask uploadTask =
          reference.putData(uploadFile);

      uploadTask.whenComplete(() async {
        workImage = await uploadTask.snapshot.ref.getDownloadURL();
        print('${workImage}555');

        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('workGallery')
            .add({
          'imageUrl': workImage,
          'dateTime': DateTime.now().toString(),
        }).then((value) {
          emit(CraftUploadWorkImageSuccessState());
        }).catchError((error) {
          emit(CraftUploadWorkImageErrorState());
        });
      });
    } else {
      emit(CraftUploadWorkImageErrorState());
    }
  }

  List<Map<String, String>> myWorkGallery = [];

  Future<void> getMyWorkImages() async {
    emit(CraftGetMyWorkImageLoadingState());

    myWorkGallery.clear();
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('workGallery')
        .orderBy('dateTime')
        .snapshots()
        .listen((value) {
      myWorkGallery = [];
      for (var element in value.docs) {
        myWorkGallery.add({
          'image': element['imageUrl'],
          'id': element.id,
        });

        if (kDebugMode) {
          print(element['imageUrl']);
        }
      }

      emit(CraftGetMyWorkImageSuccessState());

      // print('${value.docs.forEach((element) {element})}  ***********');
    });
  }

  List<Map> otherWorkGallery = [];

  Future<void> getOtherWorkImages({required String? id}) async {
    emit(CraftGetOtherWorkImageLoadingState());

    otherWorkGallery.clear();

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('workGallery')
        .get()
        .then((value) {
      otherWorkGallery = [];
      for (var element in value.docs) {
        otherWorkGallery.add({
          'image': element['imageUrl'],
          'id': element.id,
        });

        if (kDebugMode) {
          print(element['imageUrl']);
        }
      }

      emit(CraftGetOtherWorkImageSuccessState());
      // print('${value.docs.forEach((element) {element})}  ***********');
    }).catchError((error) {
      emit(CraftGetOtherWorkImageErrorState());
    });
  }

  List<String>? mySavedPostsId = [];
  List<PostModel>? mySavedPostsDetails = [];

  getMySavedPostsId() {
    emit(CraftGetSavedPostsLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('savedPosts')
        .snapshots()
        .listen((value) {
      mySavedPostsId = [];
      mySavedPostsDetails = [];
      for (var element in value.docs) {
        mySavedPostsId!.add(element.data()['postId']);
        mySavedPostsDetails!.add(specificPost![element.data()['postId']]!);
      }
      emit(CraftGetSavedPostsSuccessState());
    });
  }

  bool checkPostSaved({required String postId}) {
    if (mySavedPostsId!.any((element) => element == postId)) {
      return true;
    }
    return false;
  }

  void savePost({required String? postId}) {
    if (!mySavedPostsId!.any((element) => element == postId)) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('savedPosts')
          .doc(postId)
          .set({
        'postId': postId,
      }).then((value) {
        getMySavedPostsId();
        emit(CraftSavePostSuccessState());
      }).catchError((error) {
        emit(CraftSavePostErrorState());
      });
    } else {
      deleteSavedPost(postId: postId);
    }
  }

  void deleteSavedPost({required String? postId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('savedPosts')
        .doc(postId)
        .delete()
        .then((value) {
      getMySavedPostsId();
      emit(CraftDeleteSavePostSuccessState());
    }).catchError((error) {
      emit(CraftDeleteSavePostErrorState());
    });
  }

  void deleteImageFromWork({
    required String? id,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('workGallery')
        .doc(id)
        .delete()
        .then((value) {
      emit(CraftDeleteWorkImageSuccessState());
    }).catchError((error) {
      emit(CraftDeleteWorkImageErrorState());
    });
  }

/*
  Future<void> uploadWorkImage() async {
    emit(CraftUploadWorkImageLoadingState());

    */
/*firebase_storage.FirebaseStorage.instance
        .ref()
        .child('workGallery/${Uri.file(workImage!.path).pathSegments.last}')
        .putFile(workImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        if (kDebugMode) {
          print(value);
        }

        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('workGallery')
            .add({
          'imageUrl': value,
          'dateTime': DateTime.now().toString(),
        })
            .then((value) {
          emit(CraftUploadWorkImageSuccessState());
        }).catchError((error) {
          emit(CraftUploadWorkImageErrorState());
        });
      }).catchError((error) {
        emit(CraftUploadWorkImageErrorState());
      });
    }).catchError((error) {
      emit(CraftUploadWorkImageErrorState());
    });
    */ /*

  }
*/

  void updateUser({
    required String? name,
    required String? phone,
    required String? address,
    required String? craftType,
    String? image,
  }) {
    emit(CraftUserUpdateLoadingState());

    CraftUserModel model = CraftUserModel(
      name: name,
      phone: phone,
      craftType: craftType,
      address: address,
      email: UserModel!.email,
      uId: UserModel!.uId,
      userType: UserModel!.userType,
      image: image ?? UserModel!.image,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      emit(CraftUserUpdateSuccessState());
    }).catchError((error) {
      emit(CraftUserUpdateErrorState());
    });
  }

  List<CraftUserModel> users = [];
  Map<String, CraftUserModel>? specialUser = {};

  void getUsers() {
    emit(CraftGetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      users = [];
      specialUser = {};
      for (var element in value.docs) {
        if (element.data()['uId'] != UserModel!.uId) {
          users.add(CraftUserModel.fromJson(element.data()));
        }
        specialUser!.addAll(
            {element.data()['uId']: CraftUserModel.fromJson(element.data())});
      }
      getPosts();
      if (kDebugMode) {
        print(
            "${users.length}ssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
      }

      emit(CraftGetAllUsersSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(CraftGetAllUsersErrorState(error.toString()));
    });
  }

  List<CraftUserModel>? usersMessenger = [];

  void selectUserMessenger(String userId) {}

  void getUsersChatList() {
    emit(CraftGetAllUsersMessengerLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .orderBy('dateTime')
        .snapshots()
        .listen((value) {
      usersMessenger = [];
      print(uId);
      print(specialUser!.length);
      for (var item in value.docs) {
        usersMessenger!.insert(0, specialUser![item.id]!);
      }
      print(usersMessenger!.length);
      emit(CraftGetAllUsersMessengerSuccessState());
    });
  }

  List<MessageModel> messages = [];
  String currentMessage = '';

  enableMessageButton({required String message}) {
    currentMessage = message;
    emit(CraftEnableMessageButtonState());
  }

  unableMessageButton({required String message}) {
    currentMessage = '';
    emit(CraftUnableMessageButtonState());
  }

  void getMessage({
    required String receiverId,
  }) {
    messages.clear();
    emit(CraftGetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.insert(0, MessageModel.fromJson(element.data()));
        //    print (element.data());
      }

      emit(CraftGetMessageSuccessState());
    });
  }

  void sendMessage({
    required String receiverId,
    required String? dateTime,
    required String? text,
    String? messageImage,
  }) {
    MessageModel model = MessageModel(
      receiverId: receiverId,
      senderId: UserModel!.uId,
      dateTime: dateTime,
      text: text,
      messageImage: messageImage ?? '',
    );

    // set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(UserModel!.uId)
          .collection('chats')
          .doc(receiverId)
          .set({'dateTime': dateTime});
      emit(CraftSendMessageSuccessState());
    }).catchError((error) {
      emit(CraftSendMessageErrorState());
    });

    // set receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(UserModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(UserModel!.uId)
          .set({'dateTime': dateTime});

      emit(CraftSendMessageToOtherUserSuccessState());
    }).catchError((error) {
      emit(CraftSendMessageToOtherUserErrorState());
    });
  }

  var messageImageIndex = 0;
  var messageImage;

  Future getMessageImage() async {
    FilePickerResult? result;

    result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      //allowedExtensions: ['jpg','png','webp','jpeg']
    );

    if (result != null) {
      print(result);
      messageImage = result.files.single.bytes!;

      String fileName = result.files.single.name;
      print('${fileName}+++++');

      emit(CraftMessageImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image');

        emit(CraftMessageImagePickedErrorState());
      }

      // emit(CraftProfileImagePickedErrorState());
    }

    /*XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      if (kDebugMode) {
        print(pickedFile.path);
      }
      emit(CraftMessageImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image');
      }

      emit(CraftMessageImagePickedErrorState());
    }
    */
  }

  Future<void> uploadMessageImage({
    required String dateTime,
    required String text,
    required String? receiverId,
  }) async {
    emit(CraftUploadMessageImageLoadingState());

    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('messages/' + const Uuid().v1() + '.png');

    final firebase_storage.UploadTask uploadTask =
        reference.putData(messageImage);

    uploadTask.whenComplete(() async {
      String imagemessage = await uploadTask.snapshot.ref.getDownloadURL();
      print('${imagemessage}555');

      sendMessage(
        receiverId: receiverId!,
        dateTime: dateTime,
        text: text,
        messageImage: imagemessage,
      );
    });

/*


    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('messages/${Uri.file(messageImage!.path).pathSegments.last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {

        sendMessage(
          receiverId: receiverId!,
          dateTime: dateTime,
          text: text,
          messageImage: value,
        );
      }).catchError((error) {
        sendMessage(
          receiverId: receiverId!,
          dateTime: dateTime,
          text: text,
          messageImage: '',
        );
        emit(CraftUploadMessageImageErrorState());
      });
    }).catchError((error) {
      emit(CraftUploadMessageImageErrorState());
    });
*/

    //  messageImage = File('');
  }

  void writeSuggestion({
    required String? date,
    required String? content,
    required String? uId,
  }) async {
    emit(CraftWriteSuggestionLoadingState());

    await FirebaseFirestore.instance.collection('suggestions').add({
      'content': content,
      'date': date,
      'userId': uId,
    }).then((value) {
      emit(CraftWriteSuggestionSuccessState());
    }).catchError((error) {
      emit(CraftWriteSuggestionErrorState(error.toString()));
    });
  }

  List<PostModel>? search = [];

  void getSearch({required String? text}) async {
    emit(NewsSearchLoadingStates());

    FirebaseFirestore.instance.collection('posts').get().then((value) {
      search = [];
      for (var element in value.docs) {
        if (element['jobName'].toString().contains(text!) ||
            element['text'].toString().contains(text)) {
          search!.add(PostModel.fromJson(element.data()));

          emit(CraftSearchSuccessStates());
        }
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(CraftSearchErrorStates(error));
    });
  }

  void clearSearchList() {
    search!.clear();
    emit(CraftClearSearchListState());
  }

  void logOut() {
    emit(CraftLogoutLoadingState());

    FirebaseAuth.instance.signOut().then((value) {
      emit(CraftLogoutSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(CraftLogoutErrorState());
    });
  }

  String currentComment = '';

  enableCommentButton({required String comment}) {
    currentComment = comment;
    emit(CraftEnableCommentButtonState());
  }

  unableCommentButton({required String comment}) {
    currentComment = '';
    emit(CraftUnableCommentButtonState());
  }

  late Position cPosition;
  LocationPermission? locationPermission;

  checkIfLocationPermissionAllowed() async {
    locationPermission = await Geolocator.requestPermission().then((value) {
      getPosition();
      updateLocation();
      emit(CraftGetLocationSuccessState());
    }).catchError((error) {
      emit(CraftGetLocationErrorState(error.toString()));
    });

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission().then((value) {
        getPosition();
        updateLocation();
        emit(CraftGetLocationSuccessState());
      }).catchError((error) {
        emit(CraftGetLocationErrorState(error.toString()));
      });
    }
  }

  getPosition() async {
    cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    emit(CraftGetLocationSuccessState());
  }

  updateLocation() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
            {'longitude': cPosition.longitude, 'latitude': cPosition.latitude});
  }

  double? otherLat;
  double? otherLong;

  getOtherLocation({required String userId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      otherLat = value.data()!['latitude'];
      otherLong = value.data()!['longitude'];
    }).catchError((error) {});
  }

  Future<void> shareApp(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    ShareResult result;
    result = await Share.shareWithResult(
      'https://drive.google.com/file/d/14atgDPGciUKp6BoNSRhwwtyj7wv8DAjZ/view?usp=sharing \n\n قم بتحميل التطبيق الآن من خلال الرابط',
      subject: 'Craft-Up App',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
    if (result.status == ShareResultStatus.success) {
      emit(CraftSuccessShareAppState());
    } else if (result.status == ShareResultStatus.dismissed) {
      emit(CraftDismissedShareAppState());
    }
  }
}

/*
class CraftHomeCubit extends Cubit<CraftStates> {
  CraftHomeCubit() : super(CraftInitialState());

  static CraftHomeCubit get(context) => BlocProvider.of(context);

  CraftUserModel? UserModel;
  bool isCrafter = true;

  // FirebaseAuth.instance.currentUser!.uid
  void getUserData() {
    emit(CraftGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'uId'))
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      UserModel = CraftUserModel.fromJson(value.data()!);
      getUsers();
      if (kDebugMode) {
        print('${UserModel!.name} ++++++++');
        print('${UserModel!.uId} ++++++++');
      }

      if (UserModel!.userType!) {
        isCrafter = true;
        emit(CraftMakeIsCrafterTrueState());
      } else {
        isCrafter = false;
        emit(CraftMakeIsCrafterFalseState());
      }
      getMyWorkImages();
      //getNotifications();
      //getUsersChatList();
      emit(CraftGetUserSuccessState());
    }).catchError((error) {
      emit(CraftGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List crafterScreens = [
    FeedScreen(),
    // const NotificationsScreen(),
    const SavedPostsScreen(),
    SearchsScreen(),
    ProfileScreen(),
  ];

  List userScreens = [
    FeedScreen(),
    const NotificationsScreen(),
    //const SavedPostsScreen(),
    SearchsScreen(),
    ProfileScreen(),
  ];

  List<String> titles = const [
    'الرئيسية',
    'الإشعارات',
    'جديد',
    'المحفوظات',
    'البروفايل',
  ];


  void changeBottomNv(int index) {
    if (isCrafter && index == 1) {
      getMySavedPostsId();
    } else if (!isCrafter && index == 1) {
      getNotifications();
    } else if (isCrafter && index == 3) {
      getMyWorkImages();
    }
    currentIndex = index;
    emit(CraftChangeBottomNavState());
  }

  bool isEmpty = true;

  checkEmpty({
    required String text,
    required String name,
    required String location,
    required String salary,
  }) {
    if (text.isNotEmpty &&
        name.isNotEmpty &&
        location.isNotEmpty &&
        salary.isNotEmpty) {
      isEmpty = false;
      emit(CraftChangeIsEmptyState());
    } else {
      isEmpty = true;
      emit(CraftChangeIsEmptyState());
    }
  }

  void createPost({
    required String? dateTime,
    required String? text,
    required String? jobName,
    required String? location,
    required String? salary,
  }) {
    emit(CraftCreatePostLoadingState());

    PostModel model = PostModel(
      name: UserModel!.name,
      image: UserModel!.image,
      uId: UserModel!.uId,
      dateTime: dateTime,
      text: text,
      salary: salary,
      jobName: jobName,
      location: location,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      value.update({
        'postId': value.id,
      }).then((value) {
        getPosts();
      });
      emit(CraftCreatePostSuccessState());
    }).catchError((error) {
      emit(CraftCreatePostErrorState());
    });
  }

  List<PostModel>? posts = [];
  List<PostModel>? myPosts = [];
  Map<String, PostModel>? specificPost = {};
  List<CommentModel>? comments = [];

  List<PostModel> otherPosts = [];

  Future<void> getOtherPosts({
    required String userId,
  }) async {
    emit(CraftGetOtherPostLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) {
      otherPosts = [];
      print('+++++++ ${value}');

      for (var element in value.docs) {

        if(element.data()['uId'] == userId) {

          print('+++++++ ${value}');
          otherPosts.add(PostModel.fromJson(element.data()));
        }
      }

      emit(CraftGetOtherPostSuccessState());
    });
  }

  bool enableComment({required String text}) {
    if (text == '') {
      emit(CraftChangeCommentStateState());
      return false;
    } else {
      emit(CraftChangeCommentStateState());
      return true;
    }
  }

  void sendComment({
    required String? text,
    required String? postId,
    // required String?
  }) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'comment': text,
      'userId': uId,
      'date': DateTime.now().toString(),
      'postId': postId,
    }).then((value) {
      value.update({
        'commentId': value.id,
      });
      getComments(postId: postId);
      emit(CraftWriteCommentSuccessState());
    }).catchError((error) {
      emit(CraftWriteCommentErrorState(error.toString()));
    });
  }

  void getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      posts = [];
      myPosts = [];
      specificPost = {};
      for (var element in event.docs) {
        if (element.data()['uId'] == FirebaseAuth.instance.currentUser!.uid) {
          myPosts!.add(PostModel.fromJson(element.data()));
        }

        posts!.add(PostModel.fromJson(element.data()));

        specificPost!.addAll(
            {element.data()['postId']: PostModel.fromJson(element.data())});
      }

      getNotifications();
      getMySavedPostsId();

      emit(CraftGetPostSuccessState());
    });
  }

  Future<void> getComments({required String? postId}) async {
    comments = [];
    usersComment = [];
    emit(CraftGetPostCommentsUserLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('date')
        .get()
        .then((value) {
      print('************** Get Comments ***************');
      for (var element in value.docs) {
        comments!.add(CommentModel.fromJson(element.data()));
        usersComment!.add(specialUser![element.data()['userId']]!);
      }
      emit(CraftGetPostCommentsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CraftGetPostCommentsErrorState(error.toString()));
    });
  }

  List<CraftUserModel>? usersComment = [];

  List notifications = [];
  CraftUserModel? notificationUserModel;

  giveSpecificUserNotification({
    required String? id,
  }) async {
    emit(CraftGetPostCommentsNotificationUserLoadingState());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      notificationUserModel = CraftUserModel.fromJson(value.data()!);
      //notifications!.add(CraftUserModel.fromJson(value.data()!));

      emit(CraftGetPostCommentsNotificationUserSuccessState());
    }).catchError((error) {
      emit(CraftGetPostCommentsNotificationUserErrorState(error.toString()));
    });
  }

  PostModel? notificationPostModel;

  getPostScreenFromNotification({required String? id}) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .get()
        .then((value) {
      notificationPostModel = PostModel.fromJson(value.data()!);
    }).catchError((erro) {});
  }

  List<CraftUserModel>? notificationUsers = [];
  List<PostModel>? notificationPosts = [];

  Future<void> getNotifications() async {
    emit(CraftGetNotificationsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      notificationUsers = [];
      notificationPosts = [];
      for (var element in value.docs) {
        if (UserModel!.uId == element['uId']) {
          element.reference
              .collection('comments')
              .orderBy('date')
              .get()
              .then((val) {
            for (var el in val.docs) {
              if (UserModel!.uId != el['userId']) {
                notifications.add({
                  'userId': el['userId'],
                  'postId': el['postId'],
                });
                notificationUsers!.insert(0, specialUser![el['userId']]!);
                notificationPosts!.insert(
                    0,
                    posts!.firstWhere(
                        (element) => element.postId == el['postId']));

                // giveSpecificUserNotification(id: el['userId']);
              }
              emit(CraftGetNotificationsSuccessState());
            }
          }).catchError((error) {});

          //print('${element.data()} 3333333333' );
        }

        */
/* if (kDebugMode) {
            print('${element.data()} 3333333333' );
          }*/ /*

      } //emit(CraftGetNotificationsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CraftGetNotificationsErrorState());
    });
  }

  CraftUserModel? commentUserModel;

  giveSpecificUser({
    required String? id,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      commentUserModel = CraftUserModel.fromJson(value.data()!);
      emit(CraftGetPostCommentsUserSuccessState());
    }).catchError((error) {
      emit(CraftGetPostCommentsUserErrorState(error.toString()));
    });
  }

  File? profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      if (kDebugMode) {
        print(pickedFile.path);
      }
      emit(CraftProfileImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image');
      }

      emit(CraftProfileImagePickedErrorState());
    }
  }

  File? workImage;

  Future getWorkImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      workImage = File(pickedFile.path);
      if (kDebugMode) {
        print(pickedFile.path);
      }
      uploadWorkImage();
    } else {
      if (kDebugMode) {
        print('no image');
      }

      emit(CraftWorkImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String? name,
    required String? phone,
    String? bio,
    required String? address,
    required String? craftType,
  }) {
    emit(CraftUserUpdateLoadingState());

    firebase_staorage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        if (kDebugMode) {
          print(value);
        }
        updateUser(
          name: name,
          phone: phone,
          address: address,
          craftType: craftType,
          image: value,
        );
        getUserData();
        emit(CraftUploadProfileImageSuccessState());
      }).catchError((error) {
        emit(CraftUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(CraftUploadProfileImageErrorState());
    });
  }

  List<Map<String, String>> myWorkGallery = [];

  Future<void> getMyWorkImages() async {
    emit(CraftGetMyWorkImageLoadingState());

    myWorkGallery.clear();
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('workGallery')
        .orderBy('dateTime')
        .snapshots()
        .listen((value) {
      myWorkGallery = [];
      for (var element in value.docs) {
        myWorkGallery.add({
          'image': element['imageUrl'],
          'id': element.id,
        });

        if (kDebugMode) {
          print(element['imageUrl']);
        }
      }

      emit(CraftGetMyWorkImageSuccessState());

      // print('${value.docs.forEach((element) {element})}  ***********');
    });
  }

  List<Map> otherWorkGallery = [];

  Future<void> getOtherWorkImages({required String? id}) async {
    emit(CraftGetOtherWorkImageLoadingState());

    otherWorkGallery.clear();
    otherPosts.clear();

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('workGallery')
        .get()
        .then((value) {
      otherWorkGallery = [];
      for (var element in value.docs) {
        otherWorkGallery.add({
          'image': element['imageUrl'],
          'id': element.id,
        });

        if (kDebugMode) {
          print(element['imageUrl']);
        }
      }

      emit(CraftGetOtherWorkImageSuccessState());
      // print('${value.docs.forEach((element) {element})}  ***********');
    }).catchError((error) {
      emit(CraftGetOtherWorkImageErrorState());
    });
  }

  List<String>? mySavedPostsId = [];
  List<PostModel>? mySavedPostsDetails = [];

  getMySavedPostsId() {
    emit(CraftGetSavedPostsLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('savedPosts')
        .snapshots()
        .listen((value) {
      mySavedPostsId = [];
      mySavedPostsDetails = [];
      for (var element in value.docs) {
        mySavedPostsId!.add(element.data()['postId']);
        mySavedPostsDetails!.add(specificPost![element.data()['postId']]!);
      }
      emit(CraftGetSavedPostsSuccessState());
    });
  }

*/
/*
  Future<bool>? isSaved({
  required String? id,
})async{
     var a =  await FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .collection('savedPosts')
        .doc(id)
        .get();
    if(a.exists){
      print('Exists');
      return true;
    }
    if(!a.exists){
      print('Not exists');
      return false;
    }
  }
*/ /*

  bool checkPostSaved({required String postId}) {
    if (mySavedPostsId!.any((element) => element == postId)) {
      return true;
    }
    return false;
  }

  void savePost({required String? postId}) {
    if (!mySavedPostsId!.any((element) => element == postId)) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('savedPosts')
          .doc(postId)
          .set({
        'postId': postId,
      }).then((value) {
        getMySavedPostsId();
        emit(CraftSavePostSuccessState());
      }).catchError((error) {
        emit(CraftSavePostErrorState());
      });
    } else {
      deleteSavedPost(postId: postId);
    }
  }

  void deleteSavedPost({required String? postId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('savedPosts')
        .doc(postId)
        .delete()
        .then((value) {
      getMySavedPostsId();
      emit(CraftDeleteSavePostSuccessState());
    }).catchError((error) {
      emit(CraftDeleteSavePostErrorState());
    });
  }

  void deleteImageFromWork({
    required String? id,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('workGallery')
        .doc(id)
        .delete()
        .then((value) {
      emit(CraftDeleteWorkImageSuccessState());
    }).catchError((error) {
      emit(CraftDeleteWorkImageErrorState());
    });
  }

  Future<void> uploadWorkImage() async {
    emit(CraftUploadWorkImageLoadingState());

    firebase_staorage.FirebaseStorage.instance
        .ref()
        .child('workGallery/${Uri.file(workImage!.path).pathSegments.last}')
        .putFile(workImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        if (kDebugMode) {
          print(value);
        }
        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('workGallery')
            .add({
          'imageUrl': value,
          'dateTime': DateTime.now().toString(),
        }).then((value) {
          emit(CraftUploadWorkImageSuccessState());
        }).catchError((error) {
          emit(CraftUploadWorkImageErrorState());
        });
      }).catchError((error) {
        emit(CraftUploadWorkImageErrorState());
      });
    }).catchError((error) {
      emit(CraftUploadWorkImageErrorState());
    });
  }

  void updateUser({
    required String? name,
    required String? phone,
    required String? address,
    required String? craftType,
    String? image,
  }) {
    emit(CraftUserUpdateLoadingState());

    CraftUserModel model = CraftUserModel(
      name: name,
      phone: phone,
      craftType: craftType,
      address: address,
      email: UserModel!.email,
      uId: UserModel!.uId,
      userType: UserModel!.userType,
      image: image ?? UserModel!.image,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      emit(CraftUserUpdateSuccessState());
    }).catchError((error) {
      emit(CraftUserUpdateErrorState());
    });
  }

  List<CraftUserModel> users = [];
  Map<String, CraftUserModel>? specialUser = {};

  void getUsers() {
    users = [];
    emit(CraftGetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] != UserModel!.uId) {
          users.add(CraftUserModel.fromJson(element.data()));
        }
        specialUser!.addAll(
            {element.data()['uId']: CraftUserModel.fromJson(element.data())});
      }
      getPosts();
      if (kDebugMode) {
        print(
            "${users.length}ssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
      }

      emit(CraftGetAllUsersSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(CraftGetAllUsersErrorState(error.toString()));
    });
  }


  List<CraftUserModel>? usersMessenger = [];

  void selectUserMessenger(String userId) {}

  Future<void> getUsersChatList() async {

    emit(CraftGetAllUsersMessengerLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .orderBy('dateTime')
        .snapshots()
        .listen((value) {
      usersMessenger = [];
      for (var item in value.docs) {
        usersMessenger!.insert(0, specialUser![item.id]!);
        emit(CraftGetAllUsersMessengerSuccessState());
      }
    });
  }

  List<MessageModel> messages = [];
  String currentMessage = '';

  enableMessageButton({required String message}) {
    currentMessage = message;
    emit(CraftEnableMessageButtonState());
  }

  unableMessageButton({required String message}) {
    currentMessage = '';
    emit(CraftUnableMessageButtonState());
  }

  void getMessage({
    required String receiverId,
  }) {
    emit(CraftGetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      for (var element in event.docs) {
        messages.insert(0, MessageModel.fromJson(element.data()));
        //    print (element.data());
      }
      emit(CraftGetMessageSuccessState());
    });
  }

  void sendMessage({
    required String receiverId,
    required String? dateTime,
    required String? text,
    String? messageImage,
  }) {
    MessageModel model = MessageModel(
      receiverId: receiverId,
      senderId: UserModel!.uId,
      dateTime: dateTime,
      text: text,
      messageImage: messageImage ?? '',
    );

    // set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(UserModel!.uId)
          .collection('chats')
          .doc(receiverId)
          .set({'dateTime': dateTime});
      emit(CraftSendMessageSuccessState());
    }).catchError((error) {
      emit(CraftSendMessageErrorState());
    });

    // set receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(UserModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(UserModel!.uId)
          .set({'dateTime': dateTime});

      emit(CraftSendMessageToOtherUserSuccessState());
    }).catchError((error) {
      emit(CraftSendMessageToOtherUserErrorState());
    });
  }

  var messageImageIndex = 0;
  File? messageImage;

  Future getMessageImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      if (kDebugMode) {
        print(pickedFile.path);
      }
      emit(CraftMessageImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image');
      }

      emit(CraftMessageImagePickedErrorState());
    }
  }

  Future<void> uploadMessageImage({
    required String dateTime,
    required String text,
    required String? receiverId,
  }) async {
    emit(CraftUploadMessageImageLoadingState());

    firebase_staorage.FirebaseStorage.instance
        .ref()
        .child('messages/${Uri.file(messageImage!.path).pathSegments.last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //  emit(CraftUploadCoverImageSuccessState());
        //  print(value);
        sendMessage(
          receiverId: receiverId!,
          dateTime: dateTime,
          text: text,
          messageImage: value,
        );
      }).catchError((error) {
        sendMessage(
          receiverId: receiverId!,
          dateTime: dateTime,
          text: text,
          messageImage: '',
        );
        emit(CraftUploadMessageImageErrorState());
      });
    }).catchError((error) {
      emit(CraftUploadMessageImageErrorState());
    });

    //  messageImage = File('');
  }

  void writeSuggestion({
    required String? date,
    required String? content,
    required String? uId,
  }) async {
    emit(CraftWriteSuggestionLoadingState());

    await FirebaseFirestore.instance.collection('suggestions').add({
      'content': content,
      'date': date,
      'userId': uId,
    }).then((value) {
      emit(CraftWriteSuggestionSuccessState());
    }).catchError((error) {
      emit(CraftWriteSuggestionErrorState(error.toString()));
    });
  }

  List<PostModel>? search = [];

  void getSearch({required String? text}) async {
    search = [];
    emit(NewsSearchLoadingStates());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        if (element['jobName'].toString().contains(text!) ||
            element['text'].toString().contains(text)) {
          search!.add(PostModel.fromJson(element.data()));

          emit(CraftSearchSuccessStates());
        }
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(CraftSearchErrorStates(error));
    });
  }

  void clearSearchList() {
    search!.clear();
    emit(CraftClearSearchListState());
  }

  void logOut() {
    emit(CraftLogoutLoadingState());

    FirebaseAuth.instance.signOut().then((value) {
      emit(CraftLogoutSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(CraftLogoutErrorState());
    });
  }

  String currentComment = '';

  enableCommentButton({required String comment}) {
    currentComment = comment;
    emit(CraftEnableCommentButtonState());
  }

  unableCommentButton({required String comment}) {
    currentComment = '';
    emit(CraftUnableCommentButtonState());
  }

  late Position cPosition;
  LocationPermission? locationPermission;

  checkIfLocationPermissionAllowedd() async {
    locationPermission = await Geolocator.requestPermission().then((value) {
      getPositionn();
      updateLocation();
      emit(CraftGetLocationSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CraftGetLocationErrorState(error.toString()));
    });

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission().then((value) {
        getPositionn();
        updateLocation();
        emit(CraftGetLocationSuccessState());
      }).catchError((error) {
        emit(CraftGetLocationErrorState(error.toString()));
      });
    }
  }

  getPositionn() async {
    cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    emit(CraftGetLocationSuccessState());
  }

  updateLocation() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
            {'longitude': cPosition.longitude, 'latitude': cPosition.latitude});
  }

  double? otherLat;
  double? otherLong;

  getOtherLocation({required String userId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      otherLat = value.data()!['latitude'];
      otherLong = value.data()!['longitude'];
    }).catchError((error) {});
  }
}
*/
