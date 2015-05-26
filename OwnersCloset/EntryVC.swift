//
//  EntryVC.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/9/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EntryVC: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
   
    @IBOutlet weak var menuBtn: UIBarButtonItem!
 
    
    override func viewDidAppear(animated: Bool) {
        
        //loginVC
        
        if PFUser.currentUser() == nil {
            var loginVC = PFLogInViewController()
            
            loginVC.fields = (PFLogInFields.UsernameAndPassword
                | PFLogInFields.LogInButton
                | PFLogInFields.SignUpButton
                | PFLogInFields.PasswordForgotten
                | PFLogInFields.DismissButton
                | PFLogInFields.Facebook)
            
            loginVC.facebookPermissions = ["public_profile", "email"]
            
            let logoView = UIImageView(image: UIImage(named:"ocLogo50"))
            loginVC.logInView?.logo = logoView
            loginVC.delegate = self
            
            //signup controller
            
            loginVC.signUpController?.fields = (PFSignUpFields.UsernameAndPassword
                | PFSignUpFields.Email)
            loginVC.signUpController?.signUpView?.logo = logoView
            loginVC.signUpController?.delegate = self
            
            
            self.presentViewController(loginVC, animated: true, completion: nil)
        }

    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        isReadyToPurchase()
        
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me?fields=picture,first_name,last_name,email", parameters: nil)
        graphRequest.startWithCompletionHandler({
            connection, result, error in
            
                if error != nil {
                    println(error.localizedDescription)
                }
                else {
                    // assign fb
                    
                    user["firstName"] = result!["first_name"]
                    user["lastName"] = result!["last_name"]
                    
                    user.email = (result!["email"] as! String)
                    
                    let pictureURL:String = ((result["picture"] as! NSDictionary) ["data"] as! NSDictionary) ["url"] as! String
                    let url = NSURL(string: pictureURL)
                    let request = NSURLRequest(URL: url!)

                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        response, data, error in
                        if error != nil {
                            println(error.localizedDescription)
                        }
                        else if data != nil {
                            let imageFile = PFFile(name: "avatar.jpg", data: data)
                            user["picture"] = imageFile
                            user.saveInBackgroundWithBlock{
                                success, error in
                                if success == true {
                                    fetchUserOwnerPlaces()
                                }
                            }
                        }
                    })

                }
            })
        self.dismissViewControllerAnimated(true, completion: nil)
        }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        if error != nil {
            println(error?.localizedDescription)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
