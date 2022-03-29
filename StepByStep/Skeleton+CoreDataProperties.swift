//
//  Skeleton+CoreDataProperties.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 14.01.2022.
//
//

import Foundation
import CoreData

extension Skeleton {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Skeleton> {
		return NSFetchRequest<Skeleton>(entityName: "Skeleton")
	}

	@NSManaged public var image: Data
	@NSManaged public var joints: NSSet
}

// MARK: Generated accessors for joints
extension Skeleton {

	@objc(addJointsObject:)
	@NSManaged public func addToJoints(_ value: Joint)

	@objc(removeJointsObject:)
	@NSManaged public func removeFromJoints(_ value: Joint)

	@objc(addJoints:)
	@NSManaged public func addToJoints(_ values: NSSet)

	@objc(removeJoints:)
	@NSManaged public func removeFromJoints(_ values: NSSet)
}

extension Skeleton : Identifiable {}
