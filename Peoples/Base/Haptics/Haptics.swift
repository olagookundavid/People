//
//  Haptics.swift
//  Peoples
//
//  Created by David OH on 03/07/2023.
//

import Foundation
import UIKit

fileprivate final class HapticsManager{
    static let shared = HapticsManager()
    
    private let feedback = UINotificationFeedbackGenerator()
    
    private init(){}
    
    func trigger(notification: UINotificationFeedbackGenerator.FeedbackType){
        feedback.notificationOccurred(notification)
    }
}


func haptic(notification: UINotificationFeedbackGenerator.FeedbackType){
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hapticsEnabled){
        HapticsManager.shared.trigger(notification: notification)
    }
}
