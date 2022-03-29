//
//  CoreDataStack.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 12.01.2022.
//

import CoreData

/// Протокол для типа, что реализует CoreData стек
protocol CoreDataStackProtocol {

	/// Контекст связанный с главным потоком
	var viewContext: NSManagedObjectContext { get }

	/// Создать контекст для фонового потока
	var backgroundContext: NSManagedObjectContext { get }

	/// Сохранить состояние переданного контекста
	///
	/// - Note: Если в контексте не было изменений, то сохранение не произойдет
	/// - Parameter context: Контекст, состояние которого нужно сохранить
	func save(context: NSManagedObjectContext)
}

/// CoreData стек
final class CoreDataStack {

	// MARK: - CoreDataStackProtocol properties

	lazy var viewContext: NSManagedObjectContext = { persistentContainer.viewContext }()

	var backgroundContext: NSManagedObjectContext { persistentContainer.newBackgroundContext() }

	// MARK: - Private properties

	private let modelName: String

	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: modelName)
		container.loadPersistentStores { [weak self] persistentStoreDescription, error in
			if let error = error { fatalError("Can't load persistent store \(error)") }
			if let safeUrl = persistentStoreDescription.url { print("✅ Persistent container successfully created: \(safeUrl)") }
		}
		return container
	}()

	/// Инициализатор
	/// - Parameter modelName: Название модели
	init(modelName: String) {
		self.modelName = modelName
	}
}

// MARK: - CoreDataStackProtocol

extension CoreDataStack: CoreDataStackProtocol {

	func save(context: NSManagedObjectContext) {
		guard context.hasChanges else {
			print("View Context has no changes ")
			return
		}

		do {
			try context.save()
		} catch {
			print(error)
		}
	}
}
