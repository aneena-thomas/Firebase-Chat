//
//  NavigationExtension.swift
//  FirebaseChat
//
//  Created by aneena on 15/01/19.
//  Copyright © 2019 Experion. All rights reserved.
//

import UIKit

class NavigationExtension: NSObject {
    
    @objc static let sharedInstance: NavigationExtension = NavigationExtension()
    
    @objc private func getMainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
}
extension NavigationExtension{
    
    
    
    @objc func getChatSceneViewController() -> ChatScene {
        let storyboard = self.getMainStoryboard()
        return storyboard.instantiateViewController(withIdentifier: "ChatScene") as! ChatScene
    }
    
    
}
