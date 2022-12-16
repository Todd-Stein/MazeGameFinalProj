//
//  pauseMenu.swift
//  MazeGameFinalProj
//
//  Created by Guest User on 12/16/22.
//

import UIKit
class pauseMenu: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scoreVC = segue.destination as? highScoreView
        scoreVC?.prevVC = self
    }
    
    public var highScores: [String: Int] = [:]
    
    @IBAction func unwindToPrevious(unwindSegue: UIStoryboardSegue) {
        
    }
    
    public var mainVC:ViewController?
    @IBOutlet weak var mazeHeightText: UILabel!
    @IBOutlet weak var mazeWidthText: UILabel!
    
    @IBOutlet weak var goalColorValue: UIColorWell!
    @IBOutlet weak var playerColorValue: UIColorWell!
    @IBOutlet weak var borderColorValue: UIColorWell!
    @IBOutlet weak var mazeWidthValue: UIStepper!
    @IBOutlet weak var mazeHeightValue: UIStepper!
    @IBAction func mazeHeightChange(_ sender: Any) {
        mazeHeightText.text = "Maze Height: \(Int(mazeHeightValue.value))"
        mainVC?.mazeHeight = Int(mazeHeightValue.value)
        mainVC?.saveData.setValue(mainVC?.mazeHeight, forKey: "mazeHeight")
    }
    
    @IBAction func mazeWidthChange(_ sender: Any) {
        mazeWidthText.text = "Maze Width: \(Int(mazeWidthValue.value))"
        mainVC?.mazeWidth = Int(mazeWidthValue.value)
        mainVC?.saveData.setValue(mainVC?.mazeWidth, forKey: "mazeWidth")
    }
    @objc func updateBorderColor(_ sender: Any) {
        mainVC?.boundsColor = borderColorValue?.selectedColor ?? .white
        var red:CGFloat = 1.0
        var green:CGFloat = 1.0
        var blue:CGFloat = 1.0
        var alpha:CGFloat = 1.0
        borderColorValue?.selectedColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let colorArr:[CGFloat] = [red, green, blue]
        mainVC?.saveData.setValue(colorArr, forKey: "borderColor")
    }
    @objc func updatePlayerColor(_ sender: Any) {
        mainVC?.playerColor = playerColorValue?.selectedColor ?? .white
        var red:CGFloat = 1.0
        var green:CGFloat = 1.0
        var blue:CGFloat = 1.0
        var alpha:CGFloat = 1.0
        playerColorValue?.selectedColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let colorArr:[CGFloat] = [red, green, blue]
        mainVC?.saveData.setValue(colorArr, forKey: "playerColor")
    }
    @objc func updateGoalColor(_ sender: Any) {
        mainVC?.goalColor = goalColorValue?.selectedColor ?? .white
        var red:CGFloat = 1.0
        var green:CGFloat = 1.0
        var blue:CGFloat = 1.0
        var alpha:CGFloat = 1.0
        goalColorValue?.selectedColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let colorArr:[CGFloat] = [red, green, blue]
        mainVC?.saveData.setValue(colorArr, forKey: "goalColor")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        highScores = mainVC!.highScores
        borderColorValue.addTarget(self, action: #selector(updateBorderColor), for: .valueChanged)
        playerColorValue.addTarget(self, action: #selector(updatePlayerColor), for: .valueChanged)
        goalColorValue.addTarget(self, action: #selector(updateGoalColor), for: .valueChanged)
        mazeWidthValue.value = Double(mainVC?.mazeWidth ?? 10)
        mazeHeightValue.value = Double(mainVC?.mazeHeight ?? 5)
        mazeHeightText.text = "Maze Height: \(Int(mazeHeightValue.value))"
        mazeWidthText.text = "Maze Width: \(Int(mazeWidthValue.value))"
        borderColorValue.selectedColor = mainVC?.boundsColor
        playerColorValue.selectedColor = mainVC?.playerColor
        goalColorValue.selectedColor = mainVC?.goalColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
