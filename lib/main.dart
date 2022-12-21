import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_rps_game/game_object.dart';
import 'package:simple_rps_game/player.dart';

void main() {
  runApp(const Game());
}

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Simple RPS Game',
      home: GameView(),
    );
  }
}

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final Player _player = Player();
  final Player _ai = Player();

  void _rollGame(GameObject playerSelection) {
    setState(() {
      _player.selection = playerSelection;
      _ai.selection =
          GameObject.values[Random().nextInt(GameObject.values.length)];
    });
  }

  String _showAiSelection() {
    if (_ai.selection == null) return '';
    return 'AI chooses ${_ai.selection.toString().split('.').last.toUpperCase()}';
  }

  int _checkPlayerState() {
    int playerValue = GameObject.values.indexOf(_player.selection!);
    int aiValue = GameObject.values.indexOf(_ai.selection!);

    if (playerValue == aiValue) return 2;
    if (playerValue == 2 && aiValue == 1 ||
        playerValue == 1 && aiValue == 0 ||
        playerValue == 0 && aiValue == 2) return 1;
    return 0;
  }

  String _showPlayerState() {
    if (_player.selection == null) return 'Choose!';
    if (_checkPlayerState() == 0) {
      return 'YOU LOSE!';
    } else if (_checkPlayerState() == 1) {
      return 'YOU WIN!';
    } else {
      return 'TIE!';
    }
  }

  MaterialColor _getSelectionButtonColor(int buttonIndex) {
    if (_player.selection != null && _ai.selection != null) {
      GameObject? playerSelection = _player.selection;
      GameObject? aiSelection = _ai.selection;

      if (buttonIndex == GameObject.values.indexOf(playerSelection!) &&
          buttonIndex == GameObject.values.indexOf(aiSelection!)) {
        return Colors.purple;
      }
      if (buttonIndex == GameObject.values.indexOf(playerSelection)) {
        return Colors.green;
      }
      if (buttonIndex == GameObject.values.indexOf(aiSelection!)) {
        return Colors.red;
      }
    }

    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rock Paper Scissor'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _showPlayerState(),
              style: const TextStyle(fontSize: 28.0),
            ),
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _showAiSelection(),
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _rollGame(GameObject.values[index]);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    _getSelectionButtonColor(index))),
                            child: Text(
                                GameObject.values[index]
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase(),
                                style: const TextStyle(fontSize: 18.0)),
                          ),
                        )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
