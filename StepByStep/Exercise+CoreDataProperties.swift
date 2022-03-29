//
//  Exercise+CoreDataProperties.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 14.01.2022.
//
//

import Foundation
import CoreData

extension Exercise {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
		return NSFetchRequest<Exercise>(entityName: entityName)
	}

	@NSManaged public var nameOfExercise: String?
	@NSManaged public var skeletons: NSOrderedSet?
}

// MARK: Generated accessors for skeletons
extension Exercise {

	@objc(insertObject:inSkeletonsAtIndex:)
	@NSManaged public func insertIntoSkeletons(_ value: Skeleton, at idx: Int)

	@objc(removeObjectFromSkeletonsAtIndex:)
	@NSManaged public func removeFromSkeletons(at idx: Int)

	@objc(insertSkeletons:atIndexes:)
	@NSManaged public func insertIntoSkeletons(_ values: [Skeleton], at indexes: NSIndexSet)

	@objc(removeSkeletonsAtIndexes:)
	@NSManaged public func removeFromSkeletons(at indexes: NSIndexSet)

	@objc(replaceObjectInSkeletonsAtIndex:withObject:)
	@NSManaged public func replaceSkeletons(at idx: Int, with value: Skeleton)

	@objc(replaceSkeletonsAtIndexes:withSkeletons:)
	@NSManaged public func replaceSkeletons(at indexes: NSIndexSet, with values: [Skeleton])

	@objc(addSkeletonsObject:)
	@NSManaged public func addToSkeletons(_ value: Skeleton)

	@objc(removeSkeletonsObject:)
	@NSManaged public func removeFromSkeletons(_ value: Skeleton)

	@objc(addSkeletons:)
	@NSManaged public func addToSkeletons(_ values: NSOrderedSet)

	@objc(removeSkeletons:)
	@NSManaged public func removeFromSkeletons(_ values: NSOrderedSet)
}

extension Exercise : Identifiable {}
