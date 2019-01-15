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

class ChatScene: UIViewController {
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var ChattableView: UITableView!
    @IBOutlet weak var bottomViewContraits: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    var placeholderLabel : UILabel!

    let db = Firestore.firestore()

    let COLLECTION_KEY = "Chat"
    let DOCUMENT_KEY = "Message"
    let TEXT_FIELD = "Text"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initView()
    }

    func initView(){
        self.placeholderCreation()
        self.textViewSettings()
        self.tableViewSettings()
 FirebaseFirestore.getInstance().collection(COLLECTION_KEY).document(DOCUMENT_KEY)
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
        
        self.ChattableView.rowHeight = UITableViewAutomaticDimension
        self.ChattableView.estimatedRowHeight = 100
    }
    
    @IBAction func sendAction(_ sender: Any) {
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
            placeholderLabel.isHidden = messageTextView.text.isEmpty
            self.messageTextView.text = ""
            self.ChattableView.reloadData()
            self.view.endEditing(true)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            sendButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
}

extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.y =", scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.chatArray.count == 0{
            return 0
        }
        else
        {
            return self.chatArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiverTableViewCell", for: indexPath) as! ChatReceiverTableViewCell
        
                return cell
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
}
