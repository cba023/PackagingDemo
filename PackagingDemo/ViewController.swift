//
//  ViewController.swift
//  PackagingDemo
//
//  Created by juzix on 2020/8/7.
//  Copyright © 2020 juzix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if PACKAGINGDEMO_DEV
        self.view.backgroundColor = .red
        #else
        self.view.backgroundColor = .green
        #endif
    }
}

