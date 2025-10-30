//
//  ProgressTabView.swift
//
//  Created by James Sedlacek on 11/14/24.
//

import Combine
import SwiftUI

/// A view that displays a horizontally scrollable collection of tabs with progress indicators.
/// Each tab implements the `ProgressTabContent` protocol and shows its progress in a bar above.
@MainActor
public struct ProgressTabView<TabContent: ProgressTabContent> {
    /// The collection of tabs to display.
    let tabs: [TabContent]
    /// The amount to increment progress by each timer tick.
    private let incrementAmount: TimeInterval

    /// The ID of the currently selected tab.
    @State private(set) var selectedTabID: TabContent.ID?
    /// The current progress of the selected tab (in seconds).
    @State private var currentProgress: TimeInterval = 0

    /// Timer publisher for auto-advancing progress.
    @State private var timer: Timer.TimerPublisher?
    /// Cancellable object for the timer subscription.
    @State private var timerCancellable: Cancellable?

    /// Creates a new ProgressTabView with the specified tabs and increment amount.
    /// - Parameters:
    ///   - tabs: An array of views conforming to `ProgressTabContent`. Each tab will be displayed
    ///          in a horizontally scrollable container with a progress indicator above it.
    ///   - incrementAmount: The time interval (in seconds) by which the progress should increment
    ///                     on each timer tick. Defaults to 0.01 seconds (100 ticks per second).
    ///                     Smaller values result in smoother progress updates but more frequent timer events.
    public init(
        tabs: [TabContent],
        incrementAmount: TimeInterval = 0.01
    ) {
        self.tabs = tabs
        self.incrementAmount = incrementAmount
        if let firstTabID = tabs.first?.id {
            self._selectedTabID = .init(initialValue: firstTabID)
        }
    }

    /// Resets the progress of the current tab to zero.
    func resetProgress() {
        currentProgress = 0
    }

    /// Calculates the progress for a specific tab.
    /// - Parameter tab: The tab to calculate progress for.
    /// - Returns: The progress value in seconds.
    ///   - For the selected tab: returns the current progress
    ///   - For tabs before the selected tab: returns their total time (completed)
    ///   - For tabs after the selected tab: returns zero (not started)
    func progress(for tab: TabContent) -> TimeInterval {
        guard let selectedID = selectedTabID,
              let selectedIndex = tabs.index(of: selectedID) else {
            return 0
        }

        guard let tabIndex = tabs.index(of: tab.id) else {
            return 0
        }

        if tab.id == selectedID {
            return currentProgress
        } else if tabIndex < selectedIndex {
            // If the tab is before the selected tab, return its total time (completed)
            return tab.totalTime
        } else {
            // If the tab is after the selected tab, return zero (not started)
            return 0
        }
    }

    /// Starts the timer that automatically advances progress.
    func startTimer() {
        guard timer == nil else { return }

        timer = Timer.publish(
            every: incrementAmount,
            on: .main,
            in: .common
        )

        timerCancellable = timer?.autoconnect().sink { _ in
            incrementProgress()
        }
    }

    /// Stops the timer and cleans up resources.
    func endTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        timer = nil
    }

    /// Increments the progress of the current tab.
    /// When the progress reaches the tab's total time, it automatically advances to the next tab.
    func incrementProgress() {
        guard let tabID = selectedTabID,
              let tabIndex = tabs.index(of: tabID),
              let tab = tabs[safe: tabIndex] else { return }

        if currentProgress < tab.totalTime {
            currentProgress += incrementAmount
        } else {
            incrementTab()
        }
    }

    /// Handles long press state changes on tabs.
    /// - Parameter isPressed: Whether the tab is currently being pressed.
    func onPressingChanged(_ isPressed: Bool) {
        if isPressed {
            endTimer()
        } else {
            startTimer()
        }
    }

    /// Advances to the next tab in the sequence.
    /// If at the last tab, wraps around to the first tab.
    func incrementTab() {
        guard let selectedTabID, let selectedIndex = tabs.index(of: selectedTabID) else {
            selectedTabID = tabs.first?.id
            return
        }

        withAnimation {
            if selectedIndex < tabs.count - 1 {
                self.selectedTabID = tabs[selectedIndex + 1].id
            } else {
                self.selectedTabID = tabs[0].id
            }
        }

        resetProgress()
    }

    /// Moves to the previous tab in the sequence.
    /// If at the first tab, stays on the first tab.
    func decrementTab() {
        guard let selectedTabID, let selectedIndex = tabs.index(of: selectedTabID) else {
            selectedTabID = tabs.first?.id
            return
        }

        if selectedIndex > 0 {
            self.selectedTabID = tabs[selectedIndex - 1].id
        }

        resetProgress()
    }
}
