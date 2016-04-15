//
//  MapViewController.swift
//  CapstoneReminder
//
//  Created by Spencer Curtis on 4/14/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {
    
    static let sharedController = MapViewController()
    
    var resultSearchController: UISearchController? = nil
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationSearchTableViewController = storyboard?.instantiateViewControllerWithIdentifier("LocationTableViewController") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTableViewController)
        resultSearchController?.searchResultsUpdater = locationSearchTableViewController
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    
//    var searchLocation: CLLocation?
//    
//    let initialLocation = LocationController.sharedController.currentLocation
//    
//    var searchText: String? = ""
//    
//    var searchController:UISearchController!
//    var annotation:MKAnnotation!
//    var localSearchRequest:MKLocalSearchRequest!
//    var localSearch:MKLocalSearch!
//    var localSearchResponse:MKLocalSearchResponse!
//    var error:NSError!
//    var pointAnnotation:MKPointAnnotation!
//    var pinAnnotationView:MKPinAnnotationView!
//    let button = UIButton(type: .DetailDisclosure)
//    
//    
//    let regionRadius: CLLocationDistance = 1000
//    func centerMapOnLocation(location: CLLocation) {
//        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
//        mapView.setRegion(region, animated: true)
//        
//    }

//        if let location = initialLocation {
//            centerMapOnLocation(location)
//        }
//        
        // Do any additional setup after loading the view.
    
//    @IBAction func searchButtonTapped(sender: AnyObject) {
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.hidesNavigationBarDuringPresentation = false
//        self.searchController.searchBar.delegate = self
//        presentViewController(searchController, animated: true, completion: nil)
//        searchText = searchController.searchBar.text
//        
//    }
    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar){
//        //1
//        searchBar.resignFirstResponder()
//        dismissViewControllerAnimated(true, completion: nil)
//        if self.mapView.annotations.count != 0 {
//            annotation = self.mapView.annotations[0]
//            self.mapView.removeAnnotation(annotation)
//            searchController.searchBar.text = searchText
//        }
//        //2
//        localSearchRequest = MKLocalSearchRequest()
//        localSearchRequest.naturalLanguageQuery = searchBar.text
//        localSearch = MKLocalSearch(request: localSearchRequest)
//        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
//            
//            if localSearchResponse == nil{
//                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
//                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alertController, animated: true, completion: nil)
//                self.searchController.searchBar.text = self.searchText
//
//                return
//            }
//            //3
//            self.pointAnnotation = MKPointAnnotation()
//            self.pointAnnotation.title = searchBar.text
//            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
//            
//            
//            
//            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
//            self.pinAnnotationView.animatesDrop = true
////            self.pinAnnotationView.rightCalloutAccessoryView = self.button
//            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
//            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
//            self.centerMapOnLocation(CLLocation(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude))
//            self.searchController.searchBar.text = self.searchText
//            if let localSearchResponse = localSearchResponse {
//                self.searchLocation = CLLocation(latitude: localSearchResponse.boundingRegion.center.latitude, longitude: localSearchResponse.boundingRegion.center.longitude)
//                self.searchController.searchBar.text = self.searchText
//
//            }
//        }
//    }
//    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
