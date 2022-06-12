//
//  BlackProgressView.swift
//  TestAnkita
//
//  Created by ankita khare on 12/06/22.
//

import Foundation
import UIKit

class BlackProgressView: UIRefreshControl{
    fileprivate let animationView = CircularProgressBarView()
    fileprivate var isAnimating = false

    fileprivate let maxPullDistance: CGFloat = 0

    override init() {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateProgress(with offsetY: CGFloat) {
        guard !isAnimating else { return }
        let progress = min(abs(offsetY / maxPullDistance), 1)
        animationView.currentProgress = progress
    }

    override func beginRefreshing() {
        super.beginRefreshing()
        isAnimating = true
        animationView.currentProgress = 1.0
    }

    override func endRefreshing() {
        super.endRefreshing()
        //animationView.stop()
        isAnimating = false
    }
}
private extension BlackProgressView {
func setupView() {
    // hide default indicator view
    tintColor = .clear
    animationView.center = self.center
    addSubview(animationView)

    addTarget(self, action: #selector(beginRefreshing), for: .valueChanged)
}

func setupLayout() {
    animationView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
        animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
        animationView.widthAnchor.constraint(equalToConstant: 20),
        animationView.heightAnchor.constraint(equalToConstant: 30)
    ])
}
}
