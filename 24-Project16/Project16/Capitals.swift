//
//  Capitals.swift
//  Project16
//
//  Created by diayan siat on 23/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit
import MapKit

class Capitals: NSObject, MKAnnotation {

    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var wikiUrl: String
    
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, wikiUrl: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.wikiUrl = wikiUrl
    }
    
    
//    
//    There are our three properties, along with a basic initializer that just copies in the data it's given. Again, we need to use self. here because the parameters being passed in are the same name as our properties. I've added import MapKit to the file because that's where MKAnnotation and CLLocationCoordinate2D are defined.
//
//    With this custom subclass, we can create capital cities by passing in their name, coordinate and information – I'll be using the info property to hold one priceless (read: off-the-cuff, I sucked at geography) informational nugget about each city.
}
