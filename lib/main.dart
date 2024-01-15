import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late bool _gameOver;
  late String? _winner;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    _board = List.generate(3, (_) => List.filled(3, ''));
    _currentPlayer = 'X';
    _gameOver = false;
    _winner = null;
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] == '' && !_gameOver) {
      setState(() {
        _board[row][col] = _currentPlayer;
        checkTest();
        _checkWinner();
        _togglePlayer();
      });
    }
  }

  void _togglePlayer() {
    _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';
  }

  void _checkWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _currentPlayer &&
          _board[i][1] == _currentPlayer &&
          _board[i][2] == _currentPlayer) {
        _endGame(_currentPlayer);
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_board[0][i] == _currentPlayer &&
          _board[1][i] == _currentPlayer &&
          _board[2][i] == _currentPlayer) {
        _endGame(_currentPlayer);
      }
    }

    // Check diagonals
    if (_board[0][0] == _currentPlayer &&
        _board[1][1] == _currentPlayer &&
        _board[2][2] == _currentPlayer) {
      _endGame(_currentPlayer);
    }

    if (_board[0][2] == _currentPlayer &&
        _board[1][1] == _currentPlayer &&
        _board[2][0] == _currentPlayer) {
      _endGame(_currentPlayer);
    }

    // Check for a draw
    if (!_board.any((row) => row.any((cell) => cell == '')) && !_gameOver) {
      _endGame(null); // Draw
    }
  }
  void checkTest() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 2; j++) {
        if (_board[i][j + 1] != '' && _board[i][j] != '') {
          reboard(i, j, i, j + 1);
        }
      }
    }
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i + 1][j] != '' && _board[i][j] != '') {
          reboard(i, j, i + 1, j);
        }
      }
    }
  }
  
   void reboard(int row1, int col1, int row2, int col2) {
    setState(() {
      _board[row1][col1] = '';
      _board[row2][col2] = '';
    });
  }

  void _endGame(String? winner) {
  setState(() {
    _gameOver = true;
    _winner = winner;
  });
}

  void _restartGame() {
    setState(() {
      _initializeBoard();
    });
  }

  Widget _buildCell(int row, int col) {
    return GestureDetector(
      onTap: () => _makeMove(row, col),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            _board[row][col],
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCell(0, 0),
                    _buildCell(0, 1),
                    _buildCell(0, 2),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCell(1, 0),
                    _buildCell(1, 1),
                    _buildCell(1, 2),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCell(2, 0),
                    _buildCell(2, 1),
                    _buildCell(2, 2),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_gameOver)
              Text(
                _winner != null ? 'Winner: $_winner' : 'It\'s a Draw!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ElevatedButton(
              onPressed: _restartGame,
              child: Text('Restart Game'),
            ),
            
          ],
        ),
      ),
    );
  }
}
