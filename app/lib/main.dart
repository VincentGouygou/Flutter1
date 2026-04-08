 
import 'package:flutter/material.dart';
import 'dart:async'; // <--- Permet d'utiliser le Timer
//import 'package:menu_bar/menu_bar.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App 1',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 60, 202, 24)),
      ),
      home:  const App1(title: 'Flutter App 1 '),
    );
  }
}

class App1 extends StatefulWidget {
  const App1({super.key, required this.title});
  
  final String title;
 
  @override
  State<App1> createState() => _App1State();
}

class _App1State extends State<App1> {
     bool _isConnected = false;
     String _name="Vincent";
     String _now = DateTime.now().toString().substring(11, 19);
    
  @override
  void initState() {
    super.initState();
    // 2. On lance un timer qui se répète toutes les secondes
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // 3. On met à jour l'heure et on dit à Flutter de "redessiner"
        _now = DateTime.now().toString().substring(11, 19);
      });
    });
  }
  void _functionA() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _isConnected = _isConnected ? false : true;
       
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: 
        AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the App1 object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Center( 
              child: Text(widget.title),            
            ),
          leadingWidth: 100,
          leading: Center(
              child: ElevatedButton(
                onPressed: _functionA, 
                
                child: _isConnected ? Text(_name) : Text('Login' ) ,
             
              ) 
            ),
          actions: <Widget> [
            Text(' $_now '),
            TextButton(onPressed: _App1State.new, child: const Text('fdfffg'))
          ],
        ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              ' ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: const Text("data"),
      ),
      
    );
  }
}
