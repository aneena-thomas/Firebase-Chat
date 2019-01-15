//
//  ListPresenter.swift
//  FirebaseChat
//
//  Created by aneena on 14/01/19.
//  Copyright © 2019 Experion. All rights reserved.
//

import UIKit
import Alamofire

class ListPresenter: NSObject {
    var listArry = [NSDictionary]()
    var senderUserId = String()
    
    func getChatlist(onFailure failure: @escaping (_ error: String?) -> Void,completionHandler: @escaping (String?,Int?) -> Void){
       
    }

}

