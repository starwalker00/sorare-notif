import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

import 'notification.dart';

Future<void> main() async {
  await init();
  runApp(const MyApp());
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String currentToken = "undefined";

  List<String> titleList = <String>['titleStuck2', 'titleStuck1'];
  List<String> bodyList = <String>['bodyStuck2', 'bodyStuck1'];

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
    
    firebaseMessaging.tokenCtlr.stream.listen(_changeToken);
    firebaseMessaging.listCtlr.stream.listen(_addItemToList);

    super.initState();
  }

  _changeToken(String _token) => setState(() => currentToken = _token);

  void addItemToList(String _title, String _body){
    setState(() {
      titleList.insert(0,_title);
      bodyList.insert(0,_body);
    });
  }

  _addItemToList(List<String> notification) => setState(() => addItemToList(notification[0], notification[1]));
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_alert),
              tooltip: 'Show Snackbar',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: currentToken));
                final snackBar = SnackBar(content: Text('Token copied.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            )],
          ),
        body: Center(child:_buildList())
      );
  }

  Widget _buildList() {
      return Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: titleList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(child: _tile(titleList[index], bodyList[index]))
            );
          }
        ),
      );
  }

  ListTile _tile(String title, String body) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(body),
      leading: Icon(
        Icons.theaters,
        color: Colors.blue[500],
      ),
    );
  }

}
