
public struct ChessClock : Sendable {
    public let duration:ContinuousClock.Duration
    public let increment:@Sendable (Int) -> Duration?

    public init(duration: ContinuousClock.Duration, increment: @escaping @Sendable (Int) -> Duration?) {
        self.duration = duration
        self.increment = increment
    }
}