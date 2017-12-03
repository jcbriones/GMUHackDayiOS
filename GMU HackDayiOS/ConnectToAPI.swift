//
//  ConnectToAPI.swift
//  GMU HackDayiOS
//
//  Created by John Christopher Briones on 12/2/17.
//  Copyright © 2017 John Christopher Briones. All rights reserved.
//

import Foundation
import Alamofire

final class ConnectToAPI {
	let API_URL = "https://netcomm.fourguystech.com/api_hackaday/"
	
	func getAds(completion: @escaping ([Ad]?, String?) -> Void) {
		Alamofire.request(
			URL(string: API_URL)!,
			method: .get,
			parameters: ["type": "get_ads"])
			.validate()
			.responseJSON { response in
				
				switch (response.result) {
				case .success:
					if let result = response.result.value {
						let jsonData = result as! NSArray
						var ads = [Ad]()
						
						for item in jsonData { // loop through data items
							let obj = item as! NSDictionary
							let ad = Ad(title: obj.value(forKey: "title") as! String,
										desc: obj.value(forKey: "desc") as! String,
										price: obj.value(forKey: "price") as! String,
										seller: obj.value(forKey: "seller") as! String,
										location: obj.value(forKey: "location") as! String,
										image: obj.value(forKey: "image") as! String)!
							ads.append(ad)
						}
						completion(ads, nil)
					}
					break
				case .failure(let error):
					completion(nil, "\(error.localizedDescription)")
					break
				}
		}
	}
	
	func registerUser(username: String, password: String, first_name: String, last_name: String, email: String, phone: String, completion: @escaping (String?) -> Void) {
		Alamofire.request(
			URL(string: API_URL)!,
			method: .get,
			parameters: ["type": "register_user",
						 "username": username,
						 "password": password,
						 "first_name": first_name,
						 "last_name": last_name,
						 "email": email,
						 "phone": phone
			])
			.validate()
			.responseJSON { response in
				switch (response.result) {
				case .success:
					if let result = response.result.value {
						let jsonData = result as! NSDictionary
						
						// If there is no error from the jsonData
						if !(jsonData.value(forKey: "error") as! Bool) {
							completion(nil)
						} else {
							//completion("There is an error checking out the equipment. Please try again")
							// Get error from the error message passed from the API
							completion((jsonData.value(forKey: "error_msg") as! String))
						}
					}
					break
				case .failure(let error):
					completion("\(error.localizedDescription)")
					break
				}
		}
	}
	
	func checkIn(barcode: String, completion: @escaping (String?) -> Void) {
		Alamofire.request(
			URL(string: API_URL)!,
			method: .post,
			parameters: ["type": "check_in",
						 "barcode": barcode
			])
			.validate()
			.responseJSON { response in
				
				switch (response.result) {
				case .success:
					if let result = response.result.value {
						let jsonData = result as! NSDictionary
						
						// If there is no error from the jsonData
						if !(jsonData.value(forKey: "error") as! Bool) {
							completion(nil)
						} else {
							//completion("There is an error checking in the equipment. Please try again")
							// Get error from the error message passed from the API
							completion((jsonData.value(forKey: "error_msg") as! String))
						}
					}
					break
				case .failure(let error):
					completion("\(error.localizedDescription)")
					break
				}
		}
	}
	
	func userLookUp(username: String, completion: @escaping (User?, String?) -> Void) {
		Alamofire.request(
			URL(string: API_URL)!,
			method: .get,
			parameters: ["type": "get_user",
						 "username": username
			])
			.validate()
			.responseJSON { response in
				
				switch (response.result) {
				case .success:
					if let result = response.result.value {
						let jsonData = result as! NSDictionary
						
						// If there is no error from the jsonData
						if(!(jsonData.value(forKey: "error") as! Bool)) {
							// Getting data from response
							let obj = jsonData.value(forKey: "user") as! NSDictionary
							
							let user = User(username: obj.value(forKey: "username") as! String,
											firstName: obj.value(forKey: "first_name") as! String,
											lastName: obj.value(forKey: "last_name") as! String,
											email: obj.value(forKey: "email") as! String,
											phone: obj.value(forKey: "phone") as! String)!
							completion(user, nil)
						} else {
							//completion(nil, "The user is not found in the database")
							// Get error from the error message passed from the API
							completion(nil, (jsonData.value(forKey: "error_msg") as! String))
						}
					}
					break
				case .failure(let error):
					completion(nil, "\(error.localizedDescription)")
					break
				}
				
		}
	}
	
	func userLogin(username: String, password: String, completion: @escaping (User?, String?) -> Void) {
		Alamofire.request(
			URL(string: API_URL)!,
			method: .post,
			parameters: ["type": "login_user",
						 "username": username,
						 "password": password
			])
			.validate()
			.responseJSON { response in
				
				switch (response.result) {
				case .success:
					if let result = response.result.value {
						let jsonData = result as! NSDictionary
						
						// If there is no error from the jsonData
						if !(jsonData.value(forKey: "error") as! Bool) {
							// Getting data from response
							let obj = jsonData.value(forKey: "user") as! NSDictionary
							
							let user = User(username: obj.value(forKey: "username") as! String,
											firstName: obj.value(forKey: "first_name") as! String,
											lastName: obj.value(forKey: "last_name") as! String,
											email: obj.value(forKey: "email") as! String,
											phone: obj.value(forKey: "phone") as! String)!
							completion(user, nil)
						} else {
							//completion(nil, "The username or password is incorrect. Please try again")
							// Get error from the error message passed from the API
							completion(nil, (jsonData.value(forKey: "error_msg") as! String))
						}
					}
					break
				case .failure(let error):
					completion(nil, "\(error.localizedDescription)")
					break
				}
				
		}
	}
	
	func validateUser(username: String, code: String, completion: @escaping (User?, String?) -> Void) {
		Alamofire.request(
			URL(string: API_URL)!,
			method: .get,
			parameters: ["type": "validate_user",
						 "username": username,
						 "code": code
			])
			.validate()
			.responseJSON { response in
				
				switch (response.result) {
				case .success:
					if let result = response.result.value {
						let jsonData = result as! NSDictionary
						
						// If there is no error from the jsonData
						if !(jsonData.value(forKey: "error") as! Bool) {
							// Getting data from response
							let obj = jsonData.value(forKey: "user") as! NSDictionary
							
							let user = User(username: obj.value(forKey: "username") as! String,
											firstName: obj.value(forKey: "first_name") as! String,
											lastName: obj.value(forKey: "last_name") as! String,
											email: obj.value(forKey: "email") as! String,
											phone: obj.value(forKey: "phone") as! String)!
							completion(user, nil)
						} else {
							//completion(nil, "The username or password is incorrect. Please try again")
							// Get error from the error message passed from the API
							completion(nil, (jsonData.value(forKey: "error_msg") as! String))
						}
					}
					break
				case .failure(let error):
					completion(nil, "\(error.localizedDescription)")
					break
				}
				
		}
	}
	
}
