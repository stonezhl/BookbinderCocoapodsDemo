//
//  ViewController.swift
//  BookbinderCocoapodsDemo
//
//  Created by Stone Zhang on 5/19/19.
//  Copyright © 2019 Stone Zhang. All rights reserved.
//

import UIKit
import Bookbinder
import Kanna

struct GuideRef {
    let title: String
    let href: String
    let type: String
    
    init(_ reference: XMLElement) {
        title = reference["title"] ?? ""
        href = reference["href"] ?? ""
        type = reference["type"] ?? ""
    }
}

class CustomBook: EPUBBook {
    lazy var firstAuthors: [String]? = {
        return opf.package?.metadata?.creators
    }()
    
    lazy var secondAuthors: [String]? = {
        return opf.package?.metadata?.contributors
    }()
    
    // http://www.idpf.org/epub/20/spec/OPF_2.0.1_draft.htm#Section2.6
    lazy var guideRefs: [GuideRef] = {
        var refs = [GuideRef]()
        let references = opf.document.xpath("/opf:package/opf:guide/opf:reference", namespaces: XPath.opf.namespace)
        for reference in references {
            refs.append(GuideRef(reference))
        }
        return refs
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
        print(ebook?.guideRefs.first?.title ?? "None")
    }


}

