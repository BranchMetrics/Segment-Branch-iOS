//
//  APFadeViewControllerTransition.swift
//  Fortune
//
//  Created by Edward on 2/14/18.
//  Copyright © 2018 Branch. All rights reserved.
//

import UIKit

class APFadeViewControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private let originFrame: CGRect
    let animationTime: TimeInterval = 4.0

    init(originFrame: CGRect) {
      self.originFrame = originFrame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return self.animationTime
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to)
//            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
            else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        toVC.view.frame = containerView.convert(self.originFrame, from: nil)
        //toVC.view.alpha = 0.50
        toVC.view.clipsToBounds = true
        toVC.view.contentMode = .scaleToFill

//        toVC.view.layer.borderColor = UIColor.red.cgColor
//        toVC.view.layer.borderWidth = 4.0

        let duration = transitionDuration(using: transitionContext)
        let finalFrame = transitionContext.finalFrame(for: toVC)

        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                toVC.view.frame = finalFrame
                toVC.view.alpha = 1.0
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
