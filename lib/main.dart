import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';

void main() {
  runApp(TetrisApp());
}

class TetrisApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TetrisGame(),
    );
  }
}

class TetrisGame extends StatefulWidget {

  @override
  _TetrisGameState createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  final int rows = 20;
  final int columns = 10;
  final double squareSize = 20.0;
  List<List<int>> grid = [];
  List<Color> colors = [
    Colors.cyan,
    Colors.yellow,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.blue,
  ];
  late Timer timer;
  int dueTime = 800;
  int score = 0;
  int level = 1;
  List<List<int>> currentPiece = [];
  int currentPieceRow = 0;
  int currentPieceColumn = 0;
  Color currentPieceColor = Colors.black;
  int semaphore = 1;

  @override
  void initState() {
    super.initState();
    initializeGrid();
    spawnPiece();
    startTimer();
  }

  void initializeGrid() {  // 그리드(판) 생성
    grid = List.generate(rows, (_) => List.generate(columns, (_) => 0));
  }

  void startTimer() {  // 타이머 돌아감
    timer = Timer.periodic(Duration(milliseconds: dueTime), (timer) {
      proceedGame();
    });
  }

  void proceedGame() {  // 게임 진행
    if ( !updateGrid() ) {  // 블럭 움직이는 함수 실행 후, 움직임 없으면
      checkLines();         // 줄 체크 & 지우기
      checkGameOver();      // 게임 오버 체크
      spawnPiece();         // 이상 없으면 블럭 생성
    }
  }

  void spawnPiece() {  //블럭 생성
    final shape = [
      [
        [1, 1],   //ㅁ
        [1, 1],
      ],
      [
        [1, 1, 1, 1],  //ㅡ
      ],
      [
        [1, 1, 1],  // ㄱ
        [0, 0, 1],
      ],
      [
        [1, 1, 1],  // flip ㄱ
        [1, 0, 0],
      ],
      [
        [1, 1, 1],  // ㅜ
        [0, 1, 0],
      ],
      [
        [1, 1, 0],  // ㄹ
        [0, 1, 1],
      ],
      [
        [0, 1, 1],  // flip ㄹ
        [1, 1, 0],
      ],
    ];
    currentPiece = shape[Random().nextInt(7)];
    currentPieceColor = colors[Random().nextInt(7)];
    currentPieceRow = 0;
    currentPieceColumn = (columns / 2 - currentPiece[0].length / 2).floor();  // 블럭 가장 왼쪽 기준
    for (int i = currentPieceRow; i < currentPieceRow + currentPiece.length; i++){
      for (int j = currentPieceColumn; j < currentPieceColumn + currentPiece[0].length; j++) {
        if (currentPiece[i-currentPieceRow][j-currentPieceColumn]==1) {
          grid[i][j] = 1;
        }
      }
    }
  }

  void wait(){
    while(semaphore<1) {}
    semaphore--;
  }

  void signal(){
    semaphore++;
  }

  void moveLeft() {
    bool keepMove = true;
    if (currentPieceColumn > 0) {
      wait();
      setState(() {
        // 조건 확인
        for (int i = currentPieceRow; i < currentPieceRow+currentPiece.length; i++){
          for (int j = currentPieceColumn; j < currentPieceColumn+currentPiece[0].length; j++) {
            // 기존의 블럭에 현재 블럭이 겹치면서 막힐 때
            if (j < currentPieceColumn+currentPiece[0].length-1 && currentPiece[i-currentPieceRow][j-currentPieceColumn]==0 && currentPiece[i-currentPieceRow][j-currentPieceColumn+1]==1 && grid[i][j]==1) {
              keepMove = false;
              break;
            }
            // 기존의 블럭에 안 겹치면서 막힐 때
            if (j == currentPieceColumn && currentPiece[i-currentPieceRow][j-currentPieceColumn]==1 && grid[i][j-1]==1) {
              keepMove = false;
              break;
            }
          }
          if (!keepMove){
            break;
          }
        }
        // 이동
        if (keepMove) {
          for (int i = currentPieceRow; i < currentPieceRow+currentPiece.length; i++){
            for (int j = currentPieceColumn; j < currentPieceColumn+currentPiece[0].length; j++) {
              if(grid[i][j]==1 && currentPiece[i-currentPieceRow][j-currentPieceColumn]==1) {
                grid[i][j] = 0;
                grid[i][j-1] = 1;
              }
            }
          }
          currentPieceColumn--;
        }
      });
      signal();
    }
  }

  void moveRight() {
    bool keepMove = true;
    if (currentPieceColumn + currentPiece[0].length < columns) {
      wait();
      setState(() {
        // 조건 확인
        for (int i = currentPieceRow; i < currentPieceRow+currentPiece.length; i++){
          for (int j = currentPieceColumn; j < currentPieceColumn+currentPiece[0].length; j++) {
            // 기존의 블럭에 현재 블럭이 겹치면서 막힐 때
            if (j>currentPieceColumn && currentPiece[i-currentPieceRow][j-currentPieceColumn]==0 && currentPiece[i-currentPieceRow][j-currentPieceColumn-1]==1 && grid[i][j]==1) {
              keepMove = false;
              break;
            }
            // 기존의 블럭에 안 겹치면서 막힐 때
            if (j == currentPieceColumn+currentPiece[0].length-1 && currentPiece[i-currentPieceRow][j-currentPieceColumn]==1 && grid[i][j+1]==1) {
              keepMove = false;
              break;
            }
          }
          if (!keepMove){
            break;
          }
        }
        // 이동
        if (keepMove) {
          for (int i = currentPieceRow; i < currentPieceRow+currentPiece.length; i++){
            for (int j = currentPieceColumn+currentPiece[0].length; j > currentPieceColumn-1; j--) {
              if(grid[i][j]==1 && currentPiece[i-currentPieceRow][j-currentPieceColumn]==1) {
                grid[i][j] = 0;
                grid[i][j+1] = 1;
              }
            }
          }
          currentPieceColumn++;
        }
      });
      signal();
    }
  }

  void rotatePiece() {
    bool keepRotate = true;
    wait();
    setState(() {
      // 돌아간 블럭 만들기
      List<List<int>> newPiece = [];
      int newRowLength = currentPiece[0].length;
      int newColumnLength = currentPiece.length;

      for (int i = 0; i < newRowLength; i++) {
        newPiece.add(List.filled(newColumnLength, 0));
      }

      for (int i = 0; i < currentPiece.length; i++) {
        for (int j = 0; j < currentPiece[i].length; j++) {
          newPiece[j][currentPiece.length - 1 - i] = currentPiece[i][j];
        }
      }

      // 돌림 가능 조건
      // 돌렸을 때 화면을 벗어나는 경우
      if (currentPieceColumn + newPiece[0].length > columns || currentPieceRow + newPiece.length > rows) {
        keepRotate = false;
      } else {
        for (int i = currentPieceRow; i<currentPieceRow+newPiece.length; i++) {
          for (int j = currentPieceColumn; j<currentPieceColumn+newPiece[0].length; j++) {
            // 이미 블럭이 있어서 못돌리는 경우
            if (grid[i][j]==1 && i<currentPieceRow+currentPiece.length && j<currentPieceColumn+currentPiece[0].length && currentPiece[i-currentPieceRow][j-currentPieceColumn]!=1) {
              keepRotate = false;
            }
          }
        }
      }
      if (keepRotate) {
        for (int i = currentPieceRow; i < currentPieceRow + currentPiece.length; i++) {
          for (int j = currentPieceColumn; j < currentPieceColumn + currentPiece[0].length; j++) {
            // 현재 블럭 없애기
            grid[i][j] = 0;
          }
        }
        // 새 블럭을 현재 블럭으로 설정
        currentPiece = newPiece;
        for (int i = currentPieceRow; i < currentPieceRow + currentPiece.length; i++) {
          for (int j = currentPieceColumn; j < currentPieceColumn + currentPiece[0].length; j++) {
            // 새 블럭 만들기
            if (currentPiece[i - currentPieceRow][j - currentPieceColumn] == 1) {
              grid[i][j] = 1;
            }
          }
        }
      }

    });
    signal();
  }

  bool updateGrid() {  // 블럭 움직이는 함수
    var temp = currentPieceRow;
    bool keepUpdate = true;
    wait();
    setState(() {
      for (int i = currentPieceRow; i < currentPieceRow+currentPiece.length; i++){
        for (int j = currentPieceColumn; j < currentPieceColumn+currentPiece[0].length; j++) {
          // 바닥에 닿을때 or 기존의 블럭에 현재 블럭이 겹치면서 얹어질 때
          if (i+1>=rows || (currentPiece[i-currentPieceRow][j-currentPieceColumn]==0 && grid[i][j]==1 && i>0 && grid[i-1][j]==1 )) {
            keepUpdate = false;
            break;
          }
          // 기존의 블럭에 안 겹치면서 얹어질 때
          if (i == currentPieceRow+currentPiece.length-1 && currentPiece[i-currentPieceRow][j-currentPieceColumn]==1 && grid[i+1][j]==1) {
            keepUpdate = false;
            break;
          }
        }
        if (!keepUpdate){
          break;
        }
      }
      if (keepUpdate) {
        for (int i = currentPieceRow+currentPiece.length-1; i > currentPieceRow-1; i--){
          for (int j = currentPieceColumn; j < currentPieceColumn+currentPiece[0].length; j++) {
            if(grid[i][j]==1 && currentPiece[i-currentPieceRow][j-currentPieceColumn]==1) {
              grid[i + 1][j] = 1;
              grid[i][j] = 0;
            }
          }
        }
        currentPieceRow++;
      }
    });
    signal();
    if (temp == currentPieceRow) {  // 움직임이 없을 때 (바닥 또는 다른 블럭에 닿았을 때)
      return false;
    } else {  // 움직임이 있을 때
      return true;
    }
  }

  // 줄 생성 확인
  void checkLines() {
    for (int i = rows - 1; i >= 0; i--) {
      if (!grid[i].contains(0)) {
        setState(() {
          grid.removeAt(i);
          grid.insert(0, List.filled(columns, 0));
          score += 10;
          // 점수별 떨어지는 시간 감소
          if (score % 30 == 0) {
            level++;
            if (dueTime > 300){
              dueTime -= 100;
            } else if (dueTime > 200) {
              dueTime -= 50;
            } else if (dueTime > 150) {
              dueTime -= 5;
            }
            timer.cancel();
            startTimer();
          }
          i++;
        });
      }
    }
  }

  // 게임 오버 확인 (맨 윗줄에 블럭 있는지 없는지 확인)
  void checkGameOver() {
    if (grid[0].contains(1)) {
      timer.cancel(); // 타이머 취소
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Text('Your score: $score'),
            actions: [
              TextButton(
                child: const Text('Play Again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // 다시 시작
  void resetGame() {
    setState(() {
      grid = [];
      score = 0;
      level = 1;
      dueTime = 800;
    });
    initializeGrid();
    spawnPiece();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    Timer tm;
    return Scaffold(
      body: Center(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: moveLeft,
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(Colors.black12), // 터치 시 효과를 투명하게 설정
                            splashFactory: NoSplash.splashFactory, // 스플래시 효과 제거
                            textStyle: MaterialStateProperty.all(TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04))
                          ),
                          child: const Text("<"),
                        )
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("TETRIS",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.07,fontWeight: FontWeight.bold)),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          int row = index ~/ columns;
                          int column = index % columns;
                          bool isPiece =
                              row >= currentPieceRow &&
                                  row < currentPieceRow + currentPiece.length &&
                                  column >= currentPieceColumn &&
                                  column < currentPieceColumn + currentPiece[0].length &&
                                  currentPiece[row - currentPieceRow][column - currentPieceColumn]==1;

                          return Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.08),
                            decoration: BoxDecoration(
                              color: isPiece ? currentPieceColor : grid[row][column]==1 ? Colors.grey : Colors.white,
                              border: Border.all(color: Colors.black),
                            ),
                          );
                        },
                        itemCount: rows * columns,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              onPressed: rotatePiece,
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
                                splashFactory: NoSplash.splashFactory,
                                textStyle: MaterialStateProperty.all(TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04))
                              ),
                              child: const Icon(Icons.refresh),
                            ),
                          ),
                          Text('Level : $level\nScore : $score',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              onPressed: updateGrid,
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
                                splashFactory: NoSplash.splashFactory,
                                textStyle: MaterialStateProperty.all(TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04))
                              ),
                              child: const Icon(Icons.arrow_downward),
                            ),
                          ),
                        ],
                      )
                    ], // Column을 끝 부분에 정렬
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: moveRight,
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
                            splashFactory: NoSplash.splashFactory,
                              textStyle: MaterialStateProperty.all(TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04))
                          ),
                          child: const Text(">"),
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}