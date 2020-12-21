//
//  SelectAddressViewController.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/20.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import UIKit
import SwiftLocation
import SwiftSpinner

class SelectAddressViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var geoLocations: [GeoLocation]?
    var selectAddressCallback: ((GeoLocation)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Address"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(back))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TripAddressCell")
        tableView.tableFooterView = UIView()
        fetchlocationList()
    }
    
    func fetchlocationList() {
        SwiftSpinner.show("Locating...")
        SwiftLocation.gpsLocationWith{ $0.accuracy = .house }.then {
            print("Location is \(String(describing: $0.location))")
            if let coordinate = $0.location?.coordinate {
                let service = Geocoder.MapBox(coordinates: coordinate, APIKey: MapboxAccessToken)
                // service.resultTypes = [.place, .poi]
                SwiftLocation.geocodeWith(service).then { result in
                    SwiftSpinner.hide()
                    self.geoLocations = result.data
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func back() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension SelectAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.geoLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = self.geoLocations?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripAddressCell", for: indexPath)
        cell.textLabel?.text = location?.info[GeoLocation.Keys.formattedAddress] as? String
        cell.detailTextLabel?.text = "marker.qualifiedName"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = self.geoLocations?[indexPath.row]
        selectAddressCallback?(location!)
        self.back()
    }
}
