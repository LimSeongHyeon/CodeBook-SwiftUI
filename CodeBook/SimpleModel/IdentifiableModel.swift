//
//  IdentifiableModel.swift
//  CodeBook
//
//  Created by TommyFuture on 2023/10/16.
//

import Foundation

struct IdentifiableString: Identifiable, Equatable, Hashable
{
    let id = UUID()
    var content : String
    
    init( _ content: String)
    {
        self.content = content
    }
}
