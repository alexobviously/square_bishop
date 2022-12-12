import 'package:squares/squares.dart' as sq;
import 'package:bishop/bishop.dart' as bp;
import 'package:square_bishop/square_bishop.dart';

extension GameExtensions on bp.Game {
  /// Gets the current `PlayState`.
  GameState get gameState {
    if (gameOver) return GameState.finished;
    return GameState.playing;
  }

  /// Builds a Squares BoardState from the current state of the game.
  sq.BoardState boardState(int? orientation) {
    sq.BoardSize sqSize = squaresSize;
    return sq.BoardState(
      board: boardSymbols(),
      lastFrom:
          info.lastFrom != null ? sqSize.squareNumber(info.lastFrom!) : null,
      lastTo: info.lastTo != null ? sqSize.squareNumber(info.lastTo!) : null,
      checkSquare:
          info.checkSq != null ? sqSize.squareNumber(info.checkSq!) : null,
      turn: turn,
      orientation: orientation,
    );
  }

  /// Gets the Squares PlayState for this game.
  sq.PlayState playState(int player) {
    if (gameState == GameState.finished) return sq.PlayState.finished;
    if (gameState == GameState.idle ||
        ![sq.Squares.white, sq.Squares.black].contains(player)) {
      return sq.PlayState.observing;
    }
    if (turn == player) return sq.PlayState.ourTurn;
    return sq.PlayState.theirTurn;
  }

  /// Builds a SquaresState from the current state of the game, from the perspective of [player].
  SquaresState squaresState(int player) {
    return SquaresState(
      player: player,
      state: playState(player),
      size: size.toSquares(),
      board: boardState(player),
      moves: squaresMoves(player),
      history: squaresHistory,
      hands: handSymbols,
    );
  }

  sq.BoardSize get squaresSize => size.toSquares();

  /// Gets all the available moves (in Bishop format) for [player].
  /// If it's [player]'s turn, this will generate legal moves, and if not it will generate premoves.
  List<bp.Move> movesForPlayer(int player) =>
      turn == player ? generateLegalMoves() : generatePremoves();

  /// Gets all the available moves (in Squares format) for [player].
  /// /// If it's [player]'s turn, this will generate legal moves, and if not it will generate premoves.
  List<sq.Move> squaresMoves(int player) =>
      movesForPlayer(player).map((e) => squaresMove(e)).toList();

  /// Returns the move history in Squares move format.
  List<sq.Move> get squaresHistory => history
      .where((e) => e.move != null)
      .map((e) => squaresMove(e.move!))
      .toList();

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
