@testable import AsciiTable
import Testing

@Suite("Column widths")
struct ColumnWidthTests {
  let base = Column<String>("") { $0 }.padding(.none)

  @Test(".atLeast", arguments: [
    ["1", "1", "1"]: 3,
    ["1", "123", "12345"]: 5,
    ["12345", "123", "1"]: 5,
  ])
  func testAtLeast(cells: [String], expected: Int) {
    let column = base.width(.atLeast(3))
    let width = column.width(for: cells)
    #expect(width == expected)
  }

  @Test(".upTo", arguments: [
    ["1", "1", "1"]: 1,
    ["1", "12", "123"]: 3,
    ["123", "12345", "1234567"]: 3,
  ])
  func testUpTo(cells: [String], expected: Int) {
    let column = base.width(.upTo(3))
    let width = column.width(for: cells)
    #expect(width == expected)
  }

  @Test(".minMax", arguments: [
    ["1", "12"]: 3,
    ["12", "123", "1234"]: 4,
    ["123", "12345"]: 5,
    ["123", "12345", "1234567"]: 5,
  ])
  func testMinMax(cells: [String], expected: Int) {
    let column = base.width(.between(3, and: 5))
    let width = column.width(for: cells)
    #expect(width == expected)
  }

  @Test(".fixed", arguments: [
    ["1", "123", "12345"]: 3
  ])
  func testFixed(cells: [String], expected: Int) {
    let column = base.width(3)
    let width = column.width(for: cells)
    #expect(width == expected)
  }

  @Test(".maxContent", arguments: [
    ["1", "123", "12345"]: 5
  ])
  func testMaxContent(cells: [String], expected: Int) {
    let column = base.width(.maxContent)
    let width = column.width(for: cells)
    #expect(width == expected)
  }

  @Test("padding", arguments: [
    HorizontalPadding.none: 3,
    1: 5,
    .init(left: 0, right: 2): 5,
    .init(left: 2, right: 0): 5,
  ])
  func testPadding(padding: HorizontalPadding, expected: Int) {
    let column = base.padding(padding)
    let cells = ["123"]
    let width = column.width(for: cells)
    #expect(width == expected)
  }

  @Test("header only")
  func testHeaderOnly() {
    let column = Column<String>("Name") { $0 }.padding(0)
    let width = column.width(for: [])
    #expect(width == 4)
  }
}

@Suite("Cell rendering")
struct CellRenderingTests {
  let base = Column<String>("") { $0 }
    .padding(.none)
    .width(.maxContent)
    .align(.left)

  @Test("with padding", arguments: [
    HorizontalPadding.none: "123",
    1: " 123 ",
    2: "  123  ",
    .init(left: 0, right: 1): "123 ",
    .init(left: 1, right: 0): " 123",
  ])
  func testPadding(padding: HorizontalPadding, expected: String) {
    let content = "123"

    let column = base.padding(padding)
    let width = column.width(for: [content])
    let cell = column.render(content, width: width)
    #expect(cell == expected)
  }

  @Test("truncation")
  func testTruncation() {
    let content = "1234567"

    let column = base.width(.fixed(5))
    let width = column.width(for: [content])
    let cell = column.render(content, width: width)
    #expect(cell == "1234…")
  }

  @Test("custom truncation")
  func testCustomTruncation() {
    let content = "123456789"

    let column = base
      .width(.fixed(7))
      .truncate(using: "..")
    let width = column.width(for: [content])
    let cell = column.render(content, width: width)
    #expect(cell == "12345..")
  }

  @Test("alignment", arguments: [
    HorizontalAlign.left: "123  ",
    .center: " 123 ",
    .right: "  123",
  ])
  func testAlignment(alignment: HorizontalAlign, expected: String) {
    let column = base.align(alignment)
    let cell = column.render("123", width: 5)
    #expect(cell == expected)
  }

  @Test("centering with odd column width")
  func testCenteringOddWidth() {
    let column = base.align(.center)
    let cell = column.render("123", width: 6)
    #expect(cell == " 123  ")
  }
}
