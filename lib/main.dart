import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ColorGame(),
    );
  }
}

class ColorGame extends StatefulWidget {
  @override
  _ColorGameState createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {
  final Map<String, bool> score = {};
  final Map choices = {
    '🍏': Colors.green,
    '🍋': Colors.yellow,
    '🍅': Colors.red[800],
    '🍇': Colors.purple,
    '🥥': Colors.brown,
    '🥕': Colors.orange[700]
  };
  int seed = 0;
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  // ignore: non_constant_identifier_names
  Alert() {
    return scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 40),
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(50)),
                height: 50,
                child: Center(
                    child: Text(
                      "You Win 🎉", //waiting upload
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ))),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Score',
              style: TextStyle(color: Colors.blue, fontSize: 25,),
            ),
            Text('  ${score.length} / 6',style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 25,

            ),),
            SizedBox(
              width: 1,
            )
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text(
                  score.length == 6 ? 'New Game' : 'Refresh',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                score.length == 6
                    ? Text('')
                    : Icon(
                        Icons.refresh,
                        size: 20,
                      ),
              ],
            ),
            onPressed: () {
              if(score.length == 6){
                Alert();
              }
              setState(() {
                score.clear();
                seed++;

              });
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: choices.keys.map((emoji) {
                return Draggable<String>(
                  data: emoji,
                  child: Emoji(emoji: score[emoji] == true ? '🌳' : emoji),
                  feedback: Emoji(
                    emoji: emoji,
                  ),
                  childWhenDragging: Emoji(
                    emoji: '❓',
                  ),
                );
              }).toList()),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                choices.keys.map((emoji) => _buildDragTarget(emoji)).toList()
                  ..shuffle(Random(seed)),
          )
        ],
      ),
    );
  }

  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
      // ignore: missing_return
      builder: (BuildContext context, List<String> incoming, List rejected) {
        if (score[emoji] == true) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: choices[emoji], width: 3),
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: Text(
              '✔',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            alignment: Alignment.center,
            height: 80,
            width: MediaQuery.of(context).size.width/2,
          );
        } else {
          return Container(
            decoration:
                BoxDecoration(color: choices[emoji], shape: BoxShape.circle),
            height: 80,
            width: MediaQuery.of(context).size.width/2,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
        });
      },
      onLeave: (data) {},
    );
  }
}

class Emoji extends StatelessWidget {
  Emoji({Key key, this.emoji}) : super(key: key);
  final String emoji;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 80,
        width: MediaQuery.of(context).size.width/2,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 50),
        ),
      ),
    );
  }
}
