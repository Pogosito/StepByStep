//
//  Joint+CoreDataProperties.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 14.01.2022.
//
//

import Foundation
import CoreData

extension Joint {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Joint> {
		return NSFetchRequest<Joint>(entityName: "Joint")
	}

	@NSManaged public var jointName: String
	@NSManaged public var x: Float
	@NSManaged public var y: Float
}

extension Joint : Identifiable {}
