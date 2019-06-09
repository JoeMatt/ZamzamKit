//
//  PluggableController.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-04.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

/// Conforming to a controller module and added to `UIViewController.modules()` will trigger events.
public protocol ControllerModule {
    func viewDidLoad(_ controller: UIViewController)
    
    func viewWillAppear(_ controller: UIViewController)
    func viewDidAppear(_ controller: UIViewController)
    
    func viewWillDisappear(_ controller: UIViewController)
    func viewDidDisappear(_ controller: UIViewController)
    
    func viewWillLayoutSubviews(_ controller: UIViewController)
    func viewDidLayoutSubviews(_ controller: UIViewController)
}

public extension ControllerModule {
    func viewDidLoad(_ controller: UIViewController) {}
    
    func viewWillAppear(_ controller: UIViewController) {}
    func viewDidAppear(_ controller: UIViewController) {}
    
    func viewWillDisappear(_ controller: UIViewController) {}
    func viewDidDisappear(_ controller: UIViewController) {}
    
    func viewWillLayoutSubviews(_ controller: UIViewController) {}
    func viewDidLayoutSubviews(_ controller: UIViewController) {}
}
