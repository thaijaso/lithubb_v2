//
//  ViewController.swift
//  nav_test
//
//  Created by mac on 9/14/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate, NSURLSessionDelegate {

//    Outlets for registration
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        //        delegate this viewcontroller so we can press return to dismiss keyboard. This can be made cleaner by putting all the outputs in a collection. Saving time, though.
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneTextField.delegate = self
        self.passTextField.delegate = self
        self.confirmPassTextField.delegate = self
        self.emailErrorLabel.hidden = true
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func emailIsUniqueValidate(sender: AnyObject) {
        
        if validateEmail(emailTextField.text!) {
            if let urlToReq = NSURL(string: "http://lithubb.herokuapp.com/findUser") {
                let request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
                request.HTTPMethod = "POST"
                // Get all info from textfields to send to node server
                let bodyData = "email=\(emailTextField.text!)"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response, data, error) in
                    let dataToPrint = JSON(data: data!)
                    if String(dataToPrint) == String("user exists") {
                        self.emailTextField.layer.borderColor = UIColor.redColor().CGColor
                        self.emailTextField.layer.borderWidth = 2
                        self.emailErrorLabel.textColor = UIColor.redColor()
                        self.emailErrorLabel.text = "*email is not unique"
                        self.emailErrorLabel.hidden = false
                    } else {
                        self.emailErrorLabel.hidden = true
                    }
                }
            }
        }
        
    }
    
    //Disappears keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //changes to regestration view
    @IBAction func signInButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("SignIn", sender: sender)
    }

    //registers user and goes to orders view
    @IBAction func registerButtonPressed(sender: UIButton) {
        if let isValidLogin = validateLogin(emailTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, phone: phoneTextField.text!, password: passTextField.text!, passConfirm: confirmPassTextField.text!) {
            self.presentViewController(isValidLogin, animated: true, completion: nil)
        } else {
        // this is where I've been changing the scheme to https
            if let urlToReq = NSURL(string: "http://lithubb.herokuapp.com/addUser") {
                let request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
                request.HTTPMethod = "POST"
                // Get all info from textfields to send to node server
                let bodyData = "first_name=\(firstNameTextField.text!)&last_name=\(lastNameTextField.text!)&email=\(emailTextField.text!)&password=\(passTextField.text!)&phone=\(phoneTextField.text!)"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response, data, error) in
                    let dataToPrint = JSON(data: data!)
                    print(dataToPrint,"here")
                    print(dataToPrint.type)
                    if String(dataToPrint) == String("duplicate user") {
                        print("nosegue")
                        self.showSimpleAlertWithMessage("duplicate email")
                    } else {
                        print("segue")
                        self.performSegueWithIdentifier("UserAuthenticated", sender: sender)
                    }
                }
                
            }
        }
    }
    
    
//    had to use this helper to quick solve a problem presenting an alert upon submission of a duplicate email.
    func showSimpleAlertWithMessage(message: String!) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        
        alertController.addAction(cancel)
        
        if self.presentedViewController == nil {
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //text fields are checking on "Edit Changed". All textfields are connected to this method.
    @IBAction func liveTextFieldValidate(sender: AnyObject) {
        liveColorValidation(emailTextField.text!, password: passTextField.text!, passConfirm: confirmPassTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, phone: phoneTextField.text!)
    }

    func liveColorValidation(email: String, password: String, passConfirm: String, firstName: String, lastName: String, phone: String) {
        if !validateEmail(email) {
            emailTextField.layer.borderWidth = 2
            emailTextField.layer.borderColor = UIColor.redColor().CGColor
        } else {
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.borderColor = UIColor.greenColor().CGColor
        }
        if !validatePassword(password) {
            passTextField.layer.borderWidth = 2
            passTextField.layer.borderColor = UIColor.redColor().CGColor
        } else {
            passTextField.layer.borderWidth = 1
            passTextField.layer.borderColor = UIColor.greenColor().CGColor
        }
        if !validateConfirm(passConfirm) {
            confirmPassTextField.layer.borderWidth = 2
            confirmPassTextField.layer.borderColor = UIColor.redColor().CGColor
        } else {
            confirmPassTextField.layer.borderWidth = 1
            confirmPassTextField.layer.borderColor = UIColor.greenColor().CGColor
        }
        if !validateName(firstName) {
            firstNameTextField.layer.borderWidth = 2
            firstNameTextField.layer.borderColor = UIColor.redColor().CGColor
        } else {
            firstNameTextField.layer.borderWidth = 1
            firstNameTextField.layer.borderColor = UIColor.greenColor().CGColor
        }
        if !validateName(lastName) {
            lastNameTextField.layer.borderWidth = 2
            lastNameTextField.layer.borderColor = UIColor.redColor().CGColor
        } else {
            lastNameTextField.layer.borderWidth = 1
            lastNameTextField.layer.borderColor = UIColor.greenColor().CGColor
        }
        if !validatePhone(phone) {
            phoneTextField.layer.borderWidth = 2
            phoneTextField.layer.borderColor = UIColor.redColor().CGColor
        } else {
            phoneTextField.layer.borderWidth = 1
            phoneTextField.layer.borderColor = UIColor.greenColor().CGColor
        }

    }
    
    
    
    //helper function for email validation
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
    //helper function for password validation
    func validatePassword(candidate: String) -> Bool {
        let passwordRegex = "^[a-zA-Z]\\w{5,14}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluateWithObject(candidate)
    }
    
    func validateConfirm(candidate: String) -> Bool {
        let passwordRegex = "^[a-zA-Z]\\w{5,14}$"
        if self.confirmPassTextField.text! != self.passTextField.text! {
            return false
        } else {
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluateWithObject(candidate)
        }
    }
    
    //helper function for names validation
    func validateName(candidate: String) -> Bool {
        let nameRegex = "^[a-zA-Z]+(([\\'\\,\\.\\-][a-zA-Z])?[a-zA-Z]*)*$"
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluateWithObject(candidate)
    }
    
    func validatePhone(candidate: String) -> Bool {
        let phoneRegex = "^1?[-\\. ]?(\\(\\d{3}\\)?[-\\. ]?|\\d{3}?[-\\. ]?)?\\d{3}?[-\\. ]?\\d{4}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluateWithObject(candidate)
    }
    
    //total VALIDATION ALERT helper combining the other validation helpers. Returns an alert controller if validation fails.
    func validateLogin(email: String, firstName: String, lastName: String, phone: String, password: String, passConfirm: String) -> UIAlertController? {
        let emailIsValid = validateEmail(email)
        let passwordIsValid = validatePassword(password)
        let confirmIsValid = validatePassword(passConfirm)
        let firstNameIsValid = validateName(firstName)
        let lastNameIsValid = validateName(lastName)
        let phoneIsValid = validatePhone(phone)
        //if ALL are bad
        if emailIsValid == false && passwordIsValid == false && lastNameIsValid == false && phoneIsValid == false && confirmIsValid == false && firstNameIsValid == false {
            let alert = UIAlertController(title: "Login Error", message: "Please enter valid information.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            return alert
            //only EMAIL is bad
        } else if emailIsValid == false {
            let alert = UIAlertController(title: "Registration Error", message: "Please enter a valid email", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            return alert
            //only PASSWORD is bad
        } else if passwordIsValid == false {
            let alert = UIAlertController(title: "Registration Error", message: "Please enter a valid password. Accepted characters: letters, numbers and underscore Allowed Length: 5-14 characters" , preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            return alert
            //only CONFIRM is bad
        } else if confirmIsValid == false {
            let alert = UIAlertController(title: "Registration Error", message: "Confirm password must match password.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            return alert
            //Only NAMES are bad
        } else if firstNameIsValid == false || lastNameIsValid == false {
            let alert = UIAlertController(title: "Registration Error", message: "First and Last names are required. Please use only letters and the following symbols: . , ' - >", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            return alert
        } else if phoneIsValid == false {
            let alert = UIAlertController(title: "Registration Error", message: "Sorry, we currently only accept valid US phone numbers", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            return alert
        }
        return nil
    }
    
    
}

