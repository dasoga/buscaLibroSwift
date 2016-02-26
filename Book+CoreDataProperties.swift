//
//  Book+CoreDataProperties.swift
//  BuscaLibro
//
//  Created by Dante Solorio on 2/26/16.
//  Copyright © 2016 Dante Solorio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Book {

    @NSManaged var authors: String?
    @NSManaged var image: NSData?
    @NSManaged var title: String?
    @NSManaged var isbn: String?

}
