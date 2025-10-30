//
//  ProgressTabContent.swift
//
//  Created by James Sedlacek on 2/2/25.
//

import SwiftUI

/// A protocol that defines the requirements for content that can be displayed
/// in a ProgressTabView with an associated progress tracking capability.
///
/// Conforming types must provide:
/// - A unique identifier through `Identifiable` conformance
/// - A view hierarchy through `View` conformance
/// - A `totalTime` value indicating how long the content should be displayed
public protocol ProgressTabContent: View, Identifiable {
    /// The total time (in seconds) that this content should be displayed
    /// before automatically advancing to the next tab.
    var totalTime: TimeInterval { get }
}

/// Default implementation for ProgressTabContent
public extension ProgressTabContent {
    /// Default implementation uses self as the identifier,
    /// ensuring each tab content instance is uniquely identifiable.
    var id: Self { self }
}
