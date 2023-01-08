//
//  ViewController.swift
//  Montana Poker
//
//  Created by Bobby Keffury on 1/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    var highlightedRow: [UIButton]?
    var isTop = false
    var currentRow: Int = 1
    var deck: Deck?
    var bottomLastRow: [Int: UIImage] = [:]
    var topLastRow: [Int: UIImage] = [:]

    //MARK: - Outlets

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
    @IBOutlet weak var deckButton: UIButton!
    @IBOutlet weak var flopButton: UIButton!
    @IBOutlet var bottomCollumn1Cards: [UIButton]!
    @IBOutlet var bottomCollumn2Cards: [UIButton]!
    @IBOutlet var bottomCollumn3Cards: [UIButton]!
    @IBOutlet var bottomCollumn4Cards: [UIButton]!
    @IBOutlet var bottomCollumn5Cards: [UIButton]!
    @IBOutlet var bottomRow1Cards: [UIButton]!
    @IBOutlet var bottomRow2Cards: [UIButton]!
    @IBOutlet var bottomRow3Cards: [UIButton]!
    @IBOutlet var bottomRow4Cards: [UIButton]!
    @IBOutlet var bottomRow5Cards: [UIButton]!
    @IBOutlet var topCollumn1Cards: [UIButton]!
    @IBOutlet var topCollumn2Cards: [UIButton]!
    @IBOutlet var topCollumn3Cards: [UIButton]!
    @IBOutlet var topCollumn4Cards: [UIButton]!
    @IBOutlet var topCollumn5Cards: [UIButton]!
    @IBOutlet var topRow1Cards: [UIButton]!
    @IBOutlet var topRow2Cards: [UIButton]!
    @IBOutlet var topRow3Cards: [UIButton]!
    @IBOutlet var topRow4Cards: [UIButton]!
    @IBOutlet var topRow5Cards: [UIButton]!

    //MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    private func setupSubviews() {
        containerView.layer.cornerRadius = 10.0
        logoImageView.layer.cornerRadius = 10.0
        cleanSlate()
        setupButtonCorners([deckButton, flopButton])
        deckButton.setBackgroundImage(UIImage(named: "Red"), for: .normal)
        setupButtonCorners(bottomRow1Cards)
        setupButtonCorners(bottomRow2Cards)
        setupButtonCorners(bottomRow3Cards)
        setupButtonCorners(bottomRow4Cards)
        setupButtonCorners(bottomRow5Cards)
        setupButtonCorners(topRow1Cards)
        setupButtonCorners(topRow2Cards)
        setupButtonCorners(topRow3Cards)
        setupButtonCorners(topRow4Cards)
        setupButtonCorners(topRow5Cards)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 1.0) {
                self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            }
        }
        deck = Evaluator.shared.deck
    }

    private func clearRow(_ buttons: [UIButton]) {
        for button in buttons {
            button.isHidden = true
            button.isUserInteractionEnabled = false
        }
    }

    private func cleanSlate() {
        highlightRow([deckButton])
        clearRow(bottomRow2Cards)
        clearRow(bottomRow3Cards)
        clearRow(bottomRow4Cards)
        clearRow(bottomRow5Cards)
        clearRow(topRow2Cards)
        clearRow(topRow3Cards)
        clearRow(topRow4Cards)
        clearRow(topRow5Cards)
    }
    
    private func setupButtonCorners(_ buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = 5.0
        }
    }

    private func highlightRow(_ buttons: [UIButton]) {
        for button in buttons {
            if button == deckButton {
                button.isUserInteractionEnabled = true
            } else {
                if button.backgroundImage(for: .normal) == nil {
                    button.layer.borderWidth = 2
                    button.layer.borderColor = UIColor(named: "Gold")?.cgColor
                    button.isUserInteractionEnabled = true
                    button.isHidden = false
                }
            }
        }
    }

    private func unhighlightRow(_ buttons: [UIButton]) {
        for button in buttons {
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.white.cgColor
            button.isUserInteractionEnabled = false
        }
    }
    
    private func checkIfInLastRow(_ button: UIButton) -> Bool {
        for bottomButton in bottomRow5Cards {
            if bottomButton == button {
                return true
            }
        }
        for topButton in topRow5Cards {
            if topButton == button {
                return true
            }
        }
        return false
    }
    
    private func checkIfLastCardInRow(_ buttons: [UIButton]) -> Bool {
        var isLastInRow = true
        for button in buttons {
            if button.backgroundImage(for: .normal) == nil {
                isLastInRow = false
            }
        }
        return isLastInRow
    }
    
    private func finishGame() {
        deckButton.isHidden = true
        logoImageView.isHidden = true
        for button in bottomRow5Cards {
            let buttonIndex = bottomRow5Cards.firstIndex(of: button)
            let image = bottomLastRow[buttonIndex?.hashValue ?? 0]
            button.setBackgroundImage(image, for: .normal)
        }
        for button in topRow5Cards {
            let buttonIndex = topRow5Cards.firstIndex(of: button)
            let image = topLastRow[buttonIndex?.hashValue ?? 0]
            button.setBackgroundImage(image, for: .normal)
        }
    }

    private func rankHands(_ hand1: [String], _ hand2: [String]) -> [Int:Any] {
        var hands: [Int:Any] = [:]
        let handRank1 = Evaluator.shared.evaluate(cards: hand1)
        let handRank2 = Evaluator.shared.evaluate(cards: hand2)
        if handRank1.rank < handRank2.rank {
            hands[1] = handRank1
            hands[2] = 1
        } else {
            hands[1] = handRank2
            hands[2] = 2
        }
        return hands
    }

    //MARK: - Actions

    @IBAction func deckTapped(_ sender: Any) {
        guard let card = deck?.cards.popFirst() else {
            return
        }
        flopButton.setBackgroundImage(UIImage(named: "Deck/\(card.key)"), for: .normal)
        if isTop == true {
            UIView.animate(withDuration: 1.0) {
                self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            switch currentRow {
            case 1:
                highlightedRow = topRow1Cards
            case 2:
                highlightedRow = topRow2Cards
            case 3:
                highlightedRow = topRow3Cards
            case 4:
                highlightedRow = topRow4Cards
            case 5:
                highlightedRow = topRow5Cards
            default:
                return
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
            }
            switch currentRow {
            case 1:
                highlightedRow = bottomRow1Cards
            case 2:
                highlightedRow = bottomRow2Cards
            case 3:
                highlightedRow = bottomRow3Cards
            case 4:
                highlightedRow = bottomRow4Cards
            case 5:
                highlightedRow = bottomRow5Cards
            default:
                return
            }
        }
        highlightRow(highlightedRow ?? [])
        unhighlightRow([deckButton])
    }

    @IBAction func cardTapped(_ sender: UIButton) {
        if checkIfInLastRow(sender) == false {
            sender.setBackgroundImage(flopButton.backgroundImage(for: .normal), for: .normal)
        } else {
            if isTop == true {
                let buttonIndex = topRow5Cards.firstIndex(of: sender)
                topLastRow[buttonIndex?.hashValue ?? 0] = flopButton.backgroundImage(for: .normal) ?? UIImage()
            } else {
                let buttonIndex = bottomRow5Cards.firstIndex(of: sender)
                bottomLastRow[buttonIndex?.hashValue ?? 0] = flopButton.backgroundImage(for: .normal) ?? UIImage()
            }
            sender.setBackgroundImage(deckButton.backgroundImage(for: .normal), for: .normal)
        }
        sender.isUserInteractionEnabled = false
        flopButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        let oldHighlightedRow = highlightedRow
        if checkIfLastCardInRow(highlightedRow ?? []) == true {
            if isTop == true {
                currentRow += 1
                switch currentRow {
                case 2:
                    highlightedRow = bottomRow2Cards
                case 3:
                    highlightedRow = bottomRow3Cards
                case 4:
                    highlightedRow = bottomRow4Cards
                case 5:
                    highlightedRow = bottomRow5Cards
                case 6:
                    UIView.animate(withDuration: 1.0) {
                        self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
                    }
                    isTop = !isTop
                    unhighlightRow(oldHighlightedRow ?? [])
                    self.finishGame()
                default:
                    return
                }
            }
        }
        UIView.animate(withDuration: 1.0) {
            self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        }
        isTop = !isTop
        unhighlightRow(oldHighlightedRow ?? [])
        highlightRow([deckButton])
    }
}

