//
//  SecondViewController.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 3/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import UIKit
import CoreLocation
import ZamzamCore
import ZamzamKit

class LocationViewController: UIViewController {

    @IBOutlet private weak var outputLabel: UILabel!
    
    var locationsWorker: LocationWorkerType = LocationWorker(
        desiredAccuracy: kCLLocationAccuracyThreeKilometers,
        distanceFilter: 1000
    )
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationsWorker.addObserver(locationObserver)
        locationsWorker.addObserver(headingObserver)
        
        locationsWorker.requestAuthorization(
            for: .whenInUse,
            startUpdatingLocation: true) {
                guard $0 else {
                    self.present(
                        alert: .localized(.allowLocationAlert),
                        message: .localized(.allowLocationMessage),
                        buttonText: .localized(.allow),
                        includeCancelAction: true,
                        handler: {
                            guard let settings = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(settings)
                        }
                    )
                    return
                }
                
                self.locationsWorker.startUpdatingHeading()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationsWorker.removeObservers()
    }
    
    deinit {
        locationsWorker.removeObservers()
    }
}

extension LocationViewController {
    
    var locationObserver: Observer<LocationWorker.LocationHandler> {
        return Observer { [weak self] in
            self?.outputLabel.text = $0.description
        }
    }
    
    var headingObserver: Observer<LocationWorker.HeadingHandler> {
        return Observer {
            print($0.description)
        }
    }
}
