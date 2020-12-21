//
//  MapPointViewController.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/9/17.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation
import NVActivityIndicatorView

class MapPointViewController: UIViewController {
    @IBOutlet weak var mapView: MGLMapView!
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D? = nil
    var name: String = ""
    var detail: String = ""
    var activityView: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsScale = true
        manager.delegate = self
        activityView = NVActivityIndicatorView(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 50, height: 50)), type: .ballClipRotate, color: UIColor.red)
        view.addSubview(activityView!)
        if location != nil {
            addAnnotation(location!, name, detail)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityView?.center = view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = name
        self.parent?.navigationController?.navigationBar.topItem?.rightBarButtonItem =
        UIBarButtonItem(image: UIImage.init(systemName: "location.fill"), style: .plain, target: self, action: #selector(startLocate))
    }
    
    @objc
    func startLocate() {
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    @objc
    func navigation(start: CLLocationCoordinate2D) {
        // Define two waypoints to travel between
        let origin = Waypoint(coordinate: start, name: "Current Location")
        let destination = Waypoint(coordinate: location!, name: name)

        // Set options
        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination])

        activityView?.startAnimating()
        // Request a route using MapboxDirections.swift
        Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
            // self?.activityView?.stopAnimating()
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let route = response.routes?.first, let strongSelf = self else {
                    return
                }
                // Pass the generated route to the the NavigationViewController
                let viewController = NavigationViewController(for: route, routeOptions: routeOptions)
                viewController.modalPresentationStyle = .fullScreen
                strongSelf.present(viewController, animated: true, completion: nil)
            }
        }
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

extension MapPointViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        print("xxx")
    }
}

extension MapPointViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            manager.stopUpdatingLocation()
            manager.delegate = nil
            navigation(start: loc.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
}
