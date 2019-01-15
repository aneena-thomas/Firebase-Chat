//
//  ChatReceiverTableViewCell.swift
//  FirebaseChat
//
//  Created by aneena on 14/01/19.
//  Copyright © 2019 Experion. All rights reserved.
//

import UIKit

class ChatReceiverTableViewCell: UITableViewCell {
    @IBOutlet weak var receiverMessageTextView: UITextView!
    @IBOutlet weak var lastTimeLabel: UILabel!
    @IBOutlet weak var receiverImageView: UIImageView!
    @IBOutlet weak var receiverView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setLayout(){
        self.receiverImageView.layer.cornerRadius = 20
        self.receiverView.layer.cornerRadius = 10

    }
}
