//
//  SkeletonPainterWorker.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 04.01.2022.
//

import UIKit
import Vision

/// Протокол воркера, для отрисовки скелета человека на изображении
protocol SkeletonPainterWorkerProtocol: AnyObject {

	/// Нарисует изображение со скелетом по переданным точкам
	/// - Parameters:
	///   - joints: Список суставов с их координатами
	///   - cgImage: Битовая маска изображения
	///   - frame: Расположение и размер изображения
	///   - transform: Аффинное преобразование координат суставов скелета
	///   - lineColor: Цвет линии
	/// - Returns: Изображение с человеческим телом и нарисованным поверх его скелетом
	func paintSkeleton(joints: [JointName: CGPoint],
					   in cgImage: CGImage?,
					   frame: CGRect,
					   applying transform: CGAffineTransform?,
					   lineСolor: CGColor) -> UIImage?
}

/// Воркер для отрисовки скелета на изображении
final class SkeletonPainterWorker {

	private let renderFormat: UIGraphicsImageRendererFormat = {
		let renderFormat = UIGraphicsImageRendererFormat()
		renderFormat.scale = 1.0
		return renderFormat
	}()
}

// MARK: - SkeletonPainterWorkerProtocol

extension SkeletonPainterWorker: SkeletonPainterWorkerProtocol {

	func paintSkeleton(joints: [JointName: CGPoint],
					   in cgImage: CGImage?,
					   frame: CGRect ,
					   applying transform: CGAffineTransform?,
					   lineСolor: CGColor) -> UIImage? {

		let render = UIGraphicsImageRenderer(size: frame.size, format: renderFormat)

		let imageWithSkeleton = render.image { context in

			let cgContext = context.cgContext
			cgContext.saveGState()
			let inverse = cgContext.ctm.inverted()
			cgContext.concatenate(inverse)
			cgContext.setLineWidth(7)
			cgContext.setStrokeColor(lineСolor)
			cgContext.setFillColor(UIColor.white.cgColor)

			if let safeCGImage = cgImage { cgContext.draw(safeCGImage, in: frame) }

			for jointPair in Constants.Joints.jointsPairs {
				let startPoint = jointPair.joint1

				if let safeStartPointOfBodyPart = joints[startPoint] {
					let transformedStartPoint = safeStartPointOfBodyPart.applying(transform ?? .identity)
					cgContext.move(to: transformedStartPoint)
				}

				let endPoint = jointPair.joint2

				if let safeEndPointOfBodyPart = joints[endPoint] {
					let transformedEndPoint = safeEndPointOfBodyPart.applying(transform ?? .identity)
					cgContext.addLine(to: transformedEndPoint)
				}
			}

			cgContext.strokePath()

			for joint in Constants.Joints.all {
				guard let safeJoint = joints[joint] else { continue }
				let transformedSafeJointLocation = safeJoint.applying(transform ?? .identity)
				paintJoint(location: transformedSafeJointLocation, in: cgContext)
			}

			cgContext.drawPath(using: .fillStroke)
			cgContext.restoreGState()
		}

		return imageWithSkeleton
	}
}

private extension SkeletonPainterWorker {

	func paintJoint(location: CGPoint, in context: CGContext) {
		let rectangle = CGRect(x: location.x - 7,
							   y: location.y - 7,
							   width: 14,
							   height: 14)
		context.addEllipse(in: rectangle)
	}

	// Если понадобиться пронумеровать суставы
	func numberTheJoint(number: Int, in context: CGContext, _ jointLocation: CGPoint) {
		let stringNumber = String(number)
		let attributedString = NSAttributedString(string: stringNumber,
												  attributes: [.foregroundColor: UIColor.black.cgColor,
															   .font: UIFont.systemFont(ofSize: 28)]
		)
		let line = CTLineCreateWithAttributedString(attributedString)

		context.textPosition = jointLocation

		CTLineDraw(line, context)
	}
}
