//
//  Artwork.swift
//  HonoluluArt
//
//  Created by Luke Dreyer on 12/9/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import MapKit


// an object blueprint for a new map location that talks about art in Honolulu
// NSObject makes Artwork MKAnnotation compliant
// the MKAnnotation protocol also requires the coordinate property
// title is an optional property that gets displayed -- subtitle is another
class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
