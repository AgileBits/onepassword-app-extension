//
//  OnePasswordExtension.swift
//  App Demo for iOS
//
//  Created by Diego Márquez Arzate on 3/27/15.
//  Copyright (c) 2015 Diego. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import WebKit

//MARK: - Public Constants

// Login Dictionary keys
let AppExtensionURLStringKey = "url_string"
let AppExtensionUsernameKey = "username"
let AppExtensionPasswordKey = "password"
let AppExtensionTitleKey = "login_title"
let AppExtensionNotesKey = "notes"
let AppExtensionSectionTitleKey = "section_title"
let AppExtensionFieldsKey = "fields"
let AppExtensionReturnedFieldsKey = "returned_fields"
let AppExtensionOldPasswordKey = "old_password"
let AppExtensionPasswordGereratorOptionsKey = "password_generator_options"

// Password Generator options
let AppExtensionGeneratedPasswordMinLengthKey = "password_min_length"
let AppExtensionGeneratedPasswordMaxLengthKey = "password_max_length"

// Errors
let AppExtensionErrorDomain = "OnePasswordExtension"

let AppExtensionErrorCodeCancelledByUser = 0
let AppExtensionErrorCodeAPINotAvailable = 1
let AppExtensionErrorCodeFailedToContactExtension = 2
let AppExtensionErrorCodeFailedToLoadItemProviderData = 3
let AppExtensionErrorCodeCollectFieldsScriptFailed = 4
let AppExtensionErrorCodeFillFieldsScriptFailed = 5
let AppExtensionErrorCodeUnexpectedData = 6
let AppExtensionErrorCodeFailedToObtainURLStringFromWebView = 7

// Note to creators of libraries or frameworks:
// If you include this code within your library, then to prevent potential duplicate symbol
// conflicts for adopters of your library, you should rename the OnePasswordExtension class.
// You might to so by adding your own project prefix, e.g., MyLibraryOnePasswordExtension.


//MARK: - Private Constants

// Version
private let VERSION_NUMBER = 112
private let AppExtensionVersionNumberKey = "version_number"

// Available App Extension Actions
private let kUTTypeAppExtensionFindLoginAction = "org.appextension.find-login-action"
private let kUTTypeAppExtensionSaveLoginAction = "org.appextension.save-login-action"
private let kUTTypeAppExtensionChangePasswordAction = "org.appextension.change-password-action"
private let kUTTypeAppExtensionFillWebViewAction = "org.appextension.fill-webview-action"
private let kUTTypeAppExtensionFillBrowserAction = "org.appextension.fill-browser-action"

// WebView Dictionary keys
private let AppExtensionWebViewPageFillScript = "fillScript"
private let AppExtensionWebViewPageDetails = "pageDetails"

private let _OnePasswordExtensionSharedInstance = OnePasswordExtension()

//MARK: - 
class OnePasswordExtension: NSObject {
   
}
