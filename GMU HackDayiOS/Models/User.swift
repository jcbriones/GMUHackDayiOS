//
//  User.swift
//  GMU HackDayiOS
//
//  Created by John Christopher Briones on 12/2/17.
//  Copyright © 2017 John Christopher Briones. All rights reserved.
//

import UIKit

class User {
	
	//MARK: Properties
	
	var username: String
	var firstName: String
	var lastName: String
	var email: String
	var phone: String
	
	//MARK: Initialization
	
	init?(username: String, firstName: String, lastName: String, email: String, phone: String) {
		
		// The name must not be empty
		guard !username.isEmpty else {
			return nil
		}
		
		// Initialize stored properties.
		self.username = username
		self.firstName = firstName
		self.lastName = lastName
		self.email = email
		self.phone = phone
	}
}

