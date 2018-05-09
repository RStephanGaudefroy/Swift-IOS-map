//
//  ViewController.swift
//  eval-gaudefroy
//
//  Created by admin on 26/04/2018.
//  Copyright © 2018 Stephan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {

    // mapView object
    @IBOutlet weak var mapView: MKMapView!
    
    // searchBar Button
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated:true, completion: nil)
    }
    
    /**
     * function searchBarButtonClicked
     */
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        // hide the search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start{ (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print ("error")
            } else {
                // remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                // getting datas
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                // create annotaion 
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                // zooming
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated: true)
             
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        /**
         * Replace map by map openStreetMap
         */
        // Ne fonctionne qu'a moitié -> temps de reponse trop long impossible a tester car internet défaillant par sa lenteur voir son absence vous avez le choix ...
        let template:String = "http://www.openstreetmap.org/?lat=12.345&lon=12.345&zoom=17&layers=M"
        
        let overlay = MKTileOverlay(urlTemplate: template)
        overlay.canReplaceMapContent = true
        
        mapView.add(overlay, level: .aboveLabels)
        //mapView.delegate = self as? MKMapViewDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

