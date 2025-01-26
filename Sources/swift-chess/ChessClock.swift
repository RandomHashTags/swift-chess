//
//  ChessClock.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

struct ChessClock : Sendable {
    let duration:ContinuousClock.Duration
    let increment:@Sendable (Int) -> Duration?

    init(duration: ContinuousClock.Duration, increment: @escaping @Sendable (Int) -> Duration?) {
        self.duration = duration
        self.increment = increment
    }
}