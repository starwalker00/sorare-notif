import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
  List<String> titleList = <String>['titleStuck2', 'titleStuck1'];
  List<String> bodyList = <String>['bodyStuck2', 'bodyStuck1'];
  // String notificationTitle = 'No Title';
  // String notificationBody = 'No Body';
  // String notificationData = 'No Data';

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
    
    // firebaseMessaging.streamCtlr.stream.listen(_changeData);
    // firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.listCtlr.stream.listen(_addItemToList);
    
    super.initState();
  }

  void addItemToList(String _title, String _body){
    setState(() {
      titleList.insert(0,_title);
      bodyList.insert(0,_body);
    });
  }

  // _changeData(String msg) => setState(() => addItemToList(msg));
  // _changeBody(String msg) => setState(() => addItemToList(msg));
  _addItemToList(List<String> notification) => setState(() => addItemToList(notification[0], notification[1]));

  // _changeData(String msg) => setState(() => notificationData = msg);
  // _changeBody(String msg) => setState(() => notificationBody = msg);
  // _changeTitle(String msg) => setState(() => notificationTitle = msg);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: Center(child:_buildList()),
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           notificationTitle,
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //         Text(
    //           notificationBody,
    //           style: Theme.of(context).textTheme.headline6,
    //         ),
    //         Text(
    //           notificationData,
    //           style: Theme.of(context).textTheme.headline6,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
  // #docregion list
  Widget _buildList() {
    // return ListView(
    //   children: [
    //     _tile('CineArts at the Empire', '85 W Portal Ave'),
    //   ],
    // );
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
