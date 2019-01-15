//
//  ListScene.swift
//  FirebaseChat
//
//  Created by aneena on 14/01/19.
//  Copyright © 2019 Experion. All rights reserved.
//

import UIKit
import Alamofire

class ListScene: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var presenter:ListPresenter = {
        ListPresenter()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //replace arun by userid from api
        self.presenter.senderUserId = "arun"
        self.getChatList()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    func getChatList(){
        let url = "https://engagedxb-qa.firebaseapp.com/api/v1/chattedUsersList/\(self.presenter.senderUserId)"
        print("url",url)
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                if let data = response.result.value as? [NSDictionary]{
                print("respresponseJsononse",data)
                self.presenter.listArry = data
                self.tableView.reloadData()
            }
            case .failure(let error): print(error)
            }
        }
    }
//listTableView

}

extension ListScene : UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.y =", scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.presenter.listArry.count == 0{
            return 0
        }
        else
        {
            return self.presenter.listArry.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTableView", for: indexPath)
        let dataArray = self.presenter.listArry[indexPath.row]
        cell.textLabel?.text = dataArray["userName"] as? String
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bridge : NavigationExtension = NavigationExtension.sharedInstance;
        let controller = bridge.getChatSceneViewController()
        controller.presenter.chatDisplayName = self.presenter.listArry[indexPath.row]["userName"] as! String
        controller.presenter.receiverUserId = self.presenter.listArry[indexPath.row]["userId"] as! String
        controller.presenter.chatId = self.presenter.listArry[indexPath.row]["chatId"] as! String
        controller.presenter.senderUserId = self.presenter.senderUserId

        self.navigationController?.pushViewController(controller, animated: true)

    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
}
