//
//  JointsStorageWorker.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 08.01.2022.
//

import Vision
import UIKit
import CoreData

/// Тип, который способен сохранить или читать точки скелета из хранилища
protocol JointsStorageAble: AnyObject {

	/// Прочитать из хранилища скелеты для упражнения
	/// - Parameter exerciseName: Название упражнения
	/// - Returns: Массив кортежей (изображение со скелетом, суставы с их расположением)
func readSkeletons(for exerciseName: String) -> [(UIImage, [JointName: CGPoint])]

	/// Сохранить скелеты упражнения
	/// - Parameters:
	///   - skeletons: Массив кортежей (изображение со скелетом, суставы с их расположением)
	///   - exerciseName: Название упражнения
	func write(skeletons: [(UIImage, [JointName: CGPoint])], for exerciseName: String)
}

/// Воркер для хранения расположений суставов скелета с их названиями
final class JointsStorageWorker {

	// MARK: - Private properties

	private let coreDataStack: CoreDataStackProtocol
	
	/// Инициализатор
	/// - Parameter coreDataStack: `CoreData` cтек для управлением хранилищем
	init(coreDataStack: CoreDataStackProtocol) {
		self.coreDataStack = coreDataStack
	}
}

// MARK: - JointsStorageAble

extension JointsStorageWorker: JointsStorageAble {

	func readSkeletons(for exerciseName: String) -> [(UIImage, [JointName: CGPoint])] {
		
		var result: [(UIImage, [JointName: CGPoint])] = []

		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Exercise.entityName)
		fetchRequest.predicate = NSPredicate(format: "nameOfExercise == %@", exerciseName)

		do {
			let exercise = try coreDataStack.viewContext.fetch(fetchRequest) as? [Exercise]
			let skeletons = exercise?.first?.skeletons?.array

			guard let safeSkeleton = skeletons else {
				print("🆘 Can not find skeletons for \(exerciseName)")
				return []
			}

			for skeleton in safeSkeleton {

				guard let castedSkeleton = skeleton as? Skeleton else {
					print("🆘 Can not cast to skeleton type for \(exerciseName)")
					continue
				}

				var jointsDict: [JointName: CGPoint] = [:]

				for joint in castedSkeleton.joints {

					guard let safeJoint = joint as? Joint else {
						print("❓Can't find joint \(joint)")
						continue
					}

					let jointName = JointName(rawValue: VNRecognizedPointKey(rawValue: safeJoint.jointName))
					let jointPosition = CGPoint(x: CGFloat(safeJoint.x), y: CGFloat(safeJoint.y))

					jointsDict[jointName] = jointPosition
				}

				result.append((UIImage(data: castedSkeleton.image) ?? UIImage(), jointsDict))
			}
		} catch {
			print("❌ Can't fetch skeletons for \(exerciseName)")
		}

		print("✅ Finding \(exerciseName) was successfully")
		return result
	}

	func write(skeletons: [(UIImage, [JointName: CGPoint])], for exerciseName: String) {
		delete(exerciseName: exerciseName)
		createExerciseObject(skeletons: skeletons,
							 exerciseName: exerciseName,
							 in: coreDataStack.viewContext)
		coreDataStack.save(context: coreDataStack.viewContext)
		print("✅ Saving \(exerciseName) was successfully")
	}
}

// MARK: - Private methods

private extension JointsStorageWorker {

	func createExerciseObject(skeletons: [(UIImage, [JointName: CGPoint])], exerciseName: String, in context: NSManagedObjectContext) {
		
		guard let exercise = NSEntityDescription.insertNewObject(forEntityName: Exercise.entityName,
																 into: context) as? Exercise else {
			print("❓ Can't cast entity \(Exercise.entityName) to Exercise")
			return
		}

		exercise.nameOfExercise = exerciseName

		for skeleton in skeletons {
			let skeletonModel = Skeleton(context: context)
			guard let safePngData = skeleton.0.pngData() else { continue }
			skeletonModel.image = safePngData
			for joints in skeleton.1 {
				let joint = Joint(context: context)
				joint.jointName = joints.key.rawValue.rawValue
				joint.x = Float(joints.value.x)
				joint.y = Float(joints.value.y)
				skeletonModel.addToJoints(joint)
			}
			exercise.addToSkeletons(skeletonModel)
		}
	}

	func delete(exerciseName: String) {

		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Exercise.entityName)
		fetchRequest.predicate = NSPredicate(format: "nameOfExercise == %@", exerciseName)

		do {
			guard let exercises = try coreDataStack.viewContext.fetch(fetchRequest) as? [Exercise] else {
				print("⛔️ Deletion aborted: can't cast NSManagedObject to Exercise")
				return
			}

			for exercise in exercises { coreDataStack.viewContext.delete(exercise) }

			try coreDataStack.viewContext.save()
		} catch {
			print("❌ Deletion did not occur: \(error)" )
		}

		print("✅ Deletion of the \(exerciseName) was successful")
	}
}
