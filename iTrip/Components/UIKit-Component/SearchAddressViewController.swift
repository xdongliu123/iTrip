//
//  SearchAddressViewController.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/1.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import UIKit
import MapboxGeocoder

class SearchAddressViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var dragIndicator: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tipLabel: UILabel!
    var markers: [GeocodedPlacemark] = []
    var selectPointHandler: ((GeocodedPlacemark)->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        tipLabel.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        tipLabel.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        tipLabel.isHidden = false
        markers = []
        tableView.reloadData()
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), keyword.count > 0 {
            let options = ForwardGeocodeOptions(query: keyword)
            // options.allowedISOCountryCodes = ["CN"]
            options.allowedScopes = [.address, .pointOfInterest]
            Geocoder.shared.geocode(options) { (placemarks, attribution, error) in
                self.markers = placemarks ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if keyword.count > 0 {
            let options = ForwardGeocodeOptions(query: keyword)
            // options.allowedISOCountryCodes = ["CN"]
            options.allowedScopes = [.address, .pointOfInterest]
            Geocoder.shared.geocode(options) { (placemarks, attribution, error) in
                self.markers = placemarks ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let marker = markers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "markerCell", for: indexPath)
        cell.textLabel?.text = marker.name
        cell.detailTextLabel?.text = marker.qualifiedName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let marker = markers[indexPath.row]
        if selectPointHandler != nil {
            selectPointHandler!(marker)
        }
    }
}
