import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToe());
}

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = ['', '', '', '', '', '', '', '', ''];
  bool xTurn = true;
  String currentPlayer = "X";
  int xWins = 0;
  int oWins = 0;
  final int winningScore = 9;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jogo da Velha"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Jogador atual: $currentPlayer',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          // Placar de vitórias
          Text(
            'Placar: X: $xWins - O: $oWins',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _markBoard(index);
                  },
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(
                          color: board[index] == "X"
                              ? Colors.red
                              : board[index] == "O"
                                  ? Colors.blue
                                  : Colors.black,
                          fontSize: 48,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text("Reiniciar o jogo"),
          ),
        ],
      ),
    );
  }

  void _markBoard(int index) {
    if (board[index] == '') {
      setState(() {
        board[index] = xTurn ? "X" : "O";
        xTurn = !xTurn;
        currentPlayer = xTurn ? "X" : "O";
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    // Todas as combinações possíveis de vitória
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      String a = board[pattern[0]];
      String b = board[pattern[1]];
      String c = board[pattern[2]];

      if (a == b && b == c && a != '') {
        _showWinnerDialog(a);
        if (a == 'X') {
          xWins++;
          if (xWins == winningScore) {
            _showGameWinnerDialog('X');
          }
        } else {
          oWins++;
          if (oWins == winningScore) {
            _showGameWinnerDialog('O');
          }
        }
        return;
      }
    }

    if (!board.contains('')) {
      _showDrawDialog();
    }
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vitória!'),
        content: Text('$winner ganhou esta rodada!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetBoard();
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Empate!'),
        content: Text('Ninguém ganhou esta rodada.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetBoard();
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  void _showGameWinnerDialog(String gameWinner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vencedor do jogo!'),
        content: Text('$gameWinner venceu o jogo com 9 vitórias!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  void _resetBoard() {
    setState(() {
      board = ['', '', '', '', '', '', '', '', ''];
      xTurn = true;
      currentPlayer = "X";
    });
  }

  void _resetGame() {
    setState(() {
      xWins = 0;
      oWins = 0;
      _resetBoard();
    });
  }
}
