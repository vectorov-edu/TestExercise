//
//  UserDetailsViewController.swift
//  TestExercise
//
//  Created by Admin on 05.01.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleMaps

class UserDetailsViewController: UIViewController {

    @IBOutlet weak internal var dropDownView: DropDownView! {
        didSet {
            dropDownView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
            
        }
    }
    //@IBOutlet weak internal var dropViewGestureRecognizer: UIPanGestureRecognizer!
    @objc func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view )
        if let view = recognizer.view {
            let newY = view.center.y + translation.y
            if newY > UIScreen.main.bounds.maxY - view.frame.height/2 {
                view.center = CGPoint(x:view.center.x,
                                      y: newY)
            }
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc func handleViewPan(recognizer:UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: recognizer.view)
//        print("recognizer: \(translation.y)")
//        if let view = dropDownView {
//            self.view.bringSubview(toFront: view) //.center = CGPoint(x:view.center.x + translation.x,y:view.center.y + translation.y)
//            var newDropDownY = CGFloat(0)
//            if translation.y < 0 {
//                newDropDownY = max(UIScreen.main.bounds.maxY - view.frame.height/2 , view.center.y + translation.y)
//            }
//            else {
//                newDropDownY = min(UIScreen.main.bounds.maxY + view.frame.height/2, view.center.y + translation.y)
//            }
//
//            dropDownView.center = CGPoint(x:view.center.x,y: newDropDownY)
//        }
//        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    var user : UserDataModel? = nil
    private var mapView : GMSMapView!
    private var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dropViewGestureRecognizer.delegate = self
        let panView = UIPanGestureRecognizer(target: self, action: #selector(handleViewPan(recognizer:)))
        view.addGestureRecognizer(panView)
        
        var userLocation = CLLocationCoordinate2D.init()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        
        if let _ = user?.latitude, let _ = user?.longitude {
            userLocation = CLLocationCoordinate2D.init(latitude: user!.latitude!, longitude: user!.longitude!)
        } else if let position = locationManager.location {
            userLocation = CLLocationCoordinate2D.init(latitude: position.coordinate.latitude, longitude: position.coordinate.longitude)
        }
        
        var camera = GMSCameraPosition.camera(withTarget: userLocation, zoom: 10)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        //mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        //mapView.isHidden = true
        mapView.frame = view.frame
        
        view.addSubview(mapView)
        mapView.isHidden = false
        mapView.camera = camera
        
        mapView.settings.consumesGesturesInView = false
        
        var marker = GMSMarker.init(position: userLocation)
        marker.icon = UIImage.init(named: "default_marker.png")
        marker.map = mapView
        
        
        CreateShareButton()
    }

    private func CreateShareButton(){
        if navigationItem != nil{
            let shareButton = UIBarButtonItem(title: "SHARE", style: .plain, target: nil, action: nil)
            navigationItem.rightBarButtonItem = shareButton
        }
    }

}

extension UserDetailsViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let frame = CGRect(x: dropDownView.frame.minX, y: UIScreen.main.bounds.maxY, width: dropDownView.frame.width, height: dropDownView.frame.height)
        dropDownView.frame = frame
        let newFrame = CGRect(x: dropDownView.frame.minX, y: UIScreen.main.bounds.maxY - 40, width: dropDownView.frame.width, height: dropDownView.frame.height)
        self.view.bringSubview(toFront: dropDownView)

        UIView.animate(withDuration: 0.5, animations: {[weak self, newFrame] () in
            self?.dropDownView.frame = newFrame
        })
        
        return false
    }
}
