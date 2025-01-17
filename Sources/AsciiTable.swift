public struct Table<Row> {
  let columns: [Column<Row>]

  var border: TableBorder = .single
  var emptyText: String = "No data"

  private var includeHeader: Bool {
    columns.contains(where: \.header.isNotEmpty)
  }

  private init(columns: [Column<Row>]) {
    self.columns = columns
  }

  public init(@TableBuilder<Row> _ columns: () -> [Column<Row>]) {
    self.init(columns: columns())
  }

  public func border(_ border: TableBorder) -> Self {
    var copy = self
    copy.border = border
    return copy
  }

  public func empty(_ emptyText: String) -> Self {
    var copy = self
    copy.emptyText = emptyText
    return copy
  }

  public func render(_ rows: [Row]) -> String {
    let columnData = columns.map { column in
      let cells = rows.map { column.content(for: $0) }
      let width = column.width(for: cells)
      return (column: column, cells: cells, width: width)
    }

    let header = renderHeader(columnData)
    let body = rows.isEmpty
      ? renderEmpty(columnWidths: columnData.map(\.width))
      : renderBody(columnData)
    return (header + body)
      .filter { !$0.isEmpty }
      .joined(separator: "\n")
  }

  private typealias ColumnData = (column: Column<Row>, cells: [String], width: Int)

  private func renderHeader(_ columnData: [ColumnData]) -> [String] {
    guard includeHeader else { return [] }

    let topBorder = renderRow(
      leftEdge: border.headerTopLeft,
      rightEdge: border.headerTopRight,
      junction: border.headerTopJunction,
      contents: columnData.map { _, _, width in
        String(repeating: border.headerHorizontalEdge, count: width)
      }
    )

    let headerRow = renderRow(
      leftEdge: border.headerVerticalEdge,
      rightEdge: border.headerVerticalEdge,
      junction: border.headerVerticalDivider,
      contents: columnData.map { column, _, width in column.render(column.header, width: width) }
    )

    return [topBorder, headerRow]
  }

  private func renderBody(_ columnData: [ColumnData]) -> [String] {
    let columnWidths = columnData.map(\.width)

    let topBorder = includeHeader
      ? renderRow(
        leftEdge: border.headerBottomLeft,
        rightEdge: border.headerBottomRight,
        junction: border.headerInnerJunction,
        contents: columnWidths.map { width in
          String(repeating: border.headerHorizontalEdge, count: width)
        }
      )
      : renderRow(
        leftEdge: border.bodyTopLeft,
        rightEdge: border.bodyTopRight,
        junction: border.bodyTopJunction,
        contents: columnWidths.map { width in
          String(repeating: border.bodyHorizontalEdge, count: width)
        }
      )

    let bodyCells = columnData.map { column, cells, width in
      cells.map { column.render($0, width: width) }
    }.transposed()
    let bodyRows = bodyCells.map { cells in
      renderRow(
        leftEdge: border.bodyVerticalEdge,
        rightEdge: border.bodyVerticalEdge,
        junction: border.bodyVerticalDivider,
        contents: cells
      )
    }
    let bodyHorizontalDivider = renderRow(
      leftEdge: border.bodyLeftJunction,
      rightEdge: border.bodyRightJunction,
      junction: border.bodyInnerJunction,
      contents: columnWidths.map { width in
        String(repeating: border.bodyHorizontalDivider, count: width)
      }
    )

    let bottomBorder = renderRow(
      leftEdge: border.bodyBottomLeft,
      rightEdge: border.bodyBottomRight,
      junction: border.bodyBottomJunction,
      contents: columnWidths.map { width in
        String(repeating: border.bodyHorizontalEdge, count: width)
      }
    )

    let body = bodyHorizontalDivider.isEmpty
      ? bodyRows.joined(separator: "\n")
      : bodyRows.joined(separator: "\n" + bodyHorizontalDivider + "\n")

    return [topBorder, body, bottomBorder]
  }

  private func renderEmpty(columnWidths: [Int]) -> [String] {
    let totalWidth = columnWidths.reduce(0, +) + columnWidths.count - 1
    let emptyColumn = Column<Row>("") { _ in "" }.width(.fixed(totalWidth))

    let topBorder = includeHeader
      ? renderRow(
        leftEdge: border.headerBottomLeft,
        rightEdge: border.headerBottomRight,
        junction: border.headerBottomJunction,
        contents: columnWidths.map { width in
          String(repeating: border.headerHorizontalEdge, count: width)
        }
      )
      : renderRow(
        leftEdge: border.bodyTopLeft,
        rightEdge: border.bodyTopRight,
        junction: border.bodyHorizontalEdge,
        contents: columnWidths.map { width in
          String(repeating: border.bodyHorizontalEdge, count: width)
        }
      )

    let emptyRow = renderRow(
      leftEdge: border.bodyVerticalEdge,
      rightEdge: border.bodyVerticalEdge,
      junction: border.bodyVerticalDivider,
      contents: [emptyColumn.render(emptyText, width: totalWidth)]
    )

    let bottomBorder = renderRow(
      leftEdge: border.bodyBottomLeft,
      rightEdge: border.bodyBottomRight,
      junction: border.bodyBottomJunction,
      contents: [String(repeating: border.bodyHorizontalEdge, count: totalWidth)]
    )

    return [topBorder, emptyRow, bottomBorder]
  }

  private func renderRow(
    leftEdge: String,
    rightEdge: String,
    junction: String,
    contents: [String]
  ) -> String {
    leftEdge + contents.joined(separator: junction) + rightEdge
  }
}

@resultBuilder
public struct TableBuilder<Row> {
  public static func buildExpression(_ expression: Column<Row>) -> [Column<Row>] {
    [expression]
  }

  public static func buildExpression(_ expression: Column<Row>...) -> [Column<Row>] {
    expression
  }

  public static func buildBlock(_ columns: [Column<Row>]...) -> [Column<Row>] {
    columns.flatMap(\.self)
  }

  public static func buildEither(first component: [Column<Row>]) -> [Column<Row>] {
    component
  }

  public static func buildEither(second component: [Column<Row>]) -> [Column<Row>] {
    component
  }

  public static func buildOptional(_ component: [Column<Row>]?) -> [Column<Row>] {
    component ?? []
  }
}

private extension Array where Element: RandomAccessCollection, Element.Index == Int {
  func transposed() -> [[Element.Element]] {
    guard let first else { return [] }
    return first.indices.map { index in
      self.map { $0[index] }
    }
  }
}

private extension Collection {
  var isNotEmpty: Bool { !isEmpty }
}
