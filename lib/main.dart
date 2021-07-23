import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  // User turn is true. If false, it's opponent's turn.
  bool isPlayerTurn = true;

  final tiles = List.generate(9, (_) => '');

  final winningTiles = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  /// Initial value is null. That means no winner.
  /// Winner can be "X" or "0"
  String? winner;

  void checkWinner({bool isOpponent = false}) {
    // Answer indexes eg. [0, 1, 2]
    for (final answerIndexes in winningTiles) {
      // E.g. First answer index 0 (first). Tiles element at 0 is "0"
      final first = tiles.elementAt(answerIndexes.first);
      // E.g. Middle answer index 1. Tiles element at 1 is "0"
      final middle = tiles.elementAt(answerIndexes[1]);
      // E.g. Last answer index 2 (last). Tiles element at 2 is "0"
      final last = tiles.elementAt(answerIndexes.last);

      // E.g. First("0") is equal to middle ("0") and
      // middle ("0") is equal to last ("0")
      // "0" == "0"  && "0" == "0"

      // We only show winner if none of the tiles are empty. This is because
      // if the all the tiles are empty, itch do will return true. Whies not
      // mean a winner.
      if (first == middle && middle == last && first.isNotEmpty) {
        // We have a winner!
        setState(() {
          winner = isOpponent ? 'O' : 'X';
        });
      }
    }
  }

  void opponentPlays() {
    // If there is a winner, the opponent can't play.
    if (winner != null) return;

    final index = Random().nextInt(9);
    if (tiles[index].isEmpty) {
      setState(() {
        tiles[index] = '0';
        isPlayerTurn = !isPlayerTurn;
      });
    } else {
      opponentPlays();
    }
    checkWinner(isOpponent: true);
  }

  @override
  Widget build(BuildContext context) {
    // Winner is not set at the start of the game. Thus null value.
    final haveWinner = winner != null;
    // Check if every tile is empty. Since every tile is empty, it will return true.
    // Therefore, we need to inverse the value.
    final haveStarted = !tiles.every((element) => element.isEmpty);

    // If every tile is not empty, and there is no winner, then it's a draw.
    final isDraw = tiles.every((element) => element.isNotEmpty);

    String playButtonText() {
      if (!haveStarted) {
        return startText;
      } else if (isDraw && !haveWinner) {
        return noWinnerText;
      } else if (haveWinner) {
        return gameOverText(winner!);
      } else {
        // This means we are in the middle of the game.
        return isPlayerTurn ? playerTurnText : opponentTurnText;
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tic - Tac - Toe',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontFamily: franchiseFont,
                  ),
            ),
            SizedBox(height: 20),
            GridView.count(
              padding: EdgeInsets.all(15),
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                tiles.length,
                (index) => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.primaries[index],
                    side: BorderSide(width: 2, color: Colors.black),
                    shape: BeveledRectangleBorder(),
                  ),
                  onPressed: () {
                    if (tiles[index].isNotEmpty || haveWinner || isDraw) return;
                    setState(() {
                      tiles[index] = 'X';
                      checkWinner();
                      isPlayerTurn = !isPlayerTurn;
                    });
                    opponentPlays();
                  },
                  child: Text(
                    tiles[index],
                    style: TextStyle(
                      fontSize: 110,
                      fontFamily: franchiseFont,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                if (haveWinner || isDraw) {
                  setState(() {
                    tiles.setAll(0, List.generate(tiles.length, (_) => ''));
                    winner = null;
                    isPlayerTurn = true;
                  });
                }
              },
              child: Text(
                playButtonText().toUpperCase(),
                textAlign: TextAlign.center,
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
                textStyle: TextStyle(
                  fontFamily: 'PressStart',
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const startText = "Press any box to start";
const franchiseFont = 'Franchise';
const playerTurnText = "Your turn";
const opponentTurnText = "Opponent's turn";
const noWinnerText = "It's a draw. \n \n Press here to play again";
String gameOverText(String winner) {
  return "Winner is $winner. \n \n Press here to play again";
}
