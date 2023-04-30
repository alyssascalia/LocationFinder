//
//  ViewController.swift
//  LocationFinder
//
//  Created by Alyssa Scalia on 4/24/23.
//

import UIKit
import CoreLocation
import WebKit //project navigator / build phases

class ViewController: UIViewController,
CLLocationManagerDelegate {

    @IBOutlet var yesVoteCounter: UILabel!
    
    @IBOutlet var noVoteCounter: UILabel!
    
    
    @IBOutlet var winner: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        yesVoteCounter.text = String((parent as! TBViewController).yesVote)
        noVoteCounter.text = String((parent as! TBViewController).noVote)
        
        if (parent as! TBViewController).yesVote > (parent as! TBViewController).noVote
        {
            winner.text = "Yes, I think I will!"
        } else {
            winner.text = "No, I will not."
        }
        
    }
    
    
    
    
    
    @IBOutlet var distanceLabel: UILabel!
    
    
    @IBOutlet var webView: WKWebView!
    
    
    
    
    @IBAction func openSite(_ sender: Any) {
        if let url = URL(string: "https://campyolijwa.org/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    let locMan: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    //camp location
    let campLatitutde: CLLocationDegrees = 40.2790063949
    let campLongitude: CLLocationDegrees = -77.4224320002
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation: CLLocation=locations[0]
        NSLog("Something is happening")
        
        //horizontal accuarcy less than 0 means failure at gps level
        if newLocation.horizontalAccuracy >= 0 {
            let camp:CLLocation = CLLocation(latitude: campLatitutde, longitude: campLongitude)
            let delta:CLLocationDistance = camp.distance(from: newLocation)
            let miles: Double = (delta * 0.000621371) + 0.5 //meters to rounded miles
            
            if miles < 3 {
                locMan.stopUpdatingLocation()
                //congradulate the user
                distanceLabel.text = "Enjoy Camp YoliJwa!"
            } else {
                let commaDelimited: NumberFormatter = NumberFormatter()
                commaDelimited.numberStyle = NumberFormatter.Style.decimal
                
                distanceLabel.text = commaDelimited.string(from: NSNumber(value: miles))!+" miles to Camp YoliJwa"
            }
        }
        
        else{
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locMan.delegate = self
        locMan.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locMan.distanceFilter = 1609; //a mile (in meters)
        locMan.requestWhenInUseAuthorization() //verify access to gps
        locMan.startUpdatingLocation()
        startLocation = nil
        
        let myURL = URL(string: "https://campyolijwa.org/")
        let myRequest = URLRequest (url: myURL!)
        webView.load(myRequest)
        
        
    }


}

