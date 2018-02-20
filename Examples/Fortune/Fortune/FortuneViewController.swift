//
//  FortuneViewController.swift
//  Fortune
//
//  Created by Edward Smith on 10/3/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit
import Branch

class FortuneViewController: UIViewController {

    // MARK: - Member Variables
    
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    var enableShakes: Bool = false
    var conjuringStartDate: Date?

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(branchWillStartSession(notification:)),
            name: NSNotification.Name.BranchWillStartSession,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(branchDidStartSession(notification:)),
            name: NSNotification.Name.BranchDidStartSession,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appStatsDidUpdate(notification:)),
            name: NSNotification.Name.AppDataDidUpdate,
            object: nil
        )
        updateStatsLabel()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        messageLabel.layer.removeAllAnimations()
        messageLabel.text =
            "Shake the phone to reveal your mystic Branch fortune..."
        updateStatsLabel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.enableShakes = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.enableShakes = false
    }

    override func becomeFirstResponder() -> Bool {
        // Over-ride so the view controller can get shake events:
        return enableShakes ? true : false
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake && enableShakes {
            self.createLink()
        }
    }

    // MARK: - Notifications

    @objc func appStatsDidUpdate(notification: Notification) {
        updateStatsLabel()
    }

    @objc func branchWillStartSession(notification: Notification) {
        // Only show the waiting view if we've been opened by an URL tap:
//        guard let url = notification.userInfo?[BranchURLKey] as? URL else { return }
//        WaitingViewController.showWithMessage(
//            message: "Opening\n\(url.absoluteString)",
//            activityIndicator: true,
//            disableTouches: true
//        )
    }

    @objc func branchDidStartSession(notification: Notification) {
//      WaitingViewController.hide()

        if let error = notification.userInfo?[BranchErrorKey] as? Error {
            if let url = notification.userInfo?[BranchURLKey] as? URL {
                self.showAlert(
                    title: "Couldn't Open URL",
                    message: "\(url.absoluteString)\n\n\(error.localizedDescription)"
                )
            } else {
                self.showAlert(
                    title: "Error Starting Branch Session",
                    message: error.localizedDescription
                )
            }
            return
        }

        if let buo = notification.userInfo?[BranchUniversalObjectKey] as? BranchUniversalObject {
            let messageViewController = FortuneReceivedViewController.instantiate()
            messageViewController.name = buo.contentMetadata.customMetadata["name"] as? String
            messageViewController.message = buo.contentMetadata.customMetadata["message"] as? String
            self.present(messageViewController, animated: true, completion: nil)
            AppData.shared.linksOpened += 1
            return
        }
    }

    // Mark: - Make the Branch Link

    func createLink() {
        let message = AppData.shared.randomFortune()

        // Add some content to the Branch object:
        let buo = BranchUniversalObject.init()
        buo.title = "Segment-Branch Example"
        buo.contentDescription = "A mysterious fortune."
        buo.contentMetadata.customMetadata["message"] = message
        buo.contentMetadata.customMetadata["name"] = UIDevice.current.name

        // Set some link properties:
        let linkProperties = BranchLinkProperties.init()
        linkProperties.channel = "Fortune"

        // Start the animation while we get the link:
        self.startMysticConjuring()
        buo.getShortUrl(with: linkProperties) { (urlString: String?, error: Error?) in
            if let s = urlString, let url = URL.init(string: s) {
                AppData.shared.linksCreated += 1
                let date: Date = self.conjuringStartDate! + 1.75
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + date.timeIntervalSinceNow) {
                    // DispatchTime.init(date: date)) {
                    self.stopMysticConjuring()
                    self.revealMysticConjuring(message: message, url: url)
                }
                return
            }
            self.stopMysticConjuring()
            print("Network error: \(String(describing: error))")
            self.messageLabel.text = "Can't conjur spirits now!\nShake to try again."
            self.enableShakes = true
        }
    }

    // MARK: - Update the UI

    func updateStatsLabel() {
        statsLabel.text =
            "\(AppData.shared.appOpens)\n\(AppData.shared.linksOpened)\n\(AppData.shared.linksCreated)"
    }

    func startMysticConjuring() {
        self.enableShakes = false
        self.messageLabel.text = "Summoning mystic fortune spirits..."
        self.conjuringStartDate = Date.init()

        // Start the animation:
        let kAnimationDuration: TimeInterval = 1.0
        let kAnimationRepeat:   Float = 10000;

        CATransaction.begin()
        //CATransaction.setCompletionBlock { self.revealMysticConjuring() }

        var animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.25
        animation.repeatCount = kAnimationRepeat
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards;
        animation.autoreverses = true
        animation.duration = kAnimationDuration
        self.messageLabel.layer.add(animation, forKey: "opacity")

        animation = CABasicAnimation(keyPath: "transform.scale.x")
        animation.fromValue = 1.0
        animation.toValue = 1.35
        animation.repeatCount = kAnimationRepeat
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards;
        animation.autoreverses = true
        animation.duration = kAnimationDuration
        self.messageLabel.layer.add(animation, forKey: "transform.scale.x")

        CATransaction.commit()
    }

    func stopMysticConjuring() {
        self.messageLabel.layer.removeAllAnimations()
    }

    func revealMysticConjuring(message: String, url:URL) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let fortuneViewController = FortuneSendViewController.instantiate()
            fortuneViewController.message = message
            fortuneViewController.branchURL = url
            fortuneViewController.originFrame = self.view.convert(self.messageLabel.frame, to: nil)
            self.present(fortuneViewController, animated: true, completion: nil)
        }
        CATransaction.setAnimationDuration(0.30)

        var animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.00
        animation.duration = 1.00
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards;
        self.messageLabel.layer.add(animation, forKey: "opacity")

        animation = CABasicAnimation(keyPath: "transform.scale.x")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 1.00
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards;
        self.messageLabel.layer.add(animation, forKey: "transform.scale.x")

        CATransaction.commit()
    }

}
