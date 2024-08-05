//
//  TagsView.swift
//  FlickerSearchDemo
//
//  Created by Cory Howell on 8/4/24.
//

import SwiftUI

struct TagsView: View {
    let tags: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags.indices, id: \.self) { index in
                    Text(tags[index])
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .font(.subheadline)
                }
            }
            .padding()
        }
    }
}

#Preview {
    let tags = ["here", "are", "some", "sample", "tags"]
    return TagsView(tags: tags)
}
