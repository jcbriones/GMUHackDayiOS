//
//  AdTableViewCell.swift
//  GMU HackDayiOS
//
//  Created by John Christopher Briones on 12/2/17.
//  Copyright © 2017 John Christopher Briones. All rights reserved.
//

import UIKit

class AdTableViewCell: UITableViewCell {
	
	//MARK: Properties
	@IBOutlet weak var imageLabel: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var price: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}


