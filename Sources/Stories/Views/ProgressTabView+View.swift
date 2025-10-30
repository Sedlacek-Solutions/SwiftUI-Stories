//
//  ProgressTabView+View.swift
//
//  Created by James Sedlacek on 11/17/24.
//

import SwiftUI

/// View extension for ProgressTabView that implements the visual interface
/// and interaction handling for the tab navigation system.
extension ProgressTabView: View {
    /// The main body of the view that creates a horizontal scrollable container
    /// with progress indicators and interactive tabs.
    public var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(tabs, content: tabView)
                    .containerRelativeFrame(.horizontal, count: 1, spacing: .zero)
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.never)
        .scrollPosition(id: $selectedTabID)
        .onAppear(perform: startTimer)
        .onDisappear(perform: endTimer)
        .safeAreaInset(edge: .top, content: progressViews)
        .onChange(of: selectedTabID, resetProgress)
    }

    /// Creates an interactive view for an individual tab.
    /// - Parameter tab: The tab content to display.
    /// - Returns: A view with tap and long press gesture handlers.
    private func tabView(_ tab: TabContent) -> some View {
        tab
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
            .onTapGesture(
                alignment: .leading,
                perform: decrementTab
            )
            .onTapGesture(
                alignment: .trailing,
                perform: incrementTab
            )
            .onLongPressGesture(
                perform: endTimer,
                onPressingChanged: onPressingChanged
            )
    }

    /// Creates the progress indicator views that appear above the tabs.
    /// - Returns: A horizontal stack of progress bars showing completion status for each tab.
    private func progressViews() -> some View {
        HStack(spacing: 8) {
            ForEach(tabs) { tab in
                ProgressView(
                    value: progress(for: tab),
                    total: tab.totalTime
                )
            }
            .tint(.primary)
            .animation(nil, value: selectedTabID)
        }
        .padding(.horizontal)
    }
}
