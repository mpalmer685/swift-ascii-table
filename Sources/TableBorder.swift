public protocol TableBorder {
  var headerTopLeft: String { get }
  var headerTopRight: String { get }
  var headerBottomLeft: String { get }
  var headerBottomRight: String { get }

  var headerHorizontalEdge: String { get }
  var headerVerticalEdge: String { get }
  var headerVerticalDivider: String { get }

  var headerTopJunction: String { get }
  var headerBottomJunction: String { get }
  var headerInnerJunction: String { get }

  var bodyTopLeft: String { get }
  var bodyTopRight: String { get }
  var bodyBottomLeft: String { get }
  var bodyBottomRight: String { get }

  var bodyHorizontalEdge: String { get }
  var bodyVerticalEdge: String { get }
  var bodyVerticalDivider: String { get }
  var bodyHorizontalDivider: String { get }

  var bodyTopJunction: String { get }
  var bodyBottomJunction: String { get }
  var bodyLeftJunction: String { get }
  var bodyRightJunction: String { get }
  var bodyInnerJunction: String { get }
}

public extension TableBorder {
  var headerTopLeft: String { bodyTopLeft }
  var headerTopRight: String { bodyTopRight }
  var headerBottomLeft: String { bodyLeftJunction }
  var headerBottomRight: String { bodyRightJunction }

  var headerHorizontalEdge: String { bodyHorizontalEdge }
  var headerVerticalEdge: String { bodyVerticalEdge }
  var headerVerticalDivider: String { bodyVerticalDivider }

  var headerTopJunction: String { bodyTopJunction }
  var headerBottomJunction: String { bodyBottomJunction }
  var headerInnerJunction: String { bodyInnerJunction }

  var bodyHorizontalEdge: String { bodyHorizontalDivider }
  var bodyVerticalEdge: String { bodyVerticalDivider }
}

public struct SingleLineBorder: TableBorder {
  public let bodyTopLeft: String = "┌"
  public let bodyTopRight = "┐"
  public let bodyBottomLeft: String = "└"
  public let bodyBottomRight: String = "┘"

  public let bodyHorizontalDivider = "─"
  public let bodyVerticalDivider = "│"

  public let bodyTopJunction = "┬"
  public let bodyLeftJunction = "├"
  public let bodyRightJunction = "┤"
  public let bodyBottomJunction = "┴"
  public let bodyInnerJunction = "┼"
}

public extension TableBorder where Self == SingleLineBorder {
  static var single: Self { SingleLineBorder() }
}

public struct DoubleLineBorder: TableBorder {
  public let bodyTopLeft = "╔"
  public let bodyTopRight = "╗"
  public let bodyBottomLeft = "╚"
  public let bodyBottomRight = "╝"

  public let bodyHorizontalEdge = "═"
  public let bodyVerticalEdge = "║"
  public let bodyHorizontalDivider = "─"
  public let bodyVerticalDivider = "│"

  public let bodyTopJunction = "╤"
  public let bodyLeftJunction = "╟"
  public let bodyRightJunction = "╢"
  public let bodyBottomJunction = "╧"
  public let bodyInnerJunction = "┼"

  public let headerBottomLeft = "╠"
  public let headerBottomRight = "╣"
  public let headerInnerJunction = "╪"
}

public extension TableBorder where Self == DoubleLineBorder {
  static var double: Self { DoubleLineBorder() }
}

public struct HeavyLightBorder: TableBorder {
  public let bodyTopLeft = "┏"
  public let bodyTopRight = "┓"
  public let bodyBottomLeft = "┗"
  public let bodyBottomRight = "┛"

  public let bodyHorizontalEdge = "━"
  public let bodyVerticalEdge = "┃"
  public let bodyHorizontalDivider = "─"
  public let bodyVerticalDivider = "│"

  public let bodyTopJunction = "┯"
  public let bodyLeftJunction = "┠"
  public let bodyRightJunction = "┨"
  public let bodyBottomJunction = "┷"
  public let bodyInnerJunction = "┼"

  public let headerBottomLeft = "┣"
  public let headerBottomRight = "┫"

  public let headerVerticalDivider = "┃"

  public let headerTopJunction = "┳"
  public let headerInnerJunction = "╇"
  public let headerBottomJunction = "┻"
}

public extension TableBorder where Self == HeavyLightBorder {
  static var heavyLight: Self { HeavyLightBorder() }
}

public struct EmptyBorder: TableBorder {
  public let bodyTopLeft = ""
  public let bodyTopRight = ""
  public let bodyBottomLeft = ""
  public let bodyBottomRight = ""

  public let bodyHorizontalDivider = ""
  public let bodyVerticalDivider = ""

  public let bodyTopJunction = ""
  public let bodyLeftJunction = ""
  public let bodyRightJunction = ""
  public let bodyBottomJunction = ""
  public let bodyInnerJunction = ""
}

public extension TableBorder where Self == EmptyBorder {
  static var none: Self { EmptyBorder() }
}
