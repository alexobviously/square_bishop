import 'package:squares/squares.dart' as sq;
import 'package:bishop/bishop.dart' as bp;
import 'package:square_bishop/square_bishop.dart';

extension GameExtensions on bp.Game {
  PlayState get playState {
    if (gameOver) return PlayState.finished;
    return PlayState.playing;
  }

  sq.BoardState get boardState {
    sq.BoardSize _size = squaresSize;
    return sq.BoardState(
      board: boardSymbols(),
      lastFrom: info.lastFrom != null ? _size.squareNumber(info.lastFrom!) : null,
      lastTo: info.lastTo != null ? _size.squareNumber(info.lastTo!) : null,
      checkSquare: info.checkSq != null ? _size.squareNumber(info.checkSq!) : null,
      player: turn,
    );
  }

  SquaresState gameState(int player) {
    return SquaresState(
      state: playState,
      size: size.toSquares(),
      board: boardState,
      moves: squaresMoves(player),
      history: squaresHistory,
      hands: handSymbols(),
    );
  }

  sq.BoardSize get squaresSize => size.toSquares();
  List<bp.Move> movesForPlayer(int player) => turn == player ? generateLegalMoves() : generatePremoves();
  List<sq.Move> squaresMoves(int player) => movesForPlayer(player).map((e) => squaresMove(e)).toList();
  List<sq.Move> get squaresHistory => history.where((e) => e.move != null).map((e) => squaresMove(e.move!)).toList();

  sq.Move squaresMove(bp.Move move) {
    String algebraic = toAlgebraic(move);
    return squaresSize.moveFromAlgebraic(algebraic);
  }

  bool makeSquaresMove(sq.Move move) {
    String alg = squaresSize.moveToAlgebraic(move);
    bp.Move? m = getMove(alg);
    if (m == null) return false;
    return makeMove(m);
  }
}
