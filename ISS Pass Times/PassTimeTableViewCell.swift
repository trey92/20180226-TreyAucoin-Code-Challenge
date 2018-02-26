//
//  PassTimeTableViewCell.swift
//  ISS Pass Times
//
//  Created by Trey Aucoin on 2/25/18.
//

import UIKit

class PassTimeTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "PassTimeCell"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
