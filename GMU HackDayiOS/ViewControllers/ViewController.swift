//
//  ViewController.swift
//  GMU HackDayiOS
//
//  Created by John Christopher Briones on 12/2/17.
//  Copyright © 2017 John Christopher Briones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var bottomHeight: NSLayoutConstraint!
	@IBOutlet weak var loginButton: UIButton!
	let defaultValues = UserDefaults.standard
	var user:User!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// Buttons
	@IBAction func onLoginButtonPressed(_ sender: UIButton) {
		loginUser(username: username.text!, password: password.text!)
	}
	
	// Keyboard stuff
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// Try to find next responder
		if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
			nextField.becomeFirstResponder()
		} else {
			// Not found, so remove keyboard.
			textField.resignFirstResponder()
			loginUser(username: username.text!, password: password.text!)
		}
		// Do not add a line break
		return false
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		view.layoutIfNeeded()
		bottomHeight.constant = 250.0
		
		UIView.animate(withDuration: 0.5, animations: {
			self.view.layoutIfNeeded()
		})
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		view.layoutIfNeeded()
		bottomHeight.constant = 0.0
		
		UIView.animate(withDuration: 0.5, animations: {
			self.view.layoutIfNeeded()
		})
	}
	
	@IBAction func unwindToLogin(sender: UIStoryboardSegue) {
		// Clear logins from inputs
		username.text = ""
		password.text = ""
		user = nil
	}
	
	// Private funcs
	
	private func loginUser(username: String, password: String) {
		// Loading
		let loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		loadingSpinner.center = self.view.center
		self.view.addSubview(loadingSpinner)
		loadingSpinner.startAnimating()
		
		ConnectToAPI().userLogin(username: username, password: password) {
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

