//
//  MapPointSelectViewController.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/1.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import UIKit
import Mapbox

protocol MapPointSelectReceiver {
    func receiveLocation(_ location: CLLocationCoordinate2D, _ name: String, _ description: String)
}

class MapPointSelectViewController: UIViewController {
    @IBOutlet weak var searchAddressView: UIView!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var searchBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D? = nil
    var name: String = ""
    var detail: String = ""
    var searchController: SearchAddressViewController!
    var locationReceiver: MapPointSelectReceiver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsScale = true
        mapView.style
        searchBarHeightConstraint.constant = 80
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        searchAddressView.addGestureRecognizer(panGesture)
        let longpressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        mapView.addGestureRecognizer(longpressGesture)
        manager.delegate = self
        if location != nil {
            addAnnotation(location!, name, detail)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchController = segue.destination as? SearchAddressViewController
        searchController.selectPointHandler = { marker in
            self.location = marker.location?.coordinate
            // self.name = marker.name
            self.detail = marker.qualifiedName ?? ""
            self.addAnnotation(self.location!, self.name, marker.qualifiedName)
            self.view.endEditing(true)
            self.searchBarHeightConstraint.constant = 80
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = view.frame.size.height
            let searchBarHeight = viewHeight - 200 - keyboardSize.height + 50
            var searchBarBottomSpace = keyboardSize.height - 50
            if #available(iOS 14.0, *) {
                searchBarBottomSpace = 0
            }
            self.searchBarHeightConstraint.constant = searchBarHeight
            self.searchBarBottomConstraint.constant = searchBarBottomSpace
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }) { (ret) in
                
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        self.searchBarBottomConstraint.constant = 0
        self.searchBarHeightConstraint.constant = 80
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (ret) in
        }
    }
    
    @objc
    @IBAction func longPress(_ gesture: UILongPressGestureRecognizer) {
        let location = mapView.convert(gesture.location(in: mapView), toCoordinateFrom: mapView)
        self.location = location
        self.name = ""
        self.detail = ""
        addAnnotation(location, "", "", false)
    }
    
    @objc
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let gestureView = gesture.view else {
            return
        }
        let viewHeight = view.frame.size.height
        let bottomSpace = searchBarBottomConstraint.constant
        let translation = gesture.translation(in: gestureView)
        searchBarHeightConstraint.constant -= translation.y
        if bottomSpace > 0 {
            if searchBarHeightConstraint.constant < 30 {
                searchBarHeightConstraint.constant = 30
            }
            if searchBarHeightConstraint.constant + bottomSpace > viewHeight - 30 {
                searchBarHeightConstraint.constant = viewHeight - 30 - bottomSpace
            }
            if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
                if searchBarHeightConstraint.constant < 200 {
                    searchBarHeightConstraint.constant = 80
                    searchAddressView.endEditing(true)
                } else if searchBarHeightConstraint.constant > viewHeight - 350 - bottomSpace {
                    searchBarHeightConstraint.constant = viewHeight - 200 - bottomSpace
                }
            }
        } else {
            if searchBarHeightConstraint.constant < 30 {
                searchBarHeightConstraint.constant = 30
            }
            if searchBarHeightConstraint.constant > viewHeight - 30 {
                searchBarHeightConstraint.constant = viewHeight - 30
            }
            if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
                if searchBarHeightConstraint.constant < 200 {
                    searchBarHeightConstraint.constant = 80
                    searchAddressView.endEditing(true)
                } else if searchBarHeightConstraint.constant > viewHeight - 350 {
                    searchBarHeightConstraint.constant = viewHeight - 200
                }
            }
        }
        gesture.setTranslation(.zero, in: view)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if self.location != nil && self.locationReceiver != nil {
            self.locationReceiver?.receiveLocation(self.location!, self.name, self.detail)
        }
        self.dismiss(animated: true, completion: {
            
        })
    }
    
    @IBAction func locationSelf(_ sender: Any) {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func addAnnotation(_ location: CLLocationCoordinate2D, _ title: String, _ subTitle: String?, _ moveMap: Bool=true) {
        if let oldAnnotations = mapView.annotations {
            mapView.removeAnnotations(oldAnnotations)
        }
        let annotation = MGLPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subTitle
        mapView.addAnnotation(annotation)
        if moveMap {
            self.mapView.setCenter(location, zoomLevel: 8, animated: true)
        }
    }
}

extension MapPointSelectViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
    
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        print("xxx")
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "draggablePoint") {
            return annotationView
        } else {
            return DraggableAnnotationView(reuseIdentifier: "draggablePoint", size: 30) { location in
                self.location = location
            }
        }
    }
}

extension MapPointSelectViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            manager.stopUpdatingLocation()
            manager.delegate = nil
            location = loc.coordinate
            name = ""
            detail = ""
            addAnnotation(self.location!, "", "")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
