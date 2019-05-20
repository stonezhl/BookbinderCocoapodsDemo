//
//  OPFMetadata.swift
//  Bookbinder
//
//  Created by Stone Zhang on 4/21/19.
//  Copyright © 2019 Stone Zhang. All rights reserved.
//

import Kanna

// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-metadata-elem
public struct OPFMetadata {
    // DCMES Required Elements
    public private(set) var identifiers = [DCIdentifier]()
    public private(set) var titles = [String]()
    public private(set) var languages = [String]()
    // DCMES Optional Elements
    public private(set) var contributors = [String]()
    // let coverage
    public private(set) var creators = [String]()
    public private(set) var date: String?
    public private(set) var description: String?
    // let format
    public private(set) var publisher: String?
    // let relation
    public private(set) var rights: String?
    public private(set) var sources = [String]()
    public private(set) var subjects = [String]()
    // let type
    // META Elements
    public private(set) var modifiedDate: String?
    public private(set) var coverImageID: String?
    // LINK Elements

    init?(package: XMLElement) {
        guard let metadata = package.at_xpath("opf:metadata", namespaces: XPath.opf.namespace) else { return nil }
        // DCMES
        let dcmes = metadata.xpath("dc:*", namespaces: XPath.dc.namespace)
        for dc in dcmes {
            guard let text = dc.text else { continue }
            switch dc.tagName {
            case "identifier":
                identifiers.append(DCIdentifier(dc))
            case "title":
                titles.append(text)
            case "language":
                languages.append(text)
            case "contributor":
                contributors.append(text)
            case "coverage":
                break
            case "creator":
                creators.append(text)
            case "date":
                date = text
            case "description":
                description = text
            case "format":
                break
            case "publisher":
                publisher = text
            case "relation":
                break
            case "rights":
                rights = text
            case "source":
                sources.append(text)
            case "subject":
                subjects.append(text)
            case "type":
                break
            default:
                break
            }
        }
        // META
        let metas = metadata.xpath("opf:meta", namespaces: XPath.opf.namespace)
        for meta in metas {
            if meta["property"] == "dcterms:modified" {
                modifiedDate = meta.text
            } else if meta["name"] == "cover" {
                coverImageID = meta["content"]
            }
        }
    }
}

// Dublin Core Metadata Element Set, Version 1.1: Reference Description
// http://dublincore.org/documents/dces/
// http://dublincore.org/2012/06/14/dcelements
// opf:alt-rep [optional] – only allowed on contributor, creator, and publisher.
// opf:alt-rep-lang [conditionally required] – only allowed on contributor, creator, and publisher.
// dir [optional] – only allowed on contributor, coverage, creator, description, publisher, relation, rights and subject.
// opf:file-as [optional] – only allowed on contributor, creator, and publisher.
// id [optional] – allowed on any element.
// opf:role [optional] – only allowed on contributor and creator.
// opf:scheme [optional] – only allowed on identifier and source.
// xml:lang [optional] – only allowed on contributor, coverage, creator, description, publisher, relation, rights and subject.

// MARK: - DCMES Required Elements
// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-opf-dcmes-required

// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-opf-dcidentifier
// dc:identifier
// text
// attributes:
// - id [optional]
// - opf:scheme [optional]
public struct DCIdentifier {
    public let text: String
    public let id: String?

    init(_ dc: XMLElement) {
        text = dc.text ?? ""
        id = dc["id"]
    }
}

// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-opf-dctitle
// dc:title
// text
// attributes:
// - opf:alt-rep [optional]
// - opf:alt-rep-lang [conditionally required]
// - dir [optional]
// - opf:file-as [optional]
// - id [optional]
// - xml:lang [optional]

// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-opf-dclanguage
// dc:language
// text
// attributes:
// - id [optional]

// MARK: - DCMES Optional Elements
// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-opf-dcmes-optional-def

// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-opf-dccontributor
// dc:contributor
// text
// attributes:
// - opf:alt-rep [optional]
// - opf:alt-rep-lang [conditionally required]
// - dir [optional]
// - opf:file-as [optional]
// - id [optional]
// - opf:role [optional]
// - xml:lang [optional]

// dc:coverage
// text
// attributes:
// - dir [optional]
// - id [optional]
// - xml:lang [optional]

// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-opf-dccreator
// dc:creator {
// text
// attributes:
// - opf:alt-rep [optional]
// - opf:alt-rep-lang [conditionally required]
// - dir [optional]
// - opf:file-as [optional]
// - id [optional]
// - opf:role [optional]
// - xml:lang [optional]

// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-opf-dcdate
// dc:date
// text

// dc:description
// text
// attributes:
// - dir [optional]
// - id [optional]
// - xml:lang [optional]

// dc:format

// dc:publisher
// text
// attributes:
// - opf:alt-rep [optional]
// - opf:alt-rep-lang [conditionally required]
// - dir [optional]
// - opf:file-as [optional]
// - id [optional]
// - xml:lang [optional]

// dc:relation
// text
// attributes:
// - dir [optional]
// - id [optional]
// - xml:lang [optional]

// dc:rights
// text
// attributes:
// - dir [optional]
// - id [optional]
// - xml:lang [optional]

// dc:source
// text: String
// attributes:
// - id [optional]
// - opf:scheme [optional]

// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-opf-dcsubject
// dc:subject
// text
// attributes:
// - dir [optional]
// - id [optional]
// - xml:lang [optional]
// - opf:authority [optional]
// - opf:term [conditionally required]

// http://idpf.github.io/epub-registries/types/#sec-types
// dc:type
// text

// MARK: - The META Elements
// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-meta-elem
// text
// attributes:
// - opf:alt-rep [optional]
// - opf:alt-rep-lang [conditionally required]
// - dir [optional]
// - opf:file-as [optional]
// - id [optional]
// - property [required]
// - refines [optional] [SUPERSEDED]
// - scheme [optional]
// - xml:lang [optional]

// MARK: - The LINK Elements
// https://www.w3.org/Submission/2017/SUBM-epub-packages-20170125/#sec-link-elem
// text
// attributes:
// - href [required]
// - id [optional]
// - media-type [conditionally required]
// - properties [optional]
// - rel [required]
