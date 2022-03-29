//
//  Namespaces.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 15.11.2021.
//

import Vision

// MARK: - Typealias

typealias JointName = VNHumanBodyPoseObservation.JointName
typealias JointsGroupName = VNHumanBodyPoseObservation.JointsGroupName

// MARK: - Images

enum Images: String {
	case standardSquat
	case wrong1Squat
}

// MARK: - Videos

enum Videos: String {
	case RightSquat
	case NotFullySquat
}

// MARK: - VideoTypes

enum VideoTypes: String {
	case mp4
}

// MARK: - Exercises

enum Squat: String {
	case rightSquat = "RightSquat"
	case notFullySquat = "NotFullySquat"
}

// MARK: - Constants

enum Constants {

	enum Joints {

		static let all: [JointName] = [
			.rightEar,
			.rightEye,
			.nose,
			.leftEye,
			.leftEar,

			.rightWrist,
			.rightElbow,
			.rightShoulder,
			.neck,

			.leftShoulder,
			.leftElbow,
			.leftWrist,

			.rightHip,
			.root,
			.leftHip,

			.rightKnee,
			.leftKnee,

			.rightAnkle,
			.leftAnkle,
		]

		static let face: [JointName] = [
			.leftEye,
			.rightEye,
			.leftEar,
			.rightEar,
			.nose,
		]

		static let body: [JointName] = [
			.rightShoulder,
			.neck,
			.leftShoulder,
			.leftHip,
			.root,
			.rightHip
		]

		static let leftArm: [JointName] = [
			.leftWrist,
			.leftElbow,
			.leftShoulder
		]

		static let rightArm: [JointName] = [
			.rightWrist,
			.rightElbow,
			.rightShoulder
		]

		static let rightLeg: [JointName] = [
			.rightKnee,
			.rightAnkle,
			.rightHip
		]

		static let leftLeg: [JointName] = [
			.leftKnee,
			.leftAnkle,
			.leftHip
		]

		static let jointsPairs: [(joint1: JointName, joint2: JointName)] = [
			(.leftShoulder, .leftElbow),
			(.leftElbow, .leftWrist),

			(.leftHip, .leftKnee),
			(.leftKnee, .leftAnkle),

			(.rightShoulder, .rightElbow),
			(.rightElbow, .rightWrist),

			(.rightHip, .rightKnee),
			(.rightKnee, .rightAnkle),

			(.leftShoulder, .neck),
			(.rightShoulder, .neck),
			(.leftShoulder, .leftHip),
			(.rightShoulder, .rightHip),
			(.leftHip, .rightHip)
		]
	}
}
