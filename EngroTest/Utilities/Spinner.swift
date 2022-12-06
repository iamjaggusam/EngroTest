//
//  Spinner.swift
//  EngroTest
//
//  Created by JaGgu Sam on 06/12/22.
//

import Foundation
import UIKit

public class Spinner {

    internal static var spinner: UIActivityIndicatorView?
    public static var style: UIActivityIndicatorView.Style = .large
    public static var baseBackColor = UIColor.black.withAlphaComponent(0.3)
    public static var baseColor = UIColor.black

    public static func start(style: UIActivityIndicatorView.Style = style, backColor: UIColor = baseBackColor, baseColor: UIColor = baseColor) {
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
        if #available(iOS 13.0, *) {
            if spinner == nil, let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first {
                let frame = UIScreen.main.bounds
                spinner = UIActivityIndicatorView(frame: frame)
                spinner!.backgroundColor = backColor
                spinner!.style = style
                spinner?.color = baseColor
                window.addSubview(spinner!)
                spinner!.startAnimating()
            }
        } else {
            // Fallback on earlier versions
            if spinner == nil, let window = UIApplication.shared.keyWindow {
                let frame = UIScreen.main.bounds
                spinner = UIActivityIndicatorView(frame: frame)
                spinner!.backgroundColor = backColor
                spinner!.style = style
                spinner?.color = baseColor
                window.addSubview(spinner!)
                spinner!.startAnimating()
            }
        }
    }

    public static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }

    @objc public static func update() {
        if spinner != nil {
            stop()
            start()
        }
    }
}


