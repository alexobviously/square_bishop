import 'package:equatable/equatable.dart';
import 'package:squares/squares.dart';

class SquaresState extends Equatable {
  final PlayState state;
  final BoardSize size;
  final BoardState board;
  final List<Move> moves;
  final List<List<String>> hands;
  final bool thinking;
  final List<Move> history;

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

  SquaresState flipped() => copyWith(board: board.flipped());

  List<Object> get props => [state, size, board, moves, hands, thinking];
  bool get stringify => true;
}

enum PlayState {
  idle,
  playing,
  finished,
}
