import AsciiTable
import InlineSnapshotTesting
import XCTest

final class TableTests: XCTestCase {
  func testIncludesColumnHeaders() {
    let table = Table<(String, String)> {
      Column("A") { $0.0 }
      Column("B") { $0.1 }
    }
    let data = [
      ("1A", "1B"),
      ("2A", "2B"),
    ]
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ┌────┬────┐
      │ A  │ B  │
      ├────┼────┤
      │ 1A │ 1B │
      ├────┼────┤
      │ 2A │ 2B │
      └────┴────┘
      """
    }
  }

  func testIncludesBlankColumnHeaders() {
    let table = Table<(String, String)> {
      Column("A") { $0.0 }
      Column { $0.1 }
    }
    let data = [
      ("1A", "1B"),
      ("2A", "2B"),
    ]
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ┌────┬────┐
      │ A  │    │
      ├────┼────┤
      │ 1A │ 1B │
      ├────┼────┤
      │ 2A │ 2B │
      └────┴────┘
      """
    }
  }

  func testOmitsHeaderRowWhenNoHeaders() {
    let table = Table<(String, String)> {
      Column { $0.0 }
      Column { $0.1 }
    }
    let data = [
      ("1A", "1B"),
      ("2A", "2B"),
    ]
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ┌────┬────┐
      │ 1A │ 1B │
      ├────┼────┤
      │ 2A │ 2B │
      └────┴────┘
      """
    }
  }

  func testColumnWidths() {
    let table = Table<[String]> {
      Column { $0[0] }.width(.atLeast(3))
      Column { $0[1] }.width(.upTo(5))
      Column { $0[2] }.width(.between(5, and: 8))
      Column { $0[3] }.width(.between(3, and: 5))
      Column { $0[4] }.width(3)
      Column { $0[5] }.width(.maxContent)
    }
    let data = [
      ["A", "AAAAAAAA", "A", "AAAAAAAA", "A", "A"],
      ["BB", "BBBBB", "BBBB", "BBBBBB", "BBBBB", "BBBB"],
      ["CC", "CCC", "CCC", "CCC", "CCC", "CCC"],
    ]
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ┌─────┬───────┬───────┬───────┬─────┬──────┐
      │ A   │ AAAA… │ A     │ AAAA… │ A   │ A    │
      ├─────┼───────┼───────┼───────┼─────┼──────┤
      │ BB  │ BBBBB │ BBBB  │ BBBB… │ BB… │ BBBB │
      ├─────┼───────┼───────┼───────┼─────┼──────┤
      │ CC  │ CCC   │ CCC   │ CCC   │ CCC │ CCC  │
      └─────┴───────┴───────┴───────┴─────┴──────┘
      """
    }
  }

  func testHorizontalPadding() {
    let table = Table<(String, String, String)> {
      Column { $0.0 }.padding(.none)
      Column { $0.1 }.padding(3)
      Column { $0.2 }.padding(.init(left: 1, right: 2))
    }
    let data = [
      ("1A", "1B", "1C"),
      ("2A", "2B", "2C"),
    ]
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ┌──┬────────┬─────┐
      │1A│   1B   │ 1C  │
      ├──┼────────┼─────┤
      │2A│   2B   │ 2C  │
      └──┴────────┴─────┘
      """
    }
  }

  func testHorizontalAlignment() {
    let table = Table<(String, String, String)> {
      Column { $0.0 }
        .width(5)
        .align(.left)
      Column { $0.1 }
        .width(5)
        .align(.center)
      Column { $0.2 }
        .width(5)
        .align(.right)
    }
    let data = [
      ("1A", "1B", "1C"),
      ("2A", "2B", "2C"),
    ]
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ┌───────┬───────┬───────┐
      │ 1A    │  1B   │    1C │
      ├───────┼───────┼───────┤
      │ 2A    │  2B   │    2C │
      └───────┴───────┴───────┘
      """
    }
  }

  func testDefaultEmptyState() {
    let table = Table<(String, String)> {
      Column("Name") { $0.0 }
      Column("Email") { $0.1 }
    }
    assertInlineSnapshot(of: table.render([]), as: .lines) {
      """
      ┌──────┬───────┐
      │ Name │ Email │
      ├──────┴───────┤
      │ No data      │
      └──────────────┘
      """
    }
  }

  func testCustomEmptyState() {
    let table = Table<(String, String)> {
      Column("Name") { $0.0 }
      Column("Email", content: \.1)
    }.empty("No users")
    assertInlineSnapshot(of: table.render([]), as: .lines) {
      """
      ┌──────┬───────┐
      │ Name │ Email │
      ├──────┴───────┤
      │ No users     │
      └──────────────┘
      """
    }
  }

  func testConditionalColumn() {
    let includeColumnB = false
    let table1 = Table<(String, String, String)> {
      Column("A") { $0.0 }
      if includeColumnB {
        Column("B") { $0.1 }
      }
      Column("C") { $0.2 }
    }

    let data = [
      ("1A", "1B", "1C"),
      ("2A", "2B", "2C"),
    ]

    assertInlineSnapshot(of: table1.render(data), as: .lines) {
      """
      ┌────┬────┐
      │ A  │ C  │
      ├────┼────┤
      │ 1A │ 1C │
      ├────┼────┤
      │ 2A │ 2C │
      └────┴────┘
      """
    }

    let table2 = Table<(String, String, String)> {
      Column("A") { $0.0 }
      if includeColumnB {
        Column("B") { $0.1 }
      } else {
        Column("C") { $0.2 }
      }
    }

    assertInlineSnapshot(of: table2.render(data), as: .lines) {
      """
      ┌────┬────┐
      │ A  │ C  │
      ├────┼────┤
      │ 1A │ 1C │
      ├────┼────┤
      │ 2A │ 2C │
      └────┴────┘
      """
    }
  }
}
