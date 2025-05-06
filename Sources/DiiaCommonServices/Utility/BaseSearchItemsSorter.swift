
import Foundation
import DiiaCommonTypes

/// Defines sorting methods for search results in single selection mode.
///
/// - `byPositionRank`: Sorts results based on their position in the original data.
///   Items with the search keyword appearing earlier will have higher priority.
/// - `byDefault`: Uses the default order of items without considering the match position.
public enum BaseSearchItemsSorter: SearchItemsSorter {
    /// Sorts results by match position. Items with an earlier match are prioritized.
    case byPositionRank

    /// Uses the default sorting order without modifications.
    case byDefault

    // MARK: - Public
    public func sort<T: SearchableItemModel>(by keyword: String, in items: [T]) -> [T]  {
        let keyword = keyword.lowercased()

        guard !keyword.isEmpty else { return items }

        switch self {
        case .byPositionRank:
            var newItems: [(Int, T)] = []

            for item in items {
                guard let entrancePosition = item.entrancePosition(keyword) else { continue }
                newItems.append((entrancePosition, item))
            }

            return newItems.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
        case .byDefault:
            return items.filter { $0.contain(keyword) }
        }
    }
}

// MARK: - SearchableItemModel + Utils
private extension SearchableItemModel {
    func contain(_ keyword: String) -> Bool {
        return searchText.lowercased().contains(keyword)
    }

    func entrancePosition(_ keyword: String) -> Int? {
        let lowercasedTitle = searchText.lowercased()
        guard let range = lowercasedTitle.range(of: keyword) else { return nil }
        return range.lowerBound.utf16Offset(in: lowercasedTitle)
    }
}
