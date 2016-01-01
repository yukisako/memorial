//
//  ViewController.swift
//  Memorial
//
//  Created by 迫 佑樹 on 2016/01/01.
//  Copyright © 2016年 迫 佑樹. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!
    
    @IBOutlet var textField: UITextField!
    
    var manager :CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        } else {
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["lon"]!).doubleValue
            
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            
            let latDelta: CLLocationDegrees = 0.01
            let lonDelta: CLLocationDegrees = 0.01
            
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            
            let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            self.map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            if places[activePlace]["explain"] != "説明がありません" {
                annotation.title = places[activePlace]["explain"]
            } else {
                annotation.title = places[activePlace]["name"]
            }
            
            self.map.addAnnotation(annotation)
        }
        


        

        
        

    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var userLocation: CLLocation!
        
        userLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        self.map.setRegion(region, animated: true)
        
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
    
        uilpgr.minimumPressDuration = 2.0
        
        map.addGestureRecognizer(uilpgr)
    }
    
    
    func action(gestureRecognizer: UIGestureRecognizer){
        //複数回の長押しが検出されないようにする
        if gestureRecognizer.state == UIGestureRecognizerState.Began{
            
            let touchPoint = gestureRecognizer.locationInView(self.map)
            let newCoordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            //住所を経度,緯度から求める
            var location: CLLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                var title = ""
                
                if (error != nil){
                    print(error)
                } else {
                    if let p = placemarks?[0]{
                        var subThoroughfare: String = ""
                        var thoroughfare: String = ""
                        
                        if p.subThoroughfare != nil{
                            subThoroughfare = p.subThoroughfare!
                        }
                        
                        if p.thoroughfare != nil{
                            thoroughfare = p.thoroughfare!
                        }
                        
                        title = "\(subThoroughfare) \(thoroughfare)"
                     

                    }
                    
                }
                
                if title == "" {
                    
                    title = "added \(NSDate())"
                    
                }
                
                print(self.textField.text!)
                
                print(places)
                //アノテーション(説明書き)を作る
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate


                
                if let explain = self.textField.text {
                    if explain != ""{
                        places.append(["explain" :"\(explain)","name" :title, "lat" :"\(newCoordinate.latitude)", "lon" :"\(newCoordinate.longitude)"])
                        annotation.title = explain
                    } else {
                        places.append(["explain":"説明がありません","name" :title, "lat" :"\(newCoordinate.latitude)", "lon" :"\(newCoordinate.longitude)"])
                        annotation.title = title
                    }
                }else{
                        places.append(["explain":"説明がありません","name" :title, "lat" :"\(newCoordinate.latitude)", "lon" :"\(newCoordinate.longitude)"])
                        annotation.title = title
                }
                
                self.map.addAnnotation(annotation)


                
                
            })
            
            
            
            

        
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}

