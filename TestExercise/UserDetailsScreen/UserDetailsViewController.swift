
import UIKit
import GoogleMaps

class UserDetailsViewController: UIViewController {

    @objc func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view )
        if let view = recognizer.view {
            let newY = view.center.y + translation.y
            if newY > UIScreen.main.bounds.maxY - view.frame.height/2 {
                view.center = CGPoint(x:view.center.x, y: newY)
                ChangeHeightOfMap(changes: Int(translation.y))
            }
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    var user : UserDataModel? = nil
    private var mapView : GMSMapView!
    private var locationManager : CLLocationManager!
    private let initDetailControllerHeight = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let camera = GMSCameraPosition.camera(withTarget: userLocation, zoom: 10)
        
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
        
        let marker = GMSMarker.init(position: userLocation)
        marker.icon = UIImage.init(named: "default_marker.png")
        marker.map = mapView
        
        
        CreateShareButton()
    }

    private func CreateShareButton(){
        let shareButton = UIBarButtonItem(title: "SHARE", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func AddUserDataController(frame : CGRect) {
        let initFrame = CGRect(x: 0, y: self.view.frame.maxY, width: frame.width, height: frame.height)
        
        let childVC : UserDetailsAppearingViewController
        if !self.childViewControllers.contains(where: {viewController in return type(of : viewController) == UserDetailsAppearingViewController.self}) {
            childVC = UserDetailsAppearingViewController(nibName: "UserDetailsAppearingViewController", bundle: Bundle.main)
            addChildViewController(childVC)
            childVC.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
            childVC.SetUserData(userdata: user!)
            view.addSubview(childVC.view)
        }
        else {
            childVC = self.childViewControllers.first as! UserDetailsAppearingViewController
        }
        childVC.view.frame = initFrame
        self.mapView.frame = view.frame
        
        let mapFrame = CGRect(x: mapView.frame.minX, y: mapView.frame.minY, width: mapView.frame.width, height: mapView.frame.height - frame.height)
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] () in
            childVC.view.frame = frame
            
            self?.mapView.frame = mapFrame
        },
        completion  : { _ in childVC.didMove(toParentViewController: self)})
    }
    
    private func ChangeHeightOfMap(changes : Int){
        let frame = CGRect(x: mapView.frame.minX, y: mapView.frame.minY, width: mapView.frame.width, height: mapView.frame.height + CGFloat(changes))
        mapView.frame = frame
    }

}

extension UserDetailsViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let newFrame = CGRect(x: 0, y: Int(self.view.frame.maxY) - initDetailControllerHeight, width: Int(self.view.frame.width), height: initDetailControllerHeight)

        AddUserDataController(frame: newFrame)
        
        return false
    }
    
}
