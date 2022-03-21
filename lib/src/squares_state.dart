import 'package:equatable/equatable.dart';
import 'package:squares/squares.dart';

/// A state representation containing the common values that are needed to manage a Squares `BoardController`.
class SquaresState extends Equatable {
  /// The current state of play. Can be idle, playing or finished.
  final PlayState state;

  /// A representation of the board dimensions.
  final BoardSize size;

  /// The state of the pieces on the board.
  final BoardState board;

  /// A list of possible moves.
  /// These could be premoves depending on how this was generated.
  final List<Move> moves;

  /// The pieces in each player's hand, such as in variants like Crazyhouse.
  final List<List<String>> hands;

  /// Is there thinking happening? Set this yourself.
  final bool thinking;

  /// A history of moves played.
  final List<Move> history;

  /// Can [player] currently move?
  bool canMove(int player) => state == PlayState.playing && board.player == player;

  SquaresState({
    required this.state,
    required this.size,
    required this.board,
    required this.moves,
    this.hands = const [[], []],
    this.thinking = false,
    this.history = const [],
  });
  factory SquaresState.initial() =>
      SquaresState(state: PlayState.idle, size: BoardSize.standard(), board: BoardState.empty(), moves: []);

  /// Creates a copy of the state with the relevant values modified.
  SquaresState copyWith({
    PlayState? state,
    BoardSize? size,
    BoardState? board,
    List<Move>? moves,
    List<List<String>>? hands,
    bool? thinking,
    int? orientation,
    List<Move>? history,
  }) {
    return SquaresState(
      state: state ?? this.state,
      size: size ?? this.size,
      board: board ?? this.board,
      moves: moves ?? this.moves,
      hands: hands ?? this.hands,
      thinking: thinking ?? this.thinking,
      history: history ?? this.history,
    );
  }

  /// Returns a copy of the state, with [board.orientation] flipped.
  SquaresState flipped() => copyWith(board: board.flipped());

  List<Object> get props => [state, size, board, moves, hands, thinking];
  bool get stringify => true;
}

enum PlayState {
  idle,
  playing,
  finished,
}
