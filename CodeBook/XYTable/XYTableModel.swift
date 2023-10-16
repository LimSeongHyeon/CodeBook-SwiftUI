//
//  XYTableModel.swift
//  CodeBook
//
//  Created by TommyFuture on 2023/10/16.
//

import Foundation

// RowHeader or Column Header
struct TimeTableHeader<T: Identifiable>
{
    var width: CGFloat
    var height: CGFloat
    var spacing: CGFloat = 0
    var datas: [T]
}

// one cell Data
struct TimeTableCellData<T>: Identifiable
{
    var id = UUID()
    var length: CGFloat
    var offset: CGFloat
    var data: T
}

// one Row or one Column
struct TimeTableLine<T: Identifiable>: Identifiable
{
    var id = UUID()
    var headerID: UUID
    var datas: [TimeTableCellData<T>]
}


