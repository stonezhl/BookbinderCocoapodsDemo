//
//  ViewController.swift
//  BookbinderCocoapodsDemo
//
//  Created by Stone Zhang on 5/19/19.
//  Copyright © 2019 Stone Zhang. All rights reserved.
//

import UIKit
import Bookbinder

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bookbinder = Bookbinder()
        print(bookbinder.configuration.rootURL)
    }


}

