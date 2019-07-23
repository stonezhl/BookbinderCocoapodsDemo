//
//  ViewController.swift
//  BookbinderCocoapodsDemo
//
//  Created by Stone Zhang on 5/19/19.
//  Copyright © 2019 Stone Zhang. All rights reserved.
//

import UIKit
import Bookbinder

class CustomBook: EPUBBook {
    lazy var firstAuthors: [String]? = {
        return opf.package?.metadata?.creators
    }()
    
    lazy var secondAuthors: [String]? = {
        return opf.package?.metadata?.contributors
    }()
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let zipPath = "epub/Alice's_Adventures_in_Wonderland"
        guard let url = Bundle(for: type(of: self)).url(forResource: zipPath, withExtension: "epub") else {
            print("Invalid zip path for test")
            return
        }
        let bookbinder = Bookbinder()
        let ebook = bookbinder.bindBook(at: url, to: CustomBook.self)
        print(ebook?.firstAuthors?.first ?? "None")
    }


}

