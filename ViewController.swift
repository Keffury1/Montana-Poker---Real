//
//  ViewController.swift
//  Montana Poker
//
//  Created by Bobby Keffury on 1/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var bottom1StackView: UIStackView!
    @IBOutlet weak var bottom2StackView: UIStackView!
    @IBOutlet weak var bottom3StackView: UIStackView!
    @IBOutlet weak var bottom4StackView: UIStackView!
    @IBOutlet weak var bottom5StackView: UIStackView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var top1StackView: UIStackView!
    @IBOutlet weak var top2StackView: UIStackView!
    @IBOutlet weak var top3StackView: UIStackView!
    @IBOutlet weak var top4StackView: UIStackView!
    @IBOutlet weak var top5StackView: UIStackView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var deckImageView: UIImageView!
    @IBOutlet weak var flopImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    private func setupSubviews() {
        containerView.layer.cornerRadius = 10.0
    }
}

