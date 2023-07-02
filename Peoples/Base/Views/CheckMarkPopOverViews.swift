//
//  CheckMarkPopOverViews.swift
//  Peoples
//
//  Created by David OH on 02/07/2023.
//

import SwiftUI

struct CheckMarkPopOverViews: View {
    var body: some View {
        Symbols.checkmark
            .font(.system(.largeTitle,design: .rounded))
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10,style: .continuous))
    }
}

struct CheckMarkPopOverViews_Previews: PreviewProvider {
    static var previews: some View {
        CheckMarkPopOverViews()
            .previewLayout(.sizeThatFits)
            .padding()
        
    }
}
