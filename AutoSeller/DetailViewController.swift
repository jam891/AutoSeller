//
//  DetailViewController.swift
//  AutoSeller
//
//  Created by Vitaliy Delidov on 10/9/15.
//  Copyright © 2015 Vitaliy Delidov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let logInViewController = PFLogInViewController()
    let signUpViewController = PFSignUpViewController()
    
    var currentVehicle: Vehicle?
    var currentOwner: Owner?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        logInViewController.delegate = self
        signUpViewController.delegate = self
        logInViewController.logInView!.logo = createLogo()
        signUpViewController.signUpView!.logo = createLogo()
        logInViewController.signUpController = signUpViewController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.tableView.reloadData()
        }
    }
    
    func createLogo() -> UILabel {
        let label = UILabel()
        let font = UIFont.systemFontOfSize(40)
        label.textColor = UIColor.darkGrayColor()
        label.text = "AutoSeller"
        label.font = font
        label.sizeToFit()
        return label
    }
    
    // MARK: - LogIn LogOut
    
    func showLogInView() {
        if PFUser.currentUser() != nil {
            return
        }
        presentViewController(logInViewController, animated: true, completion: nil)
    }
    
    func logOutTapped() {
        PFUser.logOut()
        tableView.reloadData()
    }
}

// MARK: - Table View Data Sourse

extension DetailViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PFUser.currentUser() != nil ? 8 : 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Model"
            cell.detailTextLabel?.text = currentVehicle?.model
        case 1:
            let imageView = UIImageView(image: UIImage(named: "question"))
            if let imageFile = currentVehicle?.imageFile {
                imageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error != nil {
                        return
                    }
                    imageView.image = UIImage(data: imageData!)!
                    imageView.frame = cell.contentView.frame
                    imageView.contentMode = .ScaleAspectFill
                    cell.contentView.addSubview(imageView)
                })
            }
        case 2:
            cell.textLabel?.text = "Color"
            cell.detailTextLabel?.text = currentVehicle?.color
        case 3:
            cell.textLabel?.text = "Condition"
            cell.detailTextLabel?.text = currentVehicle?.condition
        case 4:
            cell.textLabel?.text = "Info Owner"
        case 5:
            cell.textLabel?.text = "Name"
            if let name = currentOwner?.name {
                cell.detailTextLabel?.text = name
            }
        case 6:
            cell.textLabel?.text = "Phone"
            if let phone = currentOwner?.phone {
                cell.detailTextLabel?.text = phone
            }
        case 7:
            cell.textLabel?.text = "Logout"
        default: break
        }
        return cell
    }
}


// MARK: - Table View Delegate

extension DetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat!
        switch indexPath.row {
        case 1: height = 160
        case 4: height = 35
        case 7: height = 35
        default: height = 44
        }
        return height
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 1:
            cell.detailTextLabel?.text = nil
        case 4:
            cell.detailTextLabel?.text = nil
            cell.backgroundColor = .grayColor()
            cell.textLabel?.textColor = .whiteColor()
        case 7:
            cell.detailTextLabel?.text = nil
            cell.backgroundColor = .grayColor()
            cell.textLabel?.textColor = .whiteColor()
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 4:
            showLogInView()
        case 7:
            logOutTapped()
        default:
            break
        }
    }
    
}


// MARK: - PFLogInViewControllerDelegate

extension DetailViewController: PFLogInViewControllerDelegate {
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if !username.isEmpty && !password.isEmpty {
            return true
        }
        let alertController = UIAlertController(title: "Missing Information", message: "Make sure you fill out all of the information!", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        logInController.presentViewController(alertController, animated: true, completion: nil)
        return false
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        let alertController = UIAlertController(title: "Failed to login...", message: "Please enter a valid password or username!", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        logInController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        
    }
}

// MARK: - PFSignUpViewControllerDelegate

extension DetailViewController: PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        var informationComlete = true
        for key in info.keys {
            let field = info[key] as! String
            if field.isEmpty {
                informationComlete = false
                break
            }
        }
        if !informationComlete {
            let alertController = UIAlertController(title: "Missing Information", message: "Make sure you fill out all of the information!", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            signUpController.presentViewController(alertController, animated: true, completion: nil)
        }
        return informationComlete
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("Failed to sign up...")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
    }
    
}
