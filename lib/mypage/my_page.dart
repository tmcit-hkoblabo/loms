//import 'package:loms2/ble/ble_main.dart';
import 'dart:ffi';

import 'package:loms2/ble/ble_model.dart';
import 'package:loms2/edit_profile/edit_profile_page.dart';
import 'package:loms2/mypage/my_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('マイページ'),
          actions: [
            Consumer<MyModel>(builder: (context, model, child) {
              return IconButton(
                onPressed: () async {
                  // 画面遷移
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            //EditProfilePage(model.name!, model.description!),
                            EditProfilePage(
                                model.description.toString(),
                                model.furigana.toString(),
                                model.position.toString(),
                                model.number.toString(),
                                model.belong.toString())),
                  );
                  model.fetchUser();
                },
                icon: Icon(Icons.edit),
              );
            }),
          ],
        ),
        body: Center(
          child: Consumer<MyModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        model.name ?? '名前なし',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(model.email ?? 'メールアドレスなし'),
                      Text(model.position ?? '教員？学生？'),

                      if (model.position == '学生')
                        Text(model.number ?? '学生番号なし'),
                      if (model.position == '教員')
                        Text(model.belong ?? '所属学科なし'),

                      Text(
                        model.description ?? '自己紹介なし',
                      ),

                      Text(
                        model.status ?? '所在情報なし',
                      ),

                      Text(
                        model.ble ?? 'bleなし',
                      ),

                      //ここに所在情報も一旦表示させるようにする
                      TextButton(
                        onPressed: () async {
                          // ログアウト
                          await model.logout();
                          Navigator.of(context).pop();
                        },
                        child: Text('ログアウト'),
                      ),

                      /*
                      TextButton(
                        onPressed: () async {
                          // ログアウト
                          await model.scanBle();
                          Navigator.of(context).pop();
                        },
                        child: Text('BLE1'),
                      ),
                      */

                      TextButton(
                        onPressed: () async {
                          // ログアウト
                          //Array a = await model.scanDevices();
                          await model.scanDevices();
                          Navigator.of(context).pop();
                        },
                        child: Text('BLE0'),
                      ),

                      TextButton(
                        onPressed: () async {
                          // ログアウト

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlutterBlueApp(),
                              fullscreenDialog: true,
                            ),
                          );

                          //await model.scanDevices();
                        },
                        child: Text('BLE'),
                      ),
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
