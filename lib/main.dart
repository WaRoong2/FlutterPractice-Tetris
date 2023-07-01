import 'package:flutter/material.dart';
import 'package:tetris/tetris_app.dart';
import 'package:tetris/dev_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/tetrisMenuBackground.png'),fit: BoxFit.fill),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.15),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(MediaQuery.of(context).size.width * 0.04)),
                    backgroundColor:  MaterialStateProperty.all<Color>(Colors.blue),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.black),
                    splashFactory: NoSplash.splashFactory,
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05))
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return TetrisGame();
                      }),
                    );
                  },
                  child: const Text('Game Start'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.05),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(MediaQuery.of(context).size.width * 0.04)),
                      backgroundColor:  MaterialStateProperty.all<Color>(Colors.blue),
                      overlayColor: MaterialStateProperty.all<Color>(Colors.black),
                      splashFactory: NoSplash.splashFactory,
                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05))
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return InfoScreen();
                      }),
                    );
                  },
                  child: const Text('Developer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}