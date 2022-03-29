//
//  VSImageView.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 09.01.2022.
//

import UIKit

/// Саблкласс `UIImageView`
///
/// - Note: Данный сабкласс нужен только для того, чтобы при остановке анимации с помощью метода `stopAnimating()`
/// отображалась последная показанная картинка
final class VSImageView: UIImageView {

	var lastShownAnimatedImage: UIImage?
	var values: [String] = []

	// MARK: - Private properties

	private var indexOfLastShownAnimatedImage = 0

	private lazy var timeToChangeFrame = animationDuration / TimeInterval(animationImages?.count ?? 1)
	private var timer: Timer?

	override func startAnimating() {
		super.startAnimating()
		indexOfLastShownAnimatedImage = 0
		timer = Timer.scheduledTimer(timeInterval: timeToChangeFrame,
									target: self,
									selector: #selector(changeLastShownAnimatedImage),
									userInfo: nil,
									repeats: true)
	}

	override func stopAnimating() {
		super.stopAnimating()
		indexOfLastShownAnimatedImage = 0
		timer?.invalidate()
		timer = nil
		image = lastShownAnimatedImage
	}
}

// MARK: - Private methods

private extension VSImageView {

	@objc func changeLastShownAnimatedImage() {
		guard let safeAnimationImages = animationImages else {
			fatalError("Property 'animationImages' is nil you cant start animate your image")
		}

		if indexOfLastShownAnimatedImage >= safeAnimationImages.count - 1 {
			indexOfLastShownAnimatedImage = 0
		} else {
			indexOfLastShownAnimatedImage += 1
		}

		lastShownAnimatedImage = safeAnimationImages[indexOfLastShownAnimatedImage]
	}
}
