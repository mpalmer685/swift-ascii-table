public enum HorizontalAlign: Sendable {
  case left
  case center
  case right
}

public enum ContentWidth: Sendable {
  case atLeast(Int)
  case upTo(Int)
  case minMax(Int, Int)
  case fixed(Int)
  case maxContent

  public static func between(_ min: Int, and max: Int) -> Self {
    .minMax(min, max)
  }
}

extension ContentWidth: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self = .fixed(value)
  }
}

extension ContentWidth {
  func width(for cells: [String]) -> Int {
    let widths = cells.map(\.printableWidth)
    switch self {
      case let .atLeast(min):
        return max(min, widths.max() ?? 0)
      case let .upTo(max):
        return min(max, widths.max() ?? max)
      case let .minMax(min, max):
        let maxWidth = widths.max() ?? max
        return maxWidth.clamped(to: min ... max)
      case let .fixed(width):
        return width
      case .maxContent:
        return widths.max() ?? 0
    }
  }
}

public struct HorizontalPadding: Hashable, Sendable {
  fileprivate let left: Int
  fileprivate let right: Int

  public static let none = HorizontalPadding(left: 0, right: 0)

  public init(left: Int, right: Int) {
    self.left = left
    self.right = right
  }
}

extension HorizontalPadding: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self = .init(left: value, right: value)
  }
}

public struct Column<Row> {
  let header: String
  let content: @Sendable (Row) -> any CustomStringConvertible
  var width: ContentWidth = .maxContent
  var align: HorizontalAlign = .left
  var padding: HorizontalPadding = 1
  var truncate: String = "…"
  var formatter: @Sendable (String) -> String = { $0 }

  public init(
    _ header: String = "",
    content: @escaping @Sendable (Row) -> any CustomStringConvertible
  ) {
    self.header = header
    self.content = content
  }

  public func width(_ width: ContentWidth) -> Self {
    var copy = self
    copy.width = width
    return copy
  }

  public func align(_ align: HorizontalAlign) -> Self {
    var copy = self
    copy.align = align
    return copy
  }

  public func padding(_ padding: HorizontalPadding) -> Self {
    var copy = self
    copy.padding = padding
    return copy
  }

  public func truncate(using truncate: String) -> Self {
    var copy = self
    copy.truncate = truncate
    return copy
  }

  public func format(_ formatter: @escaping @Sendable (String) -> String) -> Self {
    var copy = self
    copy.formatter = formatter
    return copy
  }
}

extension Column: Sendable where Row: Sendable {}

extension Column {
  func content(for row: Row) -> String {
    String(describing: content(row))
  }

  func width(for rows: [String]) -> Int {
    width.width(for: [header] + rows) + padding.left + padding.right
  }

  func render(_ content: String, width: Int) -> String {
    let displayWidth = width - padding.left - padding.right
    let displayContent = content.count > displayWidth
      ? content.clamped(to: displayWidth, truncate: truncate)
      : content.padded(to: displayWidth, align: align)

    let formatted = formatter(displayContent)
    if formatted.count != displayWidth {
      fatalError("The formatter for column '\(header)' cannot change the width of the content.")
    }

    let leftPadding = String(repeating: " ", count: padding.left)
    let rightPadding = String(repeating: " ", count: padding.right)
    return leftPadding + formatted + rightPadding
  }
}

private let escape: Character = "\u{1B}"

private extension String {
  var printableWidth: Int {
    strippingAnsi().count
  }

  private func strippingAnsi() -> Self {
    guard !isEmpty else { return self }
    guard contains(escape) else { return self }

    var output = split(separator: escape)
    for (index, string) in output.enumerated() {
      if let end = string.firstIndex(of: "m") {
        output[index] = string[string.index(after: end)...]
      }
    }

    return output.joined()
  }

  func clamped(to width: Int, truncate: String) -> Self {
    guard count > width else { return self }

    let truncated = prefix(width - truncate.count)
    return truncated + truncate
  }

  func padded(to width: Int, align: HorizontalAlign) -> Self {
    let padding = width - count
    guard padding > 0 else { return self }

    switch align {
      case .left:
        return self + String(repeating: " ", count: padding)
      case .center:
        let leftPadding = padding / 2
        let rightPadding = padding - leftPadding
        return String(repeating: " ", count: leftPadding) + self +
          String(repeating: " ", count: rightPadding)
      case .right:
        return String(repeating: " ", count: padding) + self
    }
  }
}

private extension Comparable {
  func clamped(to range: ClosedRange<Self>) -> Self {
    min(max(self, range.lowerBound), range.upperBound)
  }
}
