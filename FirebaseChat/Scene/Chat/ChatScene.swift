//
//  ChatScene.swift
//  FirebaseChat
//
//  Created by aneena on 13/01/19.
//  Copyright © 2019 Experion. All rights reserved.
//

import UIKit
import FirebaseFirestore
import ReverseExtension
import FirebaseDatabase
import Alamofire

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

class ChatScene: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var ChattableView: UITableView!
    @IBOutlet weak var bottomViewContraits: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    var placeholderLabel : UILabel!


    let COLLECTION_KEY = "Chat"
    let DOCUMENT_KEY = "Message"
    let TEXT_FIELD = "Text"

    var presenter:ChatPresenter = {
        ChatPresenter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initView()

    }

    func initView(){
        self.placeholderCreation()
        self.textViewSettings()
        self.titleText.text = self.presenter.chatDisplayName
        self.getChatInfo()
        self.tableViewSettings()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func placeholderCreation(){
        messageTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = " "+"Type a message..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (messageTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        messageTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
    }
    
    func getChatInfo(){
        let url = "https://engagedxb-qa.firebaseapp.com/api/v1/chat/\(self.presenter.chatId)"
        print("url",url)
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                print("response.result",response.result)
                print("response.data",response.data)

                print("response.result.value",response.result.value)
                if let data = response.result.value as? NSDictionary{
                    print("respresponseJsononse",data)
                    self.presenter.chatArray = data
                    self.presenter.messageArray = data["messages"] as! [NSDictionary]
                    self.ChattableView.reloadData()
                    print("count",self.presenter.chatArray.count)
                    print("self.presenter.messageArray",self.presenter.messageArray.count)
                    print("array",self.presenter.chatArray)
                    print("messageArray",self.presenter.messageArray)

                }
            //                self.presenter.listArry.append(response as [String:String])
            case .failure(let error): print(error)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            sendButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        }
        else{
            sendButton.setTitleColor(UIColor(red: 42/255, green: 220/255, blue: 171/255, alpha: 1), for: UIControl.State.normal)
        }
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func textViewSettings (){
        self.messageTextView.layer.borderWidth = CGFloat(0.5)
        self.messageTextView.layer.borderColor = UIColor.darkGray.cgColor
        self.messageTextView.layer.cornerRadius = CGFloat(13)
    }
    
    func tableViewSettings(){
        ChattableView.re.dataSource = self
        ChattableView.re.delegate = self
        
        ChattableView.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
        }
        ChattableView.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }
        
        self.ChattableView.rowHeight = UITableView.automaticDimension
        self.ChattableView.estimatedRowHeight = 100
    }
    
    @IBAction func sendAction(_ sender: Any) {
        let url = "https://us-central1-engagedxb-qa.cloudfunctions.net/postChat"
        let parameters: [String: String] = [
            "chatId" : self.presenter.chatId,
            "senderId" : self.presenter.senderUserId,
            "messageBody" : self.messageTextView.text,
            "messageTime" : "1547534504"
        ]
        print("parameters",parameters)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .success:
                    print(response)
                    self.getChatInfo()
                case .failure(let error): print(error)
                }
        }

        placeholderLabel.isHidden = messageTextView.text.isEmpty
        self.messageTextView.text = ""
        self.ChattableView.reloadData()
        self.view.endEditing(true)
        sendButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let db = Firestore.firestore()

        db.collection("Chats").document(self.presenter.chatId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                self.getChatInfo()
//                self.ChattableView.reloadData()
        }
    }
    
    func dateToString(dateTime:NSDate) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "hh:mm a"
        let strDateSelect = dateFormatter.string(from: dateTime as Date)
        return strDateSelect
    }
    
    func stringToDate(dateExpiry:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date (from: dateExpiry)
        return date!
    }
}

extension ChatScene:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("print1")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("print2")
    }

}
extension ChatScene : UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.y =", scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.presenter.messageArray.count == 0{
            return 0
        }
        else
        {
            return self.presenter.messageArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let messgeDetailsArray = self.presenter.messageArray[indexPath.row]
            if messgeDetailsArray["sentBy"] as? String == self.presenter.senderUserId{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSenderTableViewCell", for: indexPath) as! ChatSenderTableViewCell
            print("messgeDetailsArray",messgeDetailsArray)
            cell.senderMessageTextView.text = messgeDetailsArray["messageBody"] as? String
            cell.sendView.layer.cornerRadius = 10
    //        if let time = messgeDetailsArray["messageTime"] as? String{
    //            let milisecond = Double(Double)
    //            let dateTimeStamp = NSDate(timeIntervalSince1970:milisecond/1000)
    //            let strDateSelect = self.dateToString(dateTime: dateTimeStamp)
    //            cell.lastTimeLabel.text = strDateSelect
    //        }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiverTableViewCell", for: indexPath) as! ChatReceiverTableViewCell
            //        let dataArray = self.presenter.chatArray
            print("messgeDetailsArray",messgeDetailsArray)
            cell.receiverMessageTextView.text = messgeDetailsArray["messageBody"] as? String
            cell.receiverView.layer.cornerRadius = 10

            return cell

        }
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
}
