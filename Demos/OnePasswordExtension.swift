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

class OnePasswordExtension: NSObject {
   
}
