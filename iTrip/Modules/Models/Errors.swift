//
//  Errors.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/5.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Foundation

class FormEditError: Error {
    let description: String
    
    init(_description: String) {
        description = _description
    }
}

enum CoreDataError {
    case unknown(String)
}
