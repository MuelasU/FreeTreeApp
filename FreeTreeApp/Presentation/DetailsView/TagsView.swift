//
//  TagsView.swift
//  FreeTreeApp
//
//  Created by Ercília Regina Silva Dantas on 12/07/22.
//

import SwiftUI

struct TagsView: View {
    var tags: [Tag]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(getRows(), id:\.self) { rows in
                HStack( spacing: 6){
                    ForEach(rows){ row in
                        RowView(tag: row)
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40, alignment: .leading)
    }
    
    @ViewBuilder
    func RowView(tag: Tag) -> some View {
        Text(tag.text)
            .font(.system(size: 12))
            .padding(.horizontal, 5)
            .padding(.vertical, 5)
            .background(Capsule().fill(.white))
            .foregroundColor(.green)
            .lineLimit(1)
    }
    
    func getRows() -> [[Tag]] {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        var totalWidth: CGFloat = 0
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 40
        
        tags.forEach{ tag in
            totalWidth += (tag.size + 5 + 5 + 6 + 6) // add paddings and spacing
            if totalWidth > screenWidth {
                totalWidth = 0
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
            } else{
                currentRow.append(tag)
            }
        }
        
        if !currentRow.isEmpty{
            rows.append(currentRow)
            currentRow.removeAll()
        }
        
        return rows
    }
}
