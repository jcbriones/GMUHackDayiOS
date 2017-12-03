//
//  ValidateUserViewController.swift
//  GMU HackDayiOS
//
//  Created by John Christopher Briones on 12/2/17.
//  Copyright © 2017 John Christopher Briones. All rights reserved.
//

import UIKit

class ValidateUserViewController: UIViewController {

	@IBOutlet weak var code: UITextField!
	@IBOutlet weak var validateButton: UIButton!
	let defaultValues = UserDefaults.standard
	var user:User!
	var username: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// Buttons
	@IBAction func onValidateButtonPressed(_ sender: UIButton) {
		validateUser()
	}
	
	// Keyboard stuff
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		// Not found, so remove keyboard.
		textField.resignFirstResponder()
		validateUser()
		
		// Do not add a line break
		return false
	}

	// Private funcs
	
	private func validateUser() {
		// Loading
		let loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		loadingSpinner.center = self.view.center
		self.view.addSubview(loadingSpinner)
		loadingSpinner.startAnimating()
		
		ConnectToAPI().validateUser(username: username, code: code.text!) {
			(user, error) in
			if let user = user {
				// Saving user values to defaults
				self.defaultValues.set(user.username, forKey: "username")
				self.defaultValues.set(user.firstName, forKey: "first_name")
				self.defaultValues.set(user.lastName, forKey: "last_name")
				self.defaultValues.set(user.email, forKey: "email")
				self.defaultValues.set(user.phone, forKey: "phone")
				
				// Stop loading
				loadingSpinner.stopAnimating()
				loadingSpinner.removeFromSuperview()
				
				// Successful login
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let controller = storyboard.instantiateViewController(withIdentifier: "MainMenuController") as UIViewController
				controller.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
				self.present(controller, animated: true, completion: nil)
			} else {
				// Stop loading
				loadingSpinner.stopAnimating()
				loadingSpinner.removeFromSuperview()
				
				self.alertUser("Login", err: error)
			}
		}
	}
	
	private func alertUser(_ msg: String, err: String?) {
		let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		
		alert.addAction(cancelAction)
		self.present(alert, animated: true, completion: nil)
	}
	
}
