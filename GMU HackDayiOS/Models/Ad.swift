//
//  Ad.swift
//  GMU HackDayiOS
//
//  Created by John Christopher Briones on 12/2/17.
//  Copyright © 2017 John Christopher Briones. All rights reserved.
//

import UIKit

class Ad {
	
	//MARK: Properties
	
	var title: String
	var desc: String
	var price: String
	var seller: String
	var location: String
	var image: String
	
	//MARK: Initialization
	
	init?(title: String, desc: String, price: String, seller: String, location: String, image: String) {
		
		// The title must not be empty
		guard !title.isEmpty else {
			return nil
		}
		
		// Initialize stored properties.
		self.title = title
		self.desc = desc
		self.price = price
		self.seller = seller
		self.location = location
		self.image = image
	}
	
}
