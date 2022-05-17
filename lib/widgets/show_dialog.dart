import 'package:flutter/material.dart';
import 'package:my_graduation/bloc/home_cubit.dart';

 dialog(context,title,content) {

   showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(

      title: Text(
        title,
        style:const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
        textAlign: TextAlign.right,
      ),
      content:content,
      actions: [


        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child:const Text('الرجوع'))
      ],
    ),
  );
}

logUotDialog(context,CraftHomeCubit cubit) {

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>  Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(
              fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'هل أنت متأكد أنك تريد تسجيل الخروج؟',
          style: TextStyle(
              fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          ),
          TextButton(
            onPressed: () {
              cubit.logOut();
              Navigator.pop(context);
            },
            child: const Text('خروج', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    ),
  );
}

deleteImageDialog(context,cubit,uid) {

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>  Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text(
          'تأكيد',
          style: TextStyle(
              fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'هل أنت متأكد أنك تريد حذف هذه الصورة؟',
          style: TextStyle(
              fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteImageFromWork(id: uid);
              Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    ),
  );
}
