
public struct TimeControl: Sendable {
    public let duration:ContinuousClock.Duration
    public let increment:Duration

    public init(
        duration: ContinuousClock.Duration,
        increment: Duration
    ) {
        self.duration = duration
        self.increment = increment
    }
}