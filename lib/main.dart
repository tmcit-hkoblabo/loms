/*import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TMCIT-LoMS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
*/
/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loms2/authentication/auth_check.dart';
import 'package:loms2/top_page.dart';
import 'package:loms2/welcome_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthCheck(),
      child: MaterialApp(
        title: 'TMCIT LoMS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginCheck(),
        /*
        builder: (BuildContext context, Widget child) {
          return FlutterEasyLoading(child: child);
        },*/
      ),
    );
  }
}
*/
//class LoginCheck extends StatelessWidget {
//ここでまずログインしているかどうかの確認

//User? user;
//LoginCheck(this.user);

//const LoginCheck({Key? key, required this.user}) : super(key: key);
/*
  @override
  Widget build(BuildContext context) {
    //ここprovider使ってる↓
    final bool _loggedIn = context.watch<AuthCheck>().loggedIn;

    if (_loggedIn) {
      return TopPage();
    } else {
      return WelcomePage();
    }
  }
}
*/
/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMCIT LoMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RoutePage(),
    );
  }
}

class RoutePage extends StatefulWidget {
  @override
  RoutePageState createState() => RoutePageState();
}

class RoutePageState extends State<RoutePage> {
  //final AuthService _auth = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoggedin = false;
  @override
  void initState() {
    super.initState();
    print("Init state");
    _auth.signInWithPopup(provider).then((value) {
      if (value == 'null') {
        print(isLoggedin);
        setState(() {
          isLoggedin = false;
        });
      } else if (value != null) {
        setState(() {
          isLoggedin = true;
        });
      } else {
        setState(() {
          isLoggedin = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedin == true ? TopPage() : WelcomePage();
  }
}
*/

//NEW
import 'package:loms2/top/top_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMCIT LoMS',
      home: TopPage(),
    );
  }
}
