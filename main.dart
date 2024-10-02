import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista de telas
  final List<Widget> _screens = [ContadorPage(), GameScreen()];

  // Função para alternar entre as telas
  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Fecha o Drawer após a seleção
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Projeto Contador' : 'Jogo da Velha'),
      ),
      body: _screens[_selectedIndex], // Exibe a tela selecionada
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.countertops),
              title: Text('Contador'),
              onTap: () => _onMenuItemSelected(0), // Seleciona a página do contador
            ),
            ListTile(
              leading: Icon(Icons.grid_view),
              title: Text('Jogo da Velha'),
              onTap: () => _onMenuItemSelected(1), // Seleciona a página do jogo da velha
            ),
          ],
        ),
      ),
    );
  }
}

// Código do Jogo da Velha
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

// Código do Contador
class ContadorPage extends StatefulWidget {
  @override
  _ContadorPageState createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {
  int count = 0;

  bool get isEmpty => count == 0;
  bool get isFull => count == 20;

  void increment() {
    setState(() {
      if (!isFull) {
        count++;
      }
    });
  }

  void decrement() {
    setState(() {
      if (!isEmpty) {
        count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projeto Contador'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Flutter-feature.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                isFull ? 'Lotado' : 'Pode entrar',
                style: TextStyle(
                  fontSize: 32,
                  color: isFull
                      ? Colors.red
                      : (count > 15 ? Colors.yellow : Colors.black),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                '$count',
                style: const TextStyle(fontSize: 100),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: isEmpty ? null : decrement,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow.withOpacity(
                        isEmpty ? 0.3 : 1.0), // Opacidade 30% quando desativado
                    fixedSize: const Size(100, 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Saiu',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 64),
                TextButton(
                  onPressed: isFull ? null : increment,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow.withOpacity(
                        isFull ? 0.3 : 1.0), // Opacidade 30% quando desativado
                    fixedSize: const Size(100, 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Entrou',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
