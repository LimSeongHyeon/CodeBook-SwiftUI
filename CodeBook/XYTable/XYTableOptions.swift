//
//  XYTableOptions.swift
//  CodeBook
//
//  Created by TommyFuture on 2023/10/16.
//

import Foundation
import SwiftUI

class TableOptions<ColumnHeader: Identifiable, RowHeader: Identifiable, CellType: Identifiable,
                        RowContent: View, ColumnContent: View, CellContent: View>: ObservableObject
{
    @Published var toRowHeaderLabel: ((RowHeader) -> RowContent)? = nil
    @Published var toColumnHeaderLabel: ((ColumnHeader) -> ColumnContent)? = nil
    @Published var toCellLabel: ((CellType) -> CellContent)? = nil
    
    @Published var rowHeaderPosition: VerticalHeaderPosition = .left
    @Published var gridOptions: [GridType] = [.vertical, .horizontal]
    @Published var tablePriority: TablePriority = .column
    @Published var rowHeaderAlignment: RowHeaderAlignment = .center
    @Published var columnHeaderAlignment: ColumnHeaderAlignment = .center
    @Published var correctionValue: CGFloat = 0
}


enum ColumnHeaderAlignment
{
    case center, right
}

enum RowHeaderAlignment
{
    case center, top
}

enum VerticalHeaderPosition
{
    case left, right
}

enum TablePriority
{
    case row, column
}

enum GridType: String
{
    case vertical, horizontal
}

struct ViewOffsetKey: PreferenceKey
{
    typealias Value = CGPoint
    static var defaultValue = CGPoint.zero
    static func reduce(value: inout Value, nextValue: () -> Value)
    {
        value.x += nextValue().x
        value.y += nextValue().y
    }
}
