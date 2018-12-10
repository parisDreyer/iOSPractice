//
//  Artwork.swift
//  HonoluluArt
//
//  Created by Luke Dreyer on 12/9/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import MapKit
import Contacts


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
    
    init?(json: [Any]){
        self.title = json[16] as? String ?? "No Title"
        self.locationName = json[12] as! String
        self.discipline = json[15] as! String
        if let latitude = Double(json[18] as! String),
            let longitude = Double(json[19] as! String){
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
    
    var subtitle: String? {
        return locationName
    }
    
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    
}
