import AsciiTable
import InlineSnapshotTesting
import XCTest

final class TableBorderTests: XCTestCase {
  let base = Table<(String, String, String)> {
    Column("A") { $0.0 }
    Column("B") { $0.1 }
    Column("C") { $0.2 }
  }

  let data = [
    ("1A", "1B", "1C"),
    ("2A", "2B", "2C"),
  ]

  func testSingleBorder() {
    let table = base.border(.single)
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ┌────┬────┬────┐
      │ A  │ B  │ C  │
      ├────┼────┼────┤
      │ 1A │ 1B │ 1C │
      ├────┼────┼────┤
      │ 2A │ 2B │ 2C │
      └────┴────┴────┘
      """
    }
  }

  func testSingleBorderEmpty() {
    let table = base.border(.single).empty("")
    assertInlineSnapshot(of: table.render([]), as: .lines) {
      """
      ┌───┬───┬───┐
      │ A │ B │ C │
      ├───┴───┴───┤
      │           │
      └───────────┘
      """
    }
  }

  func testDoubleBorder() {
    let table = base.border(.double)
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ╔════╤════╤════╗
      ║ A  │ B  │ C  ║
      ╠════╪════╪════╣
      ║ 1A │ 1B │ 1C ║
      ╟────┼────┼────╢
      ║ 2A │ 2B │ 2C ║
      ╚════╧════╧════╝
      """
    }
  }

  func testDoubleBorderEmpty() {
    let table = base.border(.double).empty("")
    assertInlineSnapshot(of: table.render([]), as: .lines) {
      """
      ╔═══╤═══╤═══╗
      ║ A │ B │ C ║
      ╠═══╧═══╧═══╣
      ║           ║
      ╚═══════════╝
      """
    }
  }

  func testHeavyLightBorder() {
    let table = base.border(.heavyLight)
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ┏━━━━┳━━━━┳━━━━┓
      ┃ A  ┃ B  ┃ C  ┃
      ┣━━━━╇━━━━╇━━━━┫
      ┃ 1A │ 1B │ 1C ┃
      ┠────┼────┼────┨
      ┃ 2A │ 2B │ 2C ┃
      ┗━━━━┷━━━━┷━━━━┛
      """
    }
  }

  func testHeavyLightBorderEmpty() {
    let table = base.border(.heavyLight).empty("")
    assertInlineSnapshot(of: table.render([]), as: .lines) {
      """
      ┏━━━┳━━━┳━━━┓
      ┃ A ┃ B ┃ C ┃
      ┣━━━┻━━━┻━━━┫
      ┃           ┃
      ┗━━━━━━━━━━━┛
      """
    }
  }

  func testNoBorder() {
    let table = base.border(.none)
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
       A   B   C  
       1A  1B  1C 
       2A  2B  2C 
      """
    }
  }

  func testNoBorderEmpty() {
    let table = base.border(.none).empty("")
    assertInlineSnapshot(of: table.render([]), as: .lines) {
      """
       A  B  C 

      """
    }
  }
}

final class TableBorderWithoutHeaderTests: XCTestCase {
  let base = Table<(String, String, String)> {
    Column { $0.0 }
    Column { $0.1 }
    Column { $0.2 }
  }

  let data = [
    ("1A", "1B", "1C"),
    ("2A", "2B", "2C"),
  ]

  func testSingleBorder() {
    let table = base.border(.single)
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ┌────┬────┬────┐
      │ 1A │ 1B │ 1C │
      ├────┼────┼────┤
      │ 2A │ 2B │ 2C │
      └────┴────┴────┘
      """
    }
  }

  func testSingleBorderEmpty() {
    let table = base.border(.single).empty("")
    assertInlineSnapshot(of: table.render([]), as: .lines) {
      """
      ┌────────┐
      │        │
      └────────┘
      """
    }
  }

  func testDoubleBorder() {
    let table = base.border(.double)
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ╔════╤════╤════╗
      ║ 1A │ 1B │ 1C ║
      ╟────┼────┼────╢
      ║ 2A │ 2B │ 2C ║
      ╚════╧════╧════╝
      """
    }
  }

  func testDoubleBorderEmpty() {
    let table = base.border(.double).empty("")
    assertInlineSnapshot(of: table.render([]), as: .lines) {
      """
      ╔════════╗
      ║        ║
      ╚════════╝
      """
    }
  }

  func testHeavyLightBorder() {
    let table = base.border(.heavyLight)
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
      ┏━━━━┯━━━━┯━━━━┓
      ┃ 1A │ 1B │ 1C ┃
      ┠────┼────┼────┨
      ┃ 2A │ 2B │ 2C ┃
      ┗━━━━┷━━━━┷━━━━┛
      """
    }
  }

  func testHeavyLightBorderEmpty() {
    let table = base.border(.heavyLight).empty("")
    assertInlineSnapshot(of: table.render([]), as: .lines) {
      """
      ┏━━━━━━━━┓
      ┃        ┃
      ┗━━━━━━━━┛
      """
    }
  }

  func testNoBorder() {
    let table = base.border(.none)
    assertInlineSnapshot(of: table.render(data), as: .lines) {
      """
       1A  1B  1C 
       2A  2B  2C 
      """
    }
  }

  func testNoBorderEmpty() {
    let table = base.border(.none).empty("")
    assertInlineSnapshot(of: table.render([]), as: .lines) {
      """
              
      """
    }
  }
}

// Use Swift Testing when https://github.com/pointfreeco/swift-snapshot-testing/discussions/930 is
// resolved
// struct TableBorderTests {
//     let base = Table<(String, String, String)> {
//         Column("A") { $0.0 }
//     }

//     let data = [
//         ("1A", "1B", "1C"),
//         ("2A", "2B", "2C"),
//     ]

//     @Test("single")
//     func testSingle() {
//         let table = base.border(.single)
//         assertInlineSnapshot(of: table.render(data), as: .lines)
//     }
// }
