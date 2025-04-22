//
//  TopHeader.swift
//  Polycode
//
//  Created by Eric Yu on 4/15/25.
//

import SwiftUI



struct TopHeader: View {
    var body: some View {
        HStack {
            //MARK: - language
            Button(action: {
                //go to languages screen
            }, label: {
                Image(systemName: "flag")
            })
            .border(Color(.black))

            Spacer()
            //MARK: - streak
            Button(action: {
                //go to streak screen with calendar of days you've done poly
            }, label: {
                Image(systemName: "flame")
            })
            .border(Color(.black))
            
            Spacer()
            //MARK: - currency
            Button(action: {
                //go to currency screen (idk yet)
            }, label: {
                Image(systemName: "diamond.fill")
            })
            .border(Color(.black))
            
            Spacer()
            //MARK: - hearts
            Button(action: {
                //go to lives shop, where you can buy lives with currency
            }, label: {
                Image(systemName: "heart")
            })
            .border(Color(.black))
        }
        .border(Color.red.opacity(0.3))

    }
}

#Preview {
    TopHeader()
}
