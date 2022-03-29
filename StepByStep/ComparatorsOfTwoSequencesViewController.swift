//
//  ComparatorsOfTwoSequencesViewController.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 28.11.2021.
//

import UIKit
import Vision
import CoreData

/// Контроллер для сравнения скелета на двух видеорядах
final class ComparatorsOfTwoSequencesViewController: UIViewController {

	// MARK: - Private properties

	private let skeletonEstimationWorker: SkeletonJointsEstimationWorkerProtocol
	private let skeletonPainterWorker: SkeletonPainterWorkerProtocol
	private let skeletonAngleCalculationWorker: SkeletonAngleCalculationWorkerProtocol
	private let jointsStorage: JointsStorageAble
	private let videoProcessWorker: VideoProcessWorker
	private let rightRepetitionVideoPath: URL
	private let wrongRepetitionVideoPath: URL
	private let rightJointView = JointsView(header: "Right Coord")
	private let wrongJointView = JointsView(header: "NotFullySquat Coord")
	private let separatorView = UIView()
	private let rightAnglesView = AnglesView(header: "Right Angles")
	private let wrongAnglesView = AnglesView(header: "NotFullySquat Angles")

	private lazy var rightExecutionData = jointsStorage.readSkeletons(for: Squat.rightSquat.rawValue)
	private lazy var wrongExecutionData = jointsStorage.readSkeletons(for: Squat.notFullySquat.rawValue)

	private lazy var canvasForRightRepetition = createCanvas(backgroundColor: .clear,
															 isOpaque: true,
															 duration: 2,
															 images: rightExecutionData.map { $0.0 })

	private lazy var canvasForWrongRepetition = createCanvas(backgroundColor: .systemBlue,
															 isOpaque: false,
															 duration: 2,
															 images: wrongExecutionData.map { $0.0 })

	private let outputSettings = [
		String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)
	]

	private lazy var stopStartAnimationButton: UIButton = {
		let button = UIButton()
		button.setTitle("Stop/Restart", for: .normal)
		button.backgroundColor = .orange
		button.addTarget(self, action: #selector(processStopStartAnimationButtonTap), for: .touchUpInside)
		return button
	}()

	private lazy var newDataForRightRepButton: UIButton = {
		let button = UIButton()
		button.setTitle("New RS", for: .normal)
		button.backgroundColor = .red
		button.addTarget(self, action: #selector(getNewDataForRightRep), for: .touchUpInside)
		return button
	}()

	private lazy var newDataForWrongRepButton: UIButton = {
		let button = UIButton()
		button.setTitle("New NotFullySquat", for: .normal)
		button.backgroundColor = .darkGray
		button.addTarget(self, action: #selector(getNewDataForWrongRep), for: .touchUpInside)
		return button
	}()

	private lazy var changeVisibilityOfRightRepetitionButton: UIButton = {
		let button = UIButton()
		button.setTitle("Hide/Show right repetition", for: .normal)
		button.backgroundColor = .blue
		button.addTarget(self, action: #selector(changeVisibilityOfRightRepetition), for: .touchUpInside)
		return button
	}()

	private lazy var buttonsStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [stopStartAnimationButton,
												   newDataForRightRepButton,
												   newDataForWrongRepButton,
												   changeVisibilityOfRightRepetitionButton])
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		return stack
	}()

	private lazy var subviews: [UIView] = [canvasForWrongRepetition,
										   canvasForRightRepetition,
										   rightJointView,
										   wrongJointView,
										   separatorView,
										   rightAnglesView,
										   wrongAnglesView,
										   buttonsStack
	]

	/// Инициализатор
	/// - Parameters:
	///   - skeletonEstimationWorker: Воркер для определения расположения скелета на изображении
	///   - skeletonPainterWorker: Воркер для отрисовки скелета по точками на изображении
	///   - skeletonAngleCalculationWorker: Воркер для определения углов скелета
	///   - jointsStorage: Хранилище для изображений и точек
	///   - videoProcessWorker: Воркер для обрабтки видео
	///   - rightRepetitionVideoPath: Путь до видео с правильным выполнением упражнения
	///   - wrongRepetitionVideoPath: Путь до видео с неправильным выполнением упражнения
	init(skeletonEstimationWorker: SkeletonJointsEstimationWorkerProtocol,
		 skeletonPainterWorker: SkeletonPainterWorkerProtocol,
		 skeletonAngleCalculationWorker: SkeletonAngleCalculationWorker,
		 jointsStorage: JointsStorageAble,
		 videoProcessWorker: VideoProcessWorker,
		 rightRepetitionVideoPath: URL,
		 wrongRepetitionVideoPath: URL) {
		self.skeletonEstimationWorker = skeletonEstimationWorker
		self.skeletonPainterWorker = skeletonPainterWorker
		self.skeletonAngleCalculationWorker = skeletonAngleCalculationWorker
		self.jointsStorage = jointsStorage
		self.videoProcessWorker = videoProcessWorker
		self.rightRepetitionVideoPath = rightRepetitionVideoPath
		self.wrongRepetitionVideoPath = wrongRepetitionVideoPath
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
}

// MARK: - Actions

private extension ComparatorsOfTwoSequencesViewController {

	@objc func processStopStartAnimationButtonTap() {
		let isAnimationsStarted = canvasForWrongRepetition.isAnimating && canvasForRightRepetition.isAnimating
		isAnimationsStarted ? stopAllAnimation() : startAllAnimation()
	}

	@objc func changeVisibilityOfRightRepetition() {
		canvasForRightRepetition.isHidden = !canvasForRightRepetition.isHidden
	}

	@objc func getNewDataForRightRep() {
		rightExecutionData = getSkeletonAndJointPositionForEveryFrame(url: rightRepetitionVideoPath,
																	  isTranslucent: true,
																	  lineColor: .blue)

		jointsStorage.write(skeletons: rightExecutionData, for: Squat.rightSquat.rawValue)
		canvasForRightRepetition.animationImages = rightExecutionData.map { $0.0 }
	}

	@objc func getNewDataForWrongRep() {
		wrongExecutionData = getSkeletonAndJointPositionForEveryFrame(url: wrongRepetitionVideoPath,
																	  isTranslucent: false,
																	  lineColor: .red)

		jointsStorage.write(skeletons: wrongExecutionData, for: Squat.notFullySquat.rawValue)
		canvasForWrongRepetition.animationImages = wrongExecutionData.map { $0.0 }
	}
}

// MARK: - Private method's

private extension ComparatorsOfTwoSequencesViewController {

	func getSkeletonAndJointPositionForEveryFrame(url: URL,
												  isTranslucent: Bool,
												  lineColor: UIColor) -> [(UIImage, [JointName: CGPoint])] {
		var result: [(UIImage, [JointName: CGPoint])] = []

		videoProcessWorker.processEveryFrameOfVideo(url: url) { imageBuffer in
			let ciImage = CIImage(cvImageBuffer: imageBuffer)
			let uiImage = UIImage(ciImage: ciImage)
			let uiImageView = UIImageView(image: uiImage)
			let model = SkeletonModel(skeletonEstimationWorker: skeletonEstimationWorker, image: uiImage)

			model.findSkeletonJointsInCIImageAndProcess { joints in

				guard let safeCGImage = ciImage.convertToCGImage() else { return }

				guard let skeletonImage = self.skeletonPainterWorker.paintSkeleton(joints: joints,
																				   in: isTranslucent ? nil : safeCGImage,
																				   frame: uiImageView.frame,
																				   applying: CGAffineTransform(scaleX: uiImageView.frame.width,
																											   y: uiImageView.frame.height),
																				   lineСolor: lineColor.cgColor) else { return }

				result.append((skeletonImage, joints))
			}
		}

		return result
	}

	func stopAllAnimation() {
		canvasForWrongRepetition.stopAnimating()
		canvasForRightRepetition.stopAnimating()
		let lastRightData = rightExecutionData.first { $0.0 == canvasForRightRepetition.lastShownAnimatedImage }
		let lastWrongData = wrongExecutionData.first { $0.0 == canvasForWrongRepetition.lastShownAnimatedImage }

		guard let safeLastRightData = lastRightData?.1,
			  let safeLastWrongData = lastWrongData?.1 else {
			print("Can't retrieve data")
			return
		}

		rightJointView.update(joints: safeLastRightData)
		wrongJointView.update(joints: safeLastWrongData)

		let desiredAngles: [JointAngle] = [.leftKnee,
										   .leftLegAndBody,
										   .rightKnee,
										   .rightLegAndBody,
										   .rightHip,
										   .leftHip,
										   .bodyLeftShoulder,
										   .bodyLeftTorso,
										   .bodyRightShoulder,
										   .bodyRightTorso]

		let rightAngles = skeletonAngleCalculationWorker.calculate(jointAngles: desiredAngles,
																   joints: safeLastRightData,
																   applying: CGAffineTransform(scaleX: canvasForRightRepetition.frame.width,
																							   y: canvasForRightRepetition.frame.height))

		let wrongAngles = skeletonAngleCalculationWorker.calculate(jointAngles: desiredAngles,
																   joints: safeLastWrongData,
																   applying: CGAffineTransform(scaleX: canvasForWrongRepetition.frame.width,
																							   y: canvasForWrongRepetition.frame.height))

		rightAnglesView.update(angles: rightAngles)
		wrongAnglesView.update(angles: wrongAngles)
	}

	func startAllAnimation() {
		canvasForWrongRepetition.startAnimating()
		canvasForRightRepetition.startAnimating()
	}

	func createCanvas(backgroundColor: UIColor,
					  isOpaque: Bool,
					  duration: TimeInterval,
					  images: [UIImage]) -> VSImageView {
		let imageCanvas = VSImageView()
		imageCanvas.isOpaque = isOpaque
		imageCanvas.backgroundColor = backgroundColor
		imageCanvas.contentMode = .scaleAspectFit
		imageCanvas.animationDuration = duration
		imageCanvas.animationImages = images
		return imageCanvas
	}
}

// MARK: - Setup UI

private extension ComparatorsOfTwoSequencesViewController {

	func setupUI() {
		view.backgroundColor = .black
		separatorView.backgroundColor = .separator
		addSubviewsAndSetAutoresizingMaskIntoConstraints()
		activateContraints()
	}

	func makeNavigationBarTransparent() {
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
	}

	func addSubviewsAndSetAutoresizingMaskIntoConstraints() {
		subviews.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
	}

	func activateContraints() {
		NSLayoutConstraint.activate([
			buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			buttonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			buttonsStack.heightAnchor.constraint(equalToConstant: 44),

			canvasForRightRepetition.widthAnchor.constraint(equalToConstant: 460),
			canvasForRightRepetition.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			canvasForRightRepetition.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			canvasForRightRepetition.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor),

			canvasForWrongRepetition.widthAnchor.constraint(equalToConstant: 460),
			canvasForWrongRepetition.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			canvasForWrongRepetition.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			canvasForWrongRepetition.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor),

			rightJointView.leadingAnchor.constraint(equalTo: canvasForRightRepetition.trailingAnchor),
			rightJointView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			rightJointView.heightAnchor.constraint(equalToConstant: view.frame.height / 2 - 40),
			rightJointView.widthAnchor.constraint(equalToConstant: (view.frame.width - 460) / 2),

			wrongJointView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			wrongJointView.heightAnchor.constraint(equalTo: rightJointView.heightAnchor),
			wrongJointView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
			wrongJointView.widthAnchor.constraint(equalTo: rightJointView.widthAnchor),

			separatorView.leadingAnchor.constraint(equalTo: canvasForRightRepetition.trailingAnchor),
			separatorView.topAnchor.constraint(equalTo: rightJointView.bottomAnchor),
			separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			separatorView.heightAnchor.constraint(equalToConstant: 20),

			rightAnglesView.leadingAnchor.constraint(equalTo: canvasForRightRepetition.trailingAnchor),
			rightAnglesView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
			rightAnglesView.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor),
			rightAnglesView.widthAnchor.constraint(equalToConstant: (view.frame.width - 460) / 2),

			wrongAnglesView.leadingAnchor.constraint(equalTo: rightAnglesView.trailingAnchor),
			wrongAnglesView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
			wrongAnglesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			wrongAnglesView.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor)
		])
	}
}
