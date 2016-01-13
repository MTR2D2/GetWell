//
//  MapViewController.swift
//  FinalGetWell2
//
//  Created by Keron Williams on 12/23/15.
//  Copyright © 2015 Keron. All rights reserved.
//


import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate
{
    
    var parent: MediaPlayerViewController?
    var delegate: GoogleAPIController?

    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBAction func searchBar(sender: AnyObject)
    {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 28.538336, longitude: -81.379234)
        let span = MKCoordinateSpanMake(100, 80)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if timerCount%2 == 1
        {
            parent?.togglePlayback(true)
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        if timerCount%2 == 1
        {
            parent?.togglePlayback(true)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
    @IBAction func backPressed(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
        if timerCount%2 == 1
        {
            parent?.togglePlayback(true)
        }
        
        //        self.navigationController?.performSegueWithIdentifier("unwindFromLogin", sender: self)
    }

    
    
    
}

