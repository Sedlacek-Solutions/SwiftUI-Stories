//
//  View+OnTapGesture.swift
//
//  Created by James Sedlacek on 11/15/24.
//

import SwiftUI

/// A view modifier that adds tap gesture recognition to specific horizontal regions of a view.
/// This modifier splits the view into left and right halves and allows for different tap actions
/// based on which side is tapped.
@MainActor
struct OnTapGestureAlignmentModifier: ViewModifier {
    /// The horizontal edge (leading or trailing) where the tap gesture should be active.
    let alignment: HorizontalEdge
    /// The action to perform when the specified region is tapped.
    let action: () -> Void

    /// Creates the modified view with a tap-sensitive region on the specified side.
    /// - Parameter content: The view being modified.
    /// - Returns: A view with the tap gesture overlay applied.
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .overlay(alignment: alignment == .leading ? .leading : .trailing) {
                    Color.clear
                        .contentShape(.rect)
                        .frame(width: geometry.size.width / 2)
                        .onTapGesture(perform: action)
                }
        }
    }
}

/// Extension providing convenience modifiers for adding aligned tap gestures to views.
@MainActor
extension View {
    /// Adds a tap gesture to either the leading or trailing half of a view.
    /// - Parameters:
    ///   - alignment: The horizontal edge (leading or trailing) where the tap gesture should be active.
    ///   - action: The closure to execute when the specified region is tapped.
    /// - Returns: A view that responds to taps on the specified side.
    public func onTapGesture(
        alignment: HorizontalEdge,
        perform action: @escaping () -> Void
    ) -> some View {
        self.modifier(
            OnTapGestureAlignmentModifier(
                alignment: alignment,
                action: action
            )
        )
    }
}
