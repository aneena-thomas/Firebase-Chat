//
//  ChatSenderTableViewCell.swift
//  FirebaseChat
//
//  Created by aneena on 14/01/19.
//  Copyright © 2019 Experion. All rights reserved.
//

import UIKit

class ChatSenderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var senderMessageTextView: UITextView!
    @IBOutlet weak var lastTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
