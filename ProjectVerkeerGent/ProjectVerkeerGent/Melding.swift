//
//  Melding.swift
//  ProjectVerkeerGent
//
//  Created by sander brugge on 3/01/17.
//  Copyright © 2017 sander brugge. All rights reserved.
//
import CoreLocation
import Foundation
class Melding{
    let type: String
    let transport: String
    let message: String
    let location: CLLocationCoordinate2D
    
    init(type: String, transport: String, message: String, location: CLLocationCoordinate2D){
        self.type = type
        self.transport = transport
        self.message = message
        self.location = location
    }
    
}
