# Bookbinder
A Swift ePub parser framework for iOS.

You can read [How to Parse an ePub File for iOS](https://medium.com/@stonezhl/how-to-parse-an-epub-file-for-ios-df30213b9a73) to learn more.

## Requirements
* Swift 5.0+
* iOS 10.0+
* ARC

## Basic Usage
1. Create bookbinder instance with default configuration
   ```
   // default configuration uses `NSTemporaryDirectory` as root directory to unzip ePub file
   let bookbinder = Bookbinder()
   ```
1. Parse ePub file by one line
   ```
   let ebook = bookbinder.bindBook(at: ePubFileURL)
   ```
1. Ready made interface of ebook
   ```
   // cover image
   let coverImageURLs = ebook.coverImageURLs
   // toc
   let tocURL = ebook.tocURL
   // ncx
   let ncx = ebook.ncx
   // primary spine items
   let pages = ebook.pages
   // others
   let mainAuthor = ebook.opf.metadata.creators.first
   ...
   ```
1. Playground in `BookbinderTests`
   ```
   // study `Bookbinder` from unit test
   let ebook = EPUBBook(identifier: "Alice's_Adventures_in_Wonderland", contentsOf: url)
   expect(ebook).notTo(beNil())
   expect(ebook?.identifier).to(equal("Alice's_Adventures_in_Wonderland"))
   expect(ebook?.baseURL).to(equal(url))
   expect(ebook?.resourceBaseURL).to(equal(url.appendingPathComponent("epub")))
   expect(ebook?.container).notTo(beNil())
   expect(ebook?.opf).notTo(beNil())
   expect(ebook?.uniqueID).to(equal("url:https://standardebooks.org/ebooks/lewis-carroll/alices-adventures-in-wonderland"))
   expect(ebook?.releaseID).to(equal("\(ebook?.uniqueID ?? "")@2017-03-09T17:21:15Z"))
   expect(ebook?.publicationDate).to(equal(ISO8601DateFormatter().date(from: "2015-05-12T00:01:00Z")))
   ...
   ```

## Advanced Usage
1. Create bookbinder instance with custom configuration
   ```
   let configuration = BookbinderConfiguration(rootURL: customRootURL)
   let bookbinder = Bookbinder(configuration: configuration)
   ```
1. Subclass EPUBBook
   ```
   class CustomBook: EPUBBook {
       lazy var firstAuthors: [String] = {
           return opf.metadata.creators
       }()
       
       lazy var secondAuthors: [String] = {
           return opf.metadata.contributors
       }()
       
       ...
   }
   
   let bookbinder = Bookbinder()
   let ebook = bookbinder.bindBook(at: url, to: CustomBook.self)
   ```
1. Custom OPF XPath
   ```
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
       // http://www.idpf.org/epub/20/spec/OPF_2.0.1_draft.htm#Section2.6
       lazy var guideRefs: [GuideRef] = {
           var refs = [GuideRef]()
           let xpath = "/opf:package/opf:guide/opf:reference"
           let references = opf.document.xpath(xpath, namespaces: XPath.opf.namespace)
           for reference in references {
               refs.append(GuideRef(reference))
           }
           return refs
       }()
       
       ...
   }
   ```

## Installation
### [Cathage](https://github.com/Carthage/Carthage)
Please add it to your `Cartfile`:
```
github "stonezhl/Bookbinder" ~> 1.0.0
```
### [CocoaPods](https://cocoapods.org/)
Please add it to your `Podfile`:
```
use_frameworks!
pod 'Bookbinder', '~> 1.0.0'
```

## License
Bookbinder is released under the MIT license. See `LICENSE` for details.
