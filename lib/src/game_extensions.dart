import 'package:squares/squares.dart' as sq;
import 'package:bishop/bishop.dart' as bp;
import 'package:square_bishop/square_bishop.dart';

extension GameExtensions on bp.Game {
  /// Gets the current `PlayState`.
  PlayState get playState {
    if (gameOver) return PlayState.finished;
    return PlayState.playing;
  }

  /// Builds a Squares BoardState from the current state of the game.
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

  /// Builds a SquaresState from the current state of the game, from the perspective of [player].
  SquaresState squaresState(int player) {
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

  /// Gets all the available moves (in Bishop format) for [player].
  /// If it's [player]'s turn, this will generate legal moves, and if not it will generate premoves.
  List<bp.Move> movesForPlayer(int player) => turn == player ? generateLegalMoves() : generatePremoves();

  /// Gets all the available moves (in Squares format) for [player].
  /// /// If it's [player]'s turn, this will generate legal moves, and if not it will generate premoves.
  List<sq.Move> squaresMoves(int player) => movesForPlayer(player).map((e) => squaresMove(e)).toList();

  /// Returns the move history in Squares move format.
  List<sq.Move> get squaresHistory => history.where((e) => e.move != null).map((e) => squaresMove(e.move!)).toList();

  /// Converts a Bishop move to a Squares move.
  sq.Move squaresMove(bp.Move move) {
    String alg = toAlgebraic(move);
    return squaresSize.moveFromAlgebraic(alg);
  }

  /// Converts a Squares move to a Bishop move.
  /// Can return null if the move is not valid.
  bp.Move? bishopMove(sq.Move move) {
    String alg = squaresSize.moveToAlgebraic(move);
    return getMove(alg);
  }

  /// Converts a Squares [move] to Bishop format and makes it.
  /// Returns false if the move is invalid.
  bool makeSquaresMove(sq.Move move) {
    bp.Move? m = bishopMove(move);
    if (m == null) return false;
    return makeMove(m);
  }
}
