/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit


class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var artworks: [Artwork] = []
    
    override func viewDidLoad() {
    super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location: initialLocation)
        
        // show artwork on map
//        let artwork = Artwork(title: "King David Kalakaua",
//                              locationName: "Waikiki Gateway Park",
//                              discipline: "Sculpture",
//                              coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
//        mapView.addAnnotation(artwork)
        
        mapView.delegate = self //
        
        loadInitialData()
        mapView.addAnnotations(artworks)
        
  }
    
    
    func loadInitialData() {
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
        let dictionary = json as? [String: Any],
        let works = dictionary["data"] as? [[Any]]
            else {return}
        let validWorks = works.flatMap {Artwork(json: $0)}
        artworks.append(contentsOf: validWorks)
    }
    
    let regionRadius: CLLocationDistance = 1000 // NS -> EW span of 1000 meters rectangle
    func centerMapOnLocation(location: CLLocation){
        // location is center point
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        // tells mapView to display the region
        // mapview then autotransitions map current view to that region
        mapView.setRegion(coordinateRegion, animated: true)
    }

}


// this uses a new ios 11 feature to show info bubble on click of a map view
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Artwork else { return nil }
        let identifier = "marker"
        
        
        if #available(iOS 11.0, *) {
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
            return view;
        } else {
            // Fallback on earlier versions
            return nil;
        }
        
    }
    
    // controls what happens when the user taps the callout button
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
