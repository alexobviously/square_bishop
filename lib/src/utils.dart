import 'package:bishop/bishop.dart' as bp;
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';

enum InvalidMoveBehaviour {
  ignore,
  undoAll,
  returnNull,
  throwException;
}

/// Builds a one-off `SquaresState` without having to handle a Bishop game.
SquaresState? buildSquaresState({
  bp.Variant? variant,
  String? fen,
  bp.FenBuilder? fenBuilder,
  int player = Squares.white,
  List<String> moves = const [],
  InvalidMoveBehaviour invalidMoveBehaviour = InvalidMoveBehaviour.returnNull,
  int? zobristSeed,
  int? startPosSeed,
}) {
  variant ??= bp.Variant.standard();
  bp.Game game = bp.Game(
    variant: variant,
    fen: fen,
    fenBuilder: fenBuilder,
    zobristSeed: zobristSeed ?? bp.Bishop.defaultSeed,
    startPosSeed: startPosSeed,
  );
  int movesMade = game.makeMultipleMoves(
    moves,
    invalidMoveBehaviour == InvalidMoveBehaviour.undoAll,
  );
  if (movesMade != moves.length) {
    if (invalidMoveBehaviour == InvalidMoveBehaviour.returnNull) {
      return null;
    }
    if (invalidMoveBehaviour == InvalidMoveBehaviour.throwException) {
      throw Exception('Invalid move ${moves[movesMade]}');
    }
  }
  return game.squaresState(player);
}
