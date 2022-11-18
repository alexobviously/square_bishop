import 'package:squares/squares.dart' as sq;
import 'package:bishop/bishop.dart' as bp;

extension ToBishopSize on sq.BoardSize {
  /// Gets an equivalent Bishop BoardSize.
  bp.BoardSize toBishop() => bp.BoardSize(h, v);
}

extension ToSquaresSize on bp.BoardSize {
  /// Gets an equivalent Squares BoardSize.
  sq.BoardSize toSquares() => sq.BoardSize(h, v);
}
