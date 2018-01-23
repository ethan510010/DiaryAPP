//
//  Diary+CoreDataProperties.swift
//  DiaryApp
//
//  Created by EthanLin on 2018/1/23.
//  Copyright © 2018年 EthanLin. All rights reserved.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var diaryImage: NSData?
    @NSManaged public var diaryContent: String?
    @NSManaged public var diaryLocation: String?

}
