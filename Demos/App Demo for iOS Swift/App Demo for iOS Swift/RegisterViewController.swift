//
//  RegisterViewController.swift
//  App Demo for iOS Swift
//
//  Created by Rad Azzouz on 2015-05-14.
//  Copyright (c) 2015 Agilebits. All rights reserved.
//

import Foundation

class RegisterViewController: UIViewController {
	@IBOutlet weak var onepasswordButton: UIButton!
	@IBOutlet weak var firstnameTextField: UITextField!
	@IBOutlet weak var lastnameTextField: UITextField!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let patternImage = UIImage(named: "register-background.png") {
			self.view.backgroundColor = UIColor(patternImage: patternImage)
		}
		
		self.onepasswordButton.isHidden = !OnePasswordExtension.shared().isAppExtensionAvailable()
	}

	override var preferredStatusBarStyle : UIStatusBarStyle {
		return UIStatusBarStyle.default
	}

	@IBAction func saveLoginTo1Password(_ sender: Any) -> Void {
		let newLoginDetails: [String: Any] = [
			AppExtensionTitleKey: "ACME",
			AppExtensionUsernameKey: self.usernameTextField.text!,
			AppExtensionPasswordKey: self.passwordTextField.text!,
			AppExtensionNotesKey: "Saved with the ACME app",
			AppExtensionSectionTitleKey: "ACME Browser",
			AppExtensionFieldsKey: [
				"firstname" : self.firstnameTextField.text!,
				"lastname" : self.lastnameTextField.text!
				// Add as many string fields as you please.
			]
		]

		// The password generation options are optional, but are very handy in case you have strict rules about password lengths, symbols and digits.
		let passwordGenerationOptions: [String: Any] = [
			// The minimum password length can be 4 or more.
			AppExtensionGeneratedPasswordMinLengthKey: 8,
			
			// The maximum password length can be 50 or less.
			AppExtensionGeneratedPasswordMaxLengthKey: 30,
			
			// If YES, the 1Password will guarantee that the generated password will contain at least one digit (number between 0 and 9). Passing NO will not exclude digits from the generated password.
			AppExtensionGeneratedPasswordRequireDigitsKey: true,
			
			// If YES, the 1Password will guarantee that the generated password will contain at least one symbol (See the list bellow). Passing NO with will exclude symbols from the generated password.
			AppExtensionGeneratedPasswordRequireSymbolsKey: true,
			
			// Here are all the symbols available in the the 1Password Password Generator:
			// !@#$%^&*()_-+=|[]{}'\";.,>?/~`
			// The string for AppExtensionGeneratedPasswordForbiddenCharactersKey should contain the symbols and characters that you wish 1Password to exclude from the generated password.
			AppExtensionGeneratedPasswordForbiddenCharactersKey: "!@#$%/0lIO"
		]
		
		OnePasswordExtension.shared().storeLogin(forURLString: "https://www.acme.com", loginDetails: newLoginDetails, passwordGenerationOptions: passwordGenerationOptions, for: self, sender: sender) { (loginDictionary, error) -> Void in
            guard let loginDictionary = loginDictionary else {
                if let error = error as? NSError {
                    if error.code != Int(AppExtensionErrorCodeCancelledByUser) {
                        print("Error invoking 1Password App Extension for find login: \(error)")
                    }
                }
                return
            }

			self.usernameTextField.text = loginDictionary[AppExtensionUsernameKey] as? String
			self.passwordTextField.text = loginDictionary[AppExtensionPasswordKey] as? String
            self.firstnameTextField.text = (loginDictionary[AppExtensionReturnedFieldsKey] as? [String: Any])?["firstname"] as? String
			self.lastnameTextField.text = (loginDictionary[AppExtensionReturnedFieldsKey] as? [String: Any])?["lastname"] as? String
		}
	}
}
