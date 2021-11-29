//ESPからの電波受信
//受信した電波の選別（学内ESPに絞る→電波強度順に並べる→最も電波強度の強い電波を現在位置とする）
//所在情報の送信(firestoreを用いる、現在位置・更新時刻・送信端末)
//page(受信中の電波を一覧表示、絞った学内BLEを電波強度とともに一覧表示、最も強い電波を表示)
//model(周辺を飛ぶBLEの電波を受信、受信した電波から学内BLEの電波だけを抜き取る、それぞれのBLEの電波強度を比較して最も強いものを選抜、その電波が示す所在を取得、取得情報をFirestoreに送信)
/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loms2/login/login_model.dart';
//import 'package:loms2/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
*/
// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:loms2/ble/ble_sample.dart';

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

//ここで検索をかける
//トップページ
class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBlue.instance
            .startScan(timeout: Duration(seconds: 4)), //引っ張って再読み込み
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return ElevatedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceScreen(device: d))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .where((r) => r.device.name.contains('5F_East_3'))
                      //.firstWhere((r) => r.device.name.contains('5F_East_3'))
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                        ),
                      )
                      .toList(),
                ),
              ),
              /*
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
              */
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

//デバイス接続時の画面と挙動
class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      await c.write(_getRandomBytes(), withoutResponse: true);
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data! ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
class BlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  Title for the screen
      appBar: AppBar(
        title: Text('Find Devices'),
      ),

      body: RefreshIndicator(
        //  Start scanning for Bluetooth LE devices
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),

        //  List of Bluetooth LE devices
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],

                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        //  For each Bluetooth LE device, show the ScanResultTile widget when tapped
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              );
  }
}

//Googleアカウントでログインさせる
class SignInOnGoogle extends StatelessWidget {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Googleアカウントでサインイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              text: 'Sign In with Google',
              onPressed: () async {
                GoogleSignInAccount? signinAccount = await googleLogin.signIn();
                if (signinAccount == null) return;
                GoogleSignInAuthentication auth =
                    await signinAccount.authentication;
                final OAuthCredential credential =
                    GoogleAuthProvider.credential(
                  idToken: auth.idToken,
                  accessToken: auth.accessToken,
                );
                User? user = (await FirebaseAuth.instance
                        .signInWithCredential(credential))
                    .user;
                if (user != null) {
                  await Navigator.of(context).pushReplacement(
                      //await Navigator.push(
                      //context,

                      MaterialPageRoute(builder: (context) {
                    //return LogoutPage(user);
                    return LoginPage(user);
                  }));
                  /*
                      MaterialPageRoute(
                        builder: (context) =>
                            TopPage(user_name: user.displayName),
                      ));
                      */
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

//必要情報を入力させ、Firestoreに登録する
class LoginPage extends StatelessWidget {
  final User user;
  LoginPage(this.user);
  //LoginCompletion(this.user);

  static final googleLogin = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('必要情報の入力'),
        ),
        body: Center(
          child: Consumer<LoginModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Googleアカウントによる認証が完了しました。'),
                      Text('ようこそ！${user.displayName}さん'),
                      Text('必要情報の入力をお願いします。'),
                      /*
                      TextField(
                        controller: model.titleController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (text) {
                          model.setEmail(text);
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: model.authorController,
                        decoration: InputDecoration(
                          hintText: 'パスワード',
                        ),
                        onChanged: (text) {
                          model.setPassword(text);
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      */
                      TextField(
                        controller: model.furiganaController,
                        decoration: InputDecoration(
                          hintText: 'ふりがな',
                        ),
                        onChanged: (text) {
                          model.setFurigana(text);
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: model.positionController,
                        decoration: InputDecoration(
                          hintText: '教員or学生',
                        ),
                        onChanged: (text) {
                          model.setPosition(text);
                        },
                        //obscureText: true,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      if (model.position == '学生')
                        TextField(
                          controller: model.numberController,
                          decoration: InputDecoration(
                            hintText: '学生番号',
                          ),
                          onChanged: (text) {
                            model.setNumber(text);
                          },
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      if (model.position == '教員')
                        TextField(
                          controller: model.belongController,
                          decoration: InputDecoration(
                            hintText: '所属学科',
                          ),
                          onChanged: (text) {
                            model.setBelong(text);
                          },
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          model.name = user.displayName;
                          model.email = user.email;
                          model.uid = user.uid;
                          model.image = user.photoURL;

                          model.setBleLocation();
                          //model.setStatus();
                          model.startLoading();
                          // 追加の処理
                          try {
                            //await model.addMyData();
                            await model.addMyData();
                            Navigator.of(context).pop();
                          } catch (e) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } finally {
                            model.endLoading();
                          }
                        },
                        child: Text('ログイン'),
                      ),
                      /*
                      TextButton(
                        onPressed: () async {
                          // 画面遷移
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: Text('新規登録の方はこちら'),
                      ),
                      */
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
*/
