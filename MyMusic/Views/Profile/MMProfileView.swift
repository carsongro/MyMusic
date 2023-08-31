//
//  MMProfileView.swift
//  MyMusic
//
//  Created by Carson Gross on 8/26/23.
//

import SwiftUI

struct MMProfileView: View {
    let viewModel: MMProfileViewViewModel
    
    @StateObject var authManger = MMMusicAuthManager.shared
    
    private var shouldShowAuthProfileOption: Bool {
        switch authManger.musicAuthorizationStatus {
        case .notDetermined, .denied:
            return true
        default:
            return false
        }
    }
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let iconImage = viewModel.image {
                    Image(uiImage: iconImage)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .padding(8)
                        .background(Color(uiColor: viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                
                Text(viewModel.title)
                    .padding(.leading, 10)
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

struct MMProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MMProfileView(viewModel: .init(cellViewModels: MMProfileOption.allCases.compactMap {
            MMProfileViewCellViewModel(type: $0) { _ in
                
            }
        }))
    }
}
