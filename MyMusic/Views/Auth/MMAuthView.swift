//
//  MMAuthView.swift
//  MyMusic
//
//  Created by Carson Gross on 8/26/23.
//

import SwiftUI

struct MMAuthView: View {
    
    var buttonTapped: () -> Void
    
    var body: some View {
        Button {
            buttonTapped()
        } label: {
            Text("Connect Apple Music")
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding()
                .background {
                    Color.accentColor.cornerRadius(CGFloat.greatestFiniteMagnitude)
                }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        MMAuthView { }
    }
}
