//
//  TripAddress.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/5.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation

public class TripAddress: NSObject, NSCoding {
    var name: String?
    var lat: Double
    var lon: Double
    var desc: String?
    
    public func encode(with coder: NSCoder) {
        if let _name = name {
            coder.encode(_name, forKey: "name")
        }
        if let _desc = desc {
            coder.encode(_desc, forKey: "desc")
        }
        coder.encode(lat, forKey: "lat")
        coder.encode(lon, forKey: "lon")
    }
    
    public override init() {
        lat = Double(0)
        lon = Double(0)
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        self.lat = coder.decodeDouble(forKey: "lat")
        self.lon = coder.decodeDouble(forKey: "lon")
        self.desc = coder.decodeObject(forKey: "desc") as? String
        self.name = coder.decodeObject(forKey: "name") as? String
        super.init()
    }
}

extension TripAddress {
    func syncData(from vs: TripAddressState) {
        if let location = vs.location.convert2Location() {
            self.lat = location.latitude
            self.lon = location.longitude
        }
        self.name = vs.name
        self.desc = vs.description
    }
}
