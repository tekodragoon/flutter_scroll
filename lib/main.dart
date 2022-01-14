import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Scroll',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Scroll Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Activity> activities = [
    Activity("Vélo", Icons.directions_bike),
    Activity("Théatre", Icons.theater_comedy),
    Activity("Football", Icons.sports_football_rounded),
    Activity("Restaurant", Icons.dinner_dining),
    Activity("Peinture", Icons.brush),
    Activity("Golf", Icons.golf_course),
    Activity("Arcade", Icons.gamepad),
    Activity("Bricolage", Icons.build),
    Activity("Shopping", Icons.shopping_cart),
    Activity('Social', Icons.messenger)
  ];



  @override
  Widget build(BuildContext context) {

    Orientation deviceOrientation = MediaQuery.of(context).orientation;
    print('orientation: $deviceOrientation');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
          child: (deviceOrientation == Orientation.portrait) ? listView() : gridView()
      ),
    );
  }

  Widget gridView() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemCount: activities.length,
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.all(2.0),
            child: Card(
              elevation: 10.0,
              child: InkWell(
                onTap: () {
                  print('tapped');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Activité',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                    Icon(
                      activities[i].icon,
                      size: 40.0,
                      color: Colors.deepOrange,
                    ),
                    Text(
                      activities[i].name,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]
                )
              )
            ),
          );
        }
    );
  }

  Widget listView() {
    return ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, i) {
          Activity currentActivity = activities[i];
          String key = currentActivity.name;
          return Dismissible(
              key: Key(key),
              child: Container(
                padding: EdgeInsets.all(10.0),
                height: 125.0,
                child: InkWell(
                  onTap: () {
                    print("tapped");
                  },
                  child: Card(
                    elevation: 8.0,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.only(right: 20.0)),
                          Icon(
                            currentActivity.icon,
                            size: 75.0,
                            color: Colors.deepOrange[200],
                          ),
                          VerticalDivider(
                            width: 30.0,
                            thickness: 2.0,
                            color: Colors.deepOrange,
                            indent: 20.0,
                            endIndent: 20.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Activité',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic
                                ),
                              ),
                              Text(
                                currentActivity.name,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              /* exemple de base avec ListTile
                  ListTile(
                    title: Text(currentActivity.name),
                    trailing: Icon(currentActivity.icon),
                    leading: Icon(currentActivity.icon),
                  ),
                  */
              background: Container(
                padding: EdgeInsets.only(left: 10.0),
                color: Colors.orange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 60.0,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              secondaryBackground: Container(
                padding: EdgeInsets.only(left: 10.0),
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.delete,
                      size: 60.0,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                if(direction == DismissDirection.endToStart) {
                  setState(() {
                    activities.removeAt(i);
                  });
                  return true;
                } else {
                  return await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext diagCxt) {
                        return AlertDialog(
                          title: Text('EDIT'),
                          content: Text('Edition'),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(diagCxt).pop(false);
                                },
                                child: Text('OK'))
                          ],
                        );
                      }
                  );
                }
              }
          );
        });
  }
}

class Activity {
  String name;
  IconData icon;

  Activity(String _name, IconData _icon) {
    name = _name;
    icon = _icon;
  }
}