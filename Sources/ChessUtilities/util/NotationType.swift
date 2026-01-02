
public enum NotationType: Sendable {
    /// A FEN record contains six fields, each separated by a space. The fields are as follows:
    /// 
    /// 1. Piece placement data: Each rank is described, starting with rank 8 and ending with rank 1, with a "/" between each one; within each rank, the contents of the squares are described in order from the a-file to the h-file.
    /// Each piece is identified by a single letter taken from the standard English names in algebraic notation (pawn = "P", knight = "N", bishop = "B", rook = "R", queen = "Q" and king = "K").
    /// White pieces are designated using uppercase letters ("PNBRQK"), while black pieces use lowercase letters ("pnbrqk").
    /// A set of one or more consecutive empty squares within a rank is denoted by a digit from "1" to "8", corresponding to the number of squares.
    /// 
    /// 2. Active color: "w" means that White is to move; "b" means that Black is to move.
    /// 
    /// 3. Castling availability: If neither side has the ability to castle, this field uses the character "-".
    /// Otherwise, this field contains one or more letters: "K" if White can castle kingside, "Q" if White can castle queenside, "k" if Black can castle kingside, and "q" if Black can castle queenside.
    /// A situation that temporarily prevents castling does not prevent the use of this notation.
    /// 
    /// 4. _En passant_ target square: This is a square over which a pawn has just passed while moving two squares; it is given in algebraic notation.
    /// If there is no _en passant_ target square, this field uses the character "-".
    /// This is recorded regardless of whether there is a pawn in position to capture _en passant_.
    /// An updated version of the spec has since made it so the target square is recorded only if a legal en passant capture is possible, but the old version of the standard is the one most commonly used.
    /// 
    /// 5. Halfmove clock: The number of halfmoves since the last capture or pawn advance, used for the fifty-move rule.
    /// 
    /// 6. Fullmove number: The number of the full moves. It starts at 1 and is incremented after Black's move.
    /// 
    /// - Link: https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation
    /// 
    /// ## Examples
    /// - `rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1` - starting position
    /// - `rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1` - after the move 1.e4
    /// - `rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2` - after 1...c5
    /// - `rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2` - after 2.Nf3
    case forsythEdwards
}