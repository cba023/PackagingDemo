//
//  ViewController.swift
//  PackagingDemo
//
//  Created by juzix on 2020/8/7.
//  Copyright © 2020 juzix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if PACKAGINGDEMO_DEV
        self.view.backgroundColor = .red
        self.titleLabel.text = "DEV"
        #else
        self.view.backgroundColor = .green
        self.titleLabel.text = "PROD"
        #endif
    }
}

