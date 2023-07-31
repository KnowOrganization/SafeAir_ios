//
//  LoginViewController.swift
//  SafeAir
//
//  Created by Mohammad Sami on 30/07/23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { [self] auth, user in
            let user = Auth.auth().currentUser
            if user != nil {
                self.performSegue(withIdentifier: "alreadyLogedIn", sender: self)
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: "sami@email.com", password: "sami1234"){ firebaseResult, error in
            if let e = error{
                print("error")
                print(e)
            }
            else{
                self.performSegue(withIdentifier: "goToShareLoc", sender: self)
            }
        }
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
