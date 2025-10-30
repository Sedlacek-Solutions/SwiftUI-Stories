//
//  RandomAccessCollection+Index.swift
//
//  Created by James Sedlacek on 11/17/24.
//

extension RandomAccessCollection where Element: Identifiable {
    /// Finds the index of an element with the given `id`.
    public func index(of id: Element.ID?) -> Index? {
        guard let id = id else { return nil }
        return firstIndex(where: { $0.id == id })
    }
}
