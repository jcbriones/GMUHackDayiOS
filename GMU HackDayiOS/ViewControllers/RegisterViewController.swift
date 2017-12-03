//
//  RegisterViewController.swift
//  GMU HackDayiOS
//
//  Created by John Christopher Briones on 12/2/17.
//  Copyright © 2017 John Christopher Briones. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var first_name: UITextField!
	@IBOutlet weak var last_name: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var phone: UITextField!
	@IBOutlet weak var bottomHeight: NSLayoutConstraint!
	@IBOutlet weak var registerButton: UIButton!
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
	@IBAction func onRegisterButtonPressed(_ sender: UIButton) {
		registerUser()
	}
	
	// Keyboard stuff
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// Try to find next responder
		if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
			nextField.becomeFirstResponder()
		} else {
			// Not found, so remove keyboard.
			textField.resignFirstResponder()
			registerUser()
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

	// Private funcs
	
	private func registerUser() {
		// Loading
		let loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		loadingSpinner.center = self.view.center
		self.view.addSubview(loadingSpinner)
		loadingSpinner.startAnimating()
		
		ConnectToAPI().registerUser(username: username.text!, password: password.text!, first_name: first_name.text!, last_name: last_name.text!, email: email.text!, phone: phone.text!) {
			(error) in
			if error == nil {

				// Stop loading
				loadingSpinner.stopAnimating()
				loadingSpinner.removeFromSuperview()
				
				// Successful registration
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let controller = storyboard.instantiateViewController(withIdentifier: "ValidateUserController") as! ValidateUserViewController
				controller.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
				controller.username = self.username.text!
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
