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
   
	//MARK: Public Methods
	class var sharedInstance: OnePasswordExtension {
		return _OnePasswordExtensionSharedInstance
	}
	
	func isSystemAppExtensionAPIAvailable() -> Bool {
		if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0)) {
			return NSClassFromString("NSExtensionItem") != nil
		}
		else {
			return false
		}
	}
	
	func isAppExtensionAvailable() -> Bool {
		if isSystemAppExtensionAPIAvailable() {
			return UIApplication.sharedApplication().canOpenURL(NSURL(string: "org-appextension-feature-password-management://")!)
		}
		else {
			return false
		}
	}
	
	
	//MARK: WebView field collection and filling scripts
	class var OPWebViewCollectFieldsScript:String {
		return "document.collect=n;document.elementsByOPID={};function n(d,b){function e(a,f){var c=a[f];if('string'==typeof c)return c;c=a.getAttribute(f);return'string'==typeof c?c:null}function h(a){switch(l(a.type)){case 'checkbox':return a.checked?'✓':'';case 'hidden':a=a.value;if(!a||'number'!=typeof a.length)return'';254<a.length&&(a=a.substr(0,254)+'...SNIPPED');return a;default:return a.value}}function q(a){return a.options?(a=Array.prototype.slice.call(a.options).map(function(a){var c=a.text,c=c?l(c).replace(/\\s/mg,'').replace(/[~`!@$%^&*()\\-_+=:;'\"\\[\\]|\\\\,<.>\\/?]/mg,''):null;return[c?c:null,a.value]}),{options:a}):null}function s(a){var f;for(a=a.parentElement||a.parentNode;a&&'td'!=l(a.tagName);)a=a.parentElement||a.parentNode;if(!a||void 0===a)return null;f=a.parentElement||a.parentNode;if('tr'!=f.tagName.toLowerCase())return null;f=f.previousElementSibling;if(!f||'tr'!=(f.tagName+'').toLowerCase()||f.cells&&a.cellIndex>=f.cells.length)return null;a=p(f.cells[a.cellIndex]);return a=r(a)}function x(a){var f=d.documentElement,c=a.getBoundingClientRect(),b=f.getBoundingClientRect(),e=c.left-f.clientLeft,f=c.top-f.clientTop;return a.offsetParent?0>e||e>b.width||0>f||f>b.height?t(a):(b=a.ownerDocument.elementFromPoint(e+3,f+3))?'label'===l(b.tagName)?b===y(a):b.tagName===a.tagName:!1:!1}function t(a){for(var f;a!==d&&a;a=a.parentNode)if(f=u.getComputedStyle?u.getComputedStyle(a,null):a.style,'none'===f.display||'hidden'==f.visibility)return!1;return a===d}function y(a){var f;if(a.id&&(f=z(d,\"label[for='\"+a.id.replace(/'/g,\"\\\\'\")+\"']\"))||a.name&&(f=z(d,\"label[for='\"+a.name.replace(/'/g,\"\\\\'\")+\"']\")))return p(f);for(;a&&a!=d;a=a.parentNode)if('label'===l(a.tagName))return p(a);return null}function g(a,f,c,d){void 0!==d&&d===c||null===c||void 0===c||(a[f]=c)}function l(a){return'string'===typeof a?a.toLowerCase():(''+a).toLowerCase()}function z(a,f){var c=null;try{c=a.querySelector(f)}catch(d){console.error('[COLLECT FIELDS] @ag_querySelector Exception in selector \"'+f+'\"')}return c}function A(a,f){var c=[];try{c=a.querySelectorAll(f)}catch(d){console.error('[COLLECT FIELDS] @ag_querySelectorAll Exception in selector \"'+f+'\"')}return c}var u=d.defaultView?d.defaultView:window,m=RegExp('(pin|password|passwort|kennwort|passe|contraseña|senha|密码|adgangskode|hasło|wachtwoord)','i'),F=Array.prototype.slice.call(A(d,'form')).map(function(a,d){var c={},b='__form__'+d;a.opid=b;c.opid=b;g(c,'htmlName',e(a,'name'));g(c,'htmlID',e(a,'id'));g(c,'htmlAction',v(e(a,'action')));g(c,'htmlMethod',e(a,'method'));return c}),C=Array.prototype.slice.call(A(d,'input, select')).map(function(a,f){var c={},b='__'+f,k=-1==a.maxLength?999:a.maxLength;d.elementsByOPID[b]=a;a.opid=b;c.opid=b;c.elementNumber=f;g(c,'maxLength',Math.min(k,999),999);c.visible=t(a);c.viewable=x(a);g(c,'htmlID',e(a,'id'));g(c,'htmlName',e(a,'name'));g(c,'htmlClass',e(a,'class'));if('hidden'!=l(a.type)){g(c,'label-tag',y(a));g(c,'label-data',e(a,'data-label'));g(c,'label-aria',e(a,'aria-label'));g(c,'label-top',s(a));b=[];for(k=a;k&&k.nextSibling;){k=k.nextSibling;if(w(k))break;B(b,k)}g(c,'label-right',b.join(''));b=[];D(a,b);b=b.reverse().join('');g(c,'label-left',b);g(c,'placeholder',e(a,'placeholder'))}g(c,'rel',e(a,'rel'));g(c,'type',l(e(a,'type')));g(c,'value',h(a));g(c,'checked',a.checked,!1);g(c,'autoCompleteType',a.getAttribute('x-autocompletetype')||a.getAttribute('autocompletetype')||a.getAttribute('autocomplete'),'off');g(c,'selectInfo',q(a));g(c,'aria-hidden','true'==a.getAttribute('aria-hidden'),!1);g(c,'aria-disabled','true'==a.getAttribute('aria-disabled'),!1);g(c,'aria-haspopup','true'==a.getAttribute('aria-haspopup'),!1);g(c,'data-stripe',e(a,'data-stripe'));a.form&&(c.form=e(a.form,'opid'));b=(m.test(c.value)||m.test(c.htmlID)||m.test(c.htmlName)||m.test(c.placeholder)||m.test(c['label-tag'])||m.test(c['label-data'])||m.test(c['label-aria']))&&('text'==c.type||'password'==c.type&&!c.visible);g(c,'fakeTested',b,!1);return c});C.filter(function(a){return a.fakeTested}).forEach(function(a){var b=d.elementsByOPID[a.opid];b.getBoundingClientRect();!b||b&&'function'!==typeof b.click||b.click();b.focus();E(b,'keydown');E(b,'keyup');E(b,'keypress');b.click&&b.click();a.postFakeTestVisible=t(b);a.postFakeTestViewable=x(b);a=b.ownerDocument.createEvent('HTMLEvents');var c=b.ownerDocument.createEvent('HTMLEvents');E(b,'keydown');E(b,'keyup');E(b,'keypress');c.initEvent('input',!0,!0);b.dispatchEvent(c);a.initEvent('change',!0,!0);b.dispatchEvent(a);b.blur()});return{documentUUID:b,title:d.title,url:u.location.href,forms:function(a){var b={};a.forEach(function(a){b[a.opid]=a});return b}(F),fields:C,collectedTimestamp:(new Date).getTime()}};document.elementForOPID=G;function E(d,b){var e;e=d.ownerDocument.createEvent('KeyboardEvent');e.initKeyboardEvent?e.initKeyboardEvent(b,!0,!0):e.initKeyEvent&&e.initKeyEvent(b,!0,!0,null,!1,!1,!1,!1,0,0);d.dispatchEvent(e)}function p(d){return d.textContent||d.innerText}function r(d){var b=null;d&&(b=d.replace(/^\\s+|\\s+$|\\r?\\n.*$/mg,''),b=0<b.length?b:null);return b}function B(d,b){var e;e='';3===b.nodeType?e=b.nodeValue:1===b.nodeType&&(e=p(b));(e=r(e))&&d.push(e)}function w(d){var b;d&&void 0!==d?(b='select option input form textarea button table iframe body head script'.split(' '),d?(d=d?(d.tagName||'').toLowerCase():'',b=b.constructor==Array?0<=b.indexOf(d):d===b):b=!1):b=!0;return b}function D(d,b,e){var h;for(e||(e=0);d&&d.previousSibling;){d=d.previousSibling;if(w(d))return;B(b,d)}if(d&&0===b.length){for(h=null;!h;){d=d.parentElement||d.parentNode;if(!d)return;for(h=d.previousSibling;h&&!w(h)&&h.lastChild;)h=h.lastChild}w(h)||(B(b,h),0===b.length&&D(h,b,e+1))}}function G(d){var b;if(void 0===d||null===d)return null;try{var e=Array.prototype.slice.call(H()),h=e.filter(function(b){return b.opid==d});if(0<h.length)b=h[0],1<h.length&&console.warn('More than one element found with opid '+d);else{var q=parseInt(d.split('__')[1],10);isNaN(q)||(b=e[q])}}catch(s){console.error('An unexpected error occurred: '+s)}finally{return b}};var I=/^[\\/\\?]/;function v(d){if(!d)return null;if(0==d.indexOf('http'))return d;var b=window.location.protocol+'//'+window.location.hostname;window.location.port&&''!=window.location.port&&(b+=':'+window.location.port);d.match(I)||(d='/'+d);return b+d}function H(){var d=document,b=[];try{b=d.querySelectorAll('input, select')}catch(e){console.error('[COMMON] @ag_querySelectorAll Exception in selector \"input, select\"')}return b};(function collect(uuid) { var pageDetails = document.collect(document, uuid); return JSON.stringify(pageDetails); })('uuid');"
	}
	
	class var OPWebViewFillScript:String {
		return "var f=!0,h=!0;document.fill=k;function k(a){var b,c=[],d=a.properties,e=1,g;d&&d.delay_between_operations&&(e=d.delay_between_operations);if(null!=a.savedURL&&0===a.savedURL.indexOf('https://')&&'http:'==document.location.protocol&&(b=confirm('1Password warning: This is an unsecured HTTP page, and any information you submit can potentially be seen and changed by others. This Login was originally saved on a secure (HTTPS) page.\\n\\nDo you still wish to fill this login?'),0==b))return;g=function(a,b){var d=a[0];void 0===d?b():('delay'===d.operation?e=d.parameters[0]:c.push(l(d)),setTimeout(function(){g(a.slice(1),b)},e))};if(b=a.options)h=b.animate,f=b.markFilling;a.hasOwnProperty('script')&&(b=a.script,g(b,function(){c=Array.prototype.concat.apply(c,void 0);a.hasOwnProperty('autosubmit')&&'function'==typeof autosubmit&&setTimeout(function(){autosubmit(a.autosubmit,d.allow_clicky_autosubmit)},AUTOSUBMIT_DELAY);'object'==typeof protectedGlobalPage&&protectedGlobalPage.a('fillItemResults',{documentUUID:documentUUID,fillContextIdentifier:a.fillContextIdentifier,usedOpids:c},function(){})}))}var u={fill_by_opid:m,fill_by_query:n,click_on_opid:p,click_on_query:q,touch_all_fields:r,simple_set_value_by_query:s,focus_by_opid:t,delay:null};function l(a){var b;if(a.hasOwnProperty('operation')&&a.hasOwnProperty('parameters'))b=a.operation,a=a.parameters;else if('[object Array]'===Object.prototype.toString.call(a))b=a[0],a=a.splice(1);else return null;return u.hasOwnProperty(b)?u[b].apply(this,a):null}function m(a,b){var c;return(c=v(a))?(w(c,b),c.opid):null}function n(a,b){var c;c=x(a);return Array.prototype.map.call(c,function(a){w(a,b);return a.opid},this)}function s(a,b){var c,d=[];c=x(a);Array.prototype.forEach.call(c,function(a){void 0!==a.value&&(a.value=b,d.push(a.opid))});return d}function t(a){if(a=v(a))'function'===typeof a.click&&a.click(),'function'===typeof a.focus&&a.focus();return null}function p(a){return(a=v(a))?y(a)?a.opid:null:null}function q(a){a=x(a);return Array.prototype.map.call(a,function(a){y(a);'function'===typeof a.click&&a.click();'function'===typeof a.focus&&a.focus();return a.opid},this)}function r(){z()};var A={'true':!0,y:!0,1:!0,yes:!0,'✓':!0},B=200;function w(a,b){var c;if(a&&null!==b&&void 0!==b)switch(f&&a.form&&!a.form.opfilled&&(a.form.opfilled=!0),a.type?a.type.toLowerCase():null){case 'checkbox':c=b&&1<=b.length&&A.hasOwnProperty(b.toLowerCase())&&!0===A[b.toLowerCase()];a.checked===c||C(a,function(a){a.checked=c});break;case 'radio':!0===A[b.toLowerCase()]&&a.click();break;default:a.value==b||C(a,function(a){a.value=b})}}function C(a,b){D(a);b(a);E(a);F(a)&&(a.className+=' com-agilebits-onepassword-extension-animated-fill',setTimeout(function(){a&&a.className&&(a.className=a.className.replace(/(\\s)?com-agilebits-onepassword-extension-animated-fill/,''))},B))};document.elementForOPID=v;function G(a,b){var c;c=a.ownerDocument.createEvent('KeyboardEvent');c.initKeyboardEvent?c.initKeyboardEvent(b,!0,!0):c.initKeyEvent&&c.initKeyEvent(b,!0,!0,null,!1,!1,!1,!1,0,0);a.dispatchEvent(c)}function D(a){y(a);a.focus();G(a,'keydown');G(a,'keyup');G(a,'keypress')}function E(a){var b=a.ownerDocument.createEvent('HTMLEvents'),c=a.ownerDocument.createEvent('HTMLEvents');G(a,'keydown');G(a,'keyup');G(a,'keypress');c.initEvent('input',!0,!0);a.dispatchEvent(c);b.initEvent('change',!0,!0);a.dispatchEvent(b);a.blur()}function y(a){if(!a||a&&'function'!==typeof a.click)return!1;a.click();return!0}function H(){var a=RegExp('(pin|password|passwort|kennwort|passe|contraseña|senha|密码|adgangskode|hasło|wachtwoord)','i');return Array.prototype.slice.call(x(\"input[type='text']\")).filter(function(b){return b.value&&a.test(b.value)},this)}function z(){H().forEach(function(a){D(a);a.click&&a.click();E(a)})}function F(a){var b;if(b=h)a:{b=a;for(var c=a.ownerDocument,c=c?c.defaultView:{},d;b&&b!==document;){d=c.getComputedStyle?c.getComputedStyle(b,null):b.style;if('none'===d.display||'hidden'==d.visibility){b=!1;break a}b=b.parentNode}b=b===document}return b?-1!=='email text password number tel url'.split(' ').indexOf(a.type||''):!1}function v(a){var b;if(void 0===a||null===a)return null;try{var c=Array.prototype.slice.call(x('input, select')),d=c.filter(function(b){return b.opid==a});if(0<d.length)b=d[0],1<d.length&&console.warn('More than one element found with opid '+a);else{var e=parseInt(a.split('__')[1],10);isNaN(e)||(b=c[e])}}catch(g){console.error('An unexpected error occurred: '+g)}finally{return b}};function x(a){var b=document,c=[];try{c=b.querySelectorAll(a)}catch(d){}return c};(function(ownerDocument, script){ownerDocument.fill(script); return {'success': true}; })"
	}
	
}
