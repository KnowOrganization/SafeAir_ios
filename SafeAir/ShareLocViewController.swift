//
//  ShareLocViewController.swift
//  SafeAir
//
//  Created by Mohammad Sami on 31/07/23.
//

import UIKit
import Firebase
import CoreLocation
import Foundation



class ShareLocViewController: UIViewController, CLLocationManagerDelegate {
    private var locationManager:CLLocationManager?
    var lat = 0.0
    var lng = 0.0
    var uid = ""
    var email = ""
    
    var ref: DatabaseReference!
    
    var timer = Timer()

    var start = false
    
    var dateString = ""

    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
    }
    
    @IBOutlet weak var latLngLable: UILabel!
    
    func getUserLocation() {
            locationManager = CLLocationManager()
            locationManager?.requestAlwaysAuthorization()
            locationManager?.delegate = self
            locationManager?.allowsBackgroundLocationUpdates = true
            locationManager?.startUpdatingLocation()
        }
    func stopUserLocation() {
            locationManager?.stopUpdatingLocation()
        }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
                lat = location.coordinate.latitude
                lng = location.coordinate.latitude
                latLngLable.text = "Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)"
            }
    }
    
    
    func getLocLoop(){
        Auth.auth().addStateDidChangeListener { [self] auth, user in
                let user = Auth.auth().currentUser
                if let user = user {
                    uid = user.uid
                    email = user.email!
                }
            
            let dateFormatter = DateFormatter()//OK!
            //From here
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "en_IN")
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")//1
            dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss a"
            dateString = dateFormatter.string(from: Date())//2
            
            self.ref.child("locations").child(uid).setValue(["email": email as Any , "latitude": locationManager?.location?.coordinate.latitude as Any, "longitude": locationManager?.location?.coordinate.longitude as Any, "status": "online", "timestamp": dateString] as [String : Any])

        }
        
    }
    func stopLocLoop(){
        Auth.auth().addStateDidChangeListener { [self] auth, user in
                let user = Auth.auth().currentUser
                if let user = user {
                    uid = user.uid
                    email = user.email!
                }
            self.ref.child("locations").child(uid).setValue(["email": email as Any , "latitude": locationManager?.location?.coordinate.latitude as Any, "longitude": locationManager?.location?.coordinate.longitude as Any, "status": "offline", "timestamp": dateString ] as [String : Any])

        }
    }
    
    @IBAction func startClicked(_ sender: UIButton) {
        getUserLocation()
        start = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
            if start {
                getLocLoop()
            }
        })
        
    }
    
    @IBAction func stopClicked(_ sender: UIButton) {
        stopUserLocation()
        start = false
        stopLocLoop()
        
    }
    
    @IBAction func logoutClicked(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "backToLogin", sender: self)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
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
