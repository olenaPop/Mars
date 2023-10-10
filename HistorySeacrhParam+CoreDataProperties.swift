//
//  HistorySeacrhParam+CoreDataProperties.swift
//  MARS
//
//  Created by Olena Makhobei on 05/10/2023.
//
//

import Foundation
import CoreData


extension HistorySeacrhParam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistorySeacrhParam> {
        return NSFetchRequest<HistorySeacrhParam>(entityName: "HistorySeacrhParam")
    }

    @NSManaged public var camera: String?
    @NSManaged public var date: Date?
    @NSManaged public var rover: String?

}

extension HistorySeacrhParam : Identifiable {

}
