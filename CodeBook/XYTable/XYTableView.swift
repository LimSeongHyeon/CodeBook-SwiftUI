//
//  XYTableView.swift
//  CodeBook
//
//  Created by TommyFuture on 2023/10/16.
//

import SwiftUI

struct XYTable<ColumnHeader: Identifiable, RowHeader: Identifiable, CellType: Identifiable,
                   RowContent: View, ColumnContent: View, CellContent: View>: View
 {
     var columnHeader: TimeTableHeader<ColumnHeader>
     var rowHeader: TimeTableHeader<RowHeader>
     var lines: [TimeTableLine<CellType>]
     @ObservedObject var options = XYTableOptions<ColumnHeader, RowHeader, CellType, RowContent, ColumnContent, CellContent>()
     
     var columnAmt: Int { return columnHeader.datas.count }
     var rowAmt: Int { return rowHeader.datas.count }
     var cellWidth: CGFloat { return columnHeader.width }
     var cellHeight: CGFloat { return rowHeader.height }
     
     @State private var offset = CGPoint.zero
     
     
     var body: some View
     {
         VStack(spacing: 0)
         {
             HStack(spacing: 0)
             {
                 
                 VerticalHeader()
                 VStack(alignment: .leading)
                 {
                     HorizontalHeader()
                     table.coordinateSpace(name: "scroll")
                 }
             }
         }

     }
     
     @ViewBuilder
     func HorizontalHeader() -> some View
     {
         ScrollView([.horizontal])
         {
             HStack(alignment: .top, spacing: 0)
             {
                 ForEach(columnHeader.datas)
                 {   data in
                     options.toColumnHeaderLabel?(data)
                 }.frame(width: cellWidth, height: columnHeader.height)

             }.offset(x: offset.x)
         }
         .scrollIndicators(.hidden)
         .disabled(true)

     }
     
     @ViewBuilder
     func VerticalHeader() -> some View
     {
         ScrollView([.vertical])
         {
             VStack(alignment: .leading, spacing: 0)
             {
                 if options.rowHeaderAlignment == .center
                 {
                     Spacer().frame(width: rowHeader.width, height: cellHeight/2 - self.options.correctionValue)
                 }
                 
                 ForEach(rowHeader.datas)
                 {   data in
                     options.toRowHeaderLabel?(data)
                 }
                 .frame(width: rowHeader.width, height: cellHeight)
                 
                 if options.rowHeaderAlignment == .top
                 {
                     Spacer().frame(width: rowHeader.width, height: cellHeight/2 - self.options.correctionValue)
                 }

             }.offset(y: options.rowHeaderAlignment == .center ? offset.y : offset.y - self.options.correctionValue )
         }
         .scrollIndicators(.hidden)
         .disabled(true)
     }
     
     @ViewBuilder
     func Grid() -> some View
     {
         ZStack
         {
             if options.gridOptions.contains(.horizontal)
             {
                 VStack(alignment: .leading, spacing: 0)
                 {
                     ForEach(0..<rowAmt, id: \.self)
                     {   _ in
                         Divider()
                     }.frame(height: cellHeight)
                 }
             }
             
             if options.gridOptions.contains(.vertical)
             {
                 HStack(alignment: .top, spacing: 0)
                 {
                     let gridColumn = self.options.columnHeaderAlignment == .center ? max(columnAmt-1, 0) : columnAmt
                     ForEach(0..<gridColumn, id: \.self)
                     {   _ in
                         Divider()
                     }.frame(width: cellWidth)
                 }
             }
         }
     }

     var table: some View
     {
         ScrollViewReader
         {   proxy in
             ScrollView([.vertical, .horizontal])
             {
                 ZStack(alignment: .topLeading)
                 {
                     Grid().offset(y: -cellHeight * 0.5)
                     
                     HStack(alignment: .top, spacing: 0)
                     {
                         ForEach(lines)
                         {   line in
                             Column(line)
                                 .frame(width: cellWidth)
                         }
                     }
                     .background( GeometryReader { geo in
                         Color.clear
                             .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).origin)
                     })
                     .onPreferenceChange(ViewOffsetKey.self)
                     {   value in
                         offset = value
                     }
                 }

             }.scrollIndicators(.hidden)
         }

     }
     
     @ViewBuilder
     func Column( _ column: TimeTableLine<CellType>) -> some View
     {
         ZStack(alignment: .top)
         {
             ForEach(column.datas)
             {   cell in
                 options.toCellLabel?(cell.data)
                     .frame(height: cell.height)
                     .offset(y: cell.offset + 1)
             }
         }
     }

     
     func setRowHeaderLabel(label: ((RowHeader) -> RowContent)? = nil) -> Self
     {
         self.options.toRowHeaderLabel = label
         return self
     }
     
     func setColumnHeaderLabel(label: ((ColumnHeader) -> ColumnContent)? = nil) -> Self
     {
         self.options.toColumnHeaderLabel = label
         return self
     }
     
     func setCellLabel(label: ((CellType) -> CellContent)? = nil) -> Self
     {
         self.options.toCellLabel = label
         return self
     }
     
     func setRowHeaderPosition(position: VerticalHeaderPosition) -> Self
     {
         self.options.rowHeaderPosition = position
         return self
     }
     
     func setGridOption(options: [GridType]) -> Self
     {
         self.options.gridOptions = options
         return self
     }
     
     func setTablePriority(first:TablePriority) -> Self
     {
         self.options.tablePriority = first
         return self
     }
     
     func setRowHeaderAlignment(alignment: RowHeaderAlignment) -> Self
     {
         self.options.rowHeaderAlignment = alignment
         return self
     }
     
     func setColumnHeaderAlignment(alignment: ColumnHeaderAlignment) -> Self
     {
         self.options.columnHeaderAlignment = alignment
         return self
     }
     
     func setHeaderAlignment(row rowAlign: RowHeaderAlignment? = nil, column columnAlign: ColumnHeaderAlignment? = nil) -> Self
     {
         if let rowAlign = rowAlign
         {
             self.options.rowHeaderAlignment = rowAlign
         }
         if let columnAlign = columnAlign
         {
             self.options.columnHeaderAlignment = columnAlign
         }
         return self
     }
     
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

struct XYTable_Test: View
{
    @State var hHeader: TimeTableHeader = .init(width: 120, height: 40, datas: [] as [IdentifiableString])
    @State var vHeader: TimeTableHeader = .init(width: 40, height: 120, datas: [] as [IdentifiableString])
    @State var memo: [TimeTableLine<IdentifiableString>] = []
    
    var body: some View
    {
        XYTable(columnHeader: hHeader, rowHeader: vHeader, lines: memo)
            .setHeaderAlignment(row: .top, column: .center)
            .setCellLabel{
                Text($0.content)
                    .frame(width:100, height: 120)
                    .background{Rectangle().stroke()}
            }
            .setRowHeaderLabel{Text($0.content)}
            .setColumnHeaderLabel{Text($0.content)}
            .onAppear{initData()}
            .frame(height: 500)
    }
    
    
    func initData()
    {
        for idx in 0..<20
        {
            let column = IdentifiableString("Column \(idx)")
            hHeader.datas.append(column)
            vHeader.datas.append(IdentifiableString("Row \(idx)"))
            var tableLine = TimeTableLine<IdentifiableString>(headerID: column.id, datas: [])
            for i in 0..<5
            {
                tableLine.datas.append(TimeTableCellData(height: 120, offset: CGFloat(200 * i), data: IdentifiableString("Cell")))
            }
            memo.append(tableLine)
        }
        
    }
}


struct XYTableView_Previews: PreviewProvider {
    static var previews: some View {
        XYTable_Test()
    }
}
