//
//  MMMusicAuthManager.swift
//  MyMusic
//
//  Created by Carson Gross on 8/26/23.
//

import SwiftUI
import MusicKit

/// An object for manager the authorization status of music
final class MMMusicAuthManager: ObservableObject {
    static let shared = MMMusicAuthManager()
    
    @Published var musicAuthorizationStatus = MusicAuthorization.currentStatus
    
    @MainActor
    public func update(with musicAuthorizationStatus: MusicAuthorization.Status) {
        withAnimation {
            self.musicAuthorizationStatus = musicAuthorizationStatus
        }
    }
    
    public func handleMusicAuthorization(completion: ((Bool) -> Void)? = nil) {
        switch musicAuthorizationStatus {
            case .notDetermined:
                Task {
                    let musicAuthorizationStatus = await MusicAuthorization.request()
                    await update(with: musicAuthorizationStatus)
                    completion?(musicAuthorizationStatus == .authorized)
                }
            case .denied:
                Task {
                    if let settingsURL = await URL(string: UIApplication.openSettingsURLString) {
                        await UIApplication.shared.open(settingsURL)
                        completion?(musicAuthorizationStatus == .authorized)
                    }
                }
            default:
                break
        }
    }
}
