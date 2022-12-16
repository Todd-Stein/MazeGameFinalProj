//
//  ViewController.swift
//  MazeGameFinalProj
//
//  Created by Guest User on 12/13/22.
//

import UIKit

struct pair<T, I> {
    var first:T
    var second:I
}

struct stack<T> {
    var elems: [T] = []
    
    mutating func push(_ elem: T) {
        elems.insert(elem, at: 0)
    }
    mutating func pop() -> T?{
        if elems.isEmpty {
            return nil
        }
        return elems.removeFirst()
    }
    func top() -> T? {
        if elems.isEmpty {
            return nil
        }
        return elems.first
    }
}
struct Node {
    var visited:Bool
    var dirs:[direction]
}
enum direction {
    case north, south, east, west, none
}
class ViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pauseVC = segue.destination as? pauseMenu
        pauseVC?.mainVC = self
    }
    
    var saveData:UserDefaults = UserDefaults()
    
    @IBAction func unwindToPrevious(unwindSegue: UIStoryboardSegue) {
        
    }
    @IBOutlet weak var settingsButtonRef: UIButton!
    
    var restartButton:UIButton?
    var quitButton:UIButton?
    
    var startGame:Bool = false
    
    @IBOutlet var swipeRightRef: UISwipeGestureRecognizer!
    @IBOutlet var swipeLeftRef: UISwipeGestureRecognizer!
    
    @IBOutlet var swipeDownRef: UISwipeGestureRecognizer!
    @IBOutlet var swipeUpRef: UISwipeGestureRecognizer!
    @IBOutlet weak var upButtonRef: UIButton!
    
    @IBOutlet weak var leftButtonRef: UIButton!
    @IBOutlet weak var downButtonRef: UIButton!
    
    @IBOutlet weak var rightButtonRef: UIButton!
    @IBOutlet weak var startButtonRef: UIButton!
    @IBOutlet weak var outerBoundsTop: UIView!
    
    @IBOutlet weak var outerBoundsLeft: UIView!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var outerBoundsBottom: UIView!
    
    @IBOutlet weak var outerBoundsRight: UIView!
    
    @IBOutlet weak var titleText: UILabel!
    
    public var highScores: [String: Int] = [:]
    
    var goalPos:pair<Int, Int> = pair(first: 0, second: 0)
    var playerPos:pair<Int, Int> = pair(first: 0, second: 0)
    var playerRect:CGRect = (CGRect(x: 0, y: 0, width: 1, height: 1))
    var playerCell:UIView = UIView()
    public var playerColor:UIColor = .blue
    
    var countUpTimer:Timer?
    
    var goalRect:CGRect = CGRect(x: 0, y:0, width: 1, height: 1)
    var goalCell:UIView = UIView()
    public var goalColor:UIColor = .green
    
    public var boundsColor:UIColor = .red
    
    public var time:Float = 0.0 {
        didSet{timeLabel.text = "Time: \(floor(time*10)/10)"}
    }
    
    @objc func updateTimer(_ sender: Any) {
        time += 0.1
    }
    
    func StartGame() {
        startGame = true
        time = 0
        countUpTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        upButtonRef.isHidden = false
        downButtonRef.isHidden = false
        leftButtonRef.isHidden = false
        rightButtonRef.isHidden = false
        timeLabel.isHidden = false
        if(titleText != nil) {
            titleText.text = ""
        }
        if(startButtonRef != nil) {
            startButtonRef.removeFromSuperview()
        }
        if(settingsButtonRef != nil) {
            settingsButtonRef.removeFromSuperview()
        }
        let screenWidth = displayBounds.bounds.width
        let screenHeight = displayBounds.bounds.height

        eastWallHeight = Int(screenHeight)/mazeHeight
        eastWallWidth = Int(Float(Int(screenWidth)/mazeWidth)*0.1)
        southWallWidth = Int(screenWidth)/mazeWidth
        southWallHeight = Int(Float(Int(screenHeight)/mazeHeight)*0.1)
        generateMaze()
        drawMaze()
    }
    func gameWon() {
        startGame = false
        let score:Int = ((600)/Int(time))*100
        countUpTimer?.invalidate()
        highScores["\(mazeWidth)x\(mazeHeight)"] = score
        
        titleText.text = "You Win!!!\nScore: \(score)"
        saveData.setValue(highScores, forKey: "highScores")
        let restartRect:CGRect = CGRect(x: 200, y: 110, width: 137, height: 78)
        restartButton = UIButton(frame: restartRect)
        restartButton?.backgroundColor = .gray
        restartButton?.setTitle("Restart", for: .normal)
        displayBounds.addSubview(restartButton!)
        restartButton?.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        self.view.bringSubviewToFront(restartButton!)
        let quitRect:CGRect = CGRect(x: 400, y: 110, width: 137, height: 78)
        quitButton = UIButton(frame: quitRect)
        quitButton?.backgroundColor = .gray
        quitButton?.setTitle("Quit", for: .normal)
        displayBounds.addSubview(quitButton!)
        quitButton?.addTarget(self, action: #selector(quitGame), for: .touchUpInside)
        self.view.bringSubviewToFront(quitButton!)
    }
    @objc func quitGame(_ sender: Any) {
        swipeUpRef = nil
        swipeDownRef = nil
        swipeLeftRef = nil
        swipeRightRef = nil
        self.loadView()
        outerBoundsTop.backgroundColor = .clear
        outerBoundsLeft.backgroundColor = .clear
        outerBoundsRight.backgroundColor = .clear
        outerBoundsBottom.backgroundColor = .clear
        upButtonRef.isHidden = true
        downButtonRef.isHidden = true
        leftButtonRef.isHidden = true
        timeLabel.isHidden = true
        rightButtonRef.isHidden = true
    }
    @objc func restartGame(_ sender: Any) {
        for bound in mazeBounds {
            bound.removeFromSuperview()
        }
        mazeBounds.removeAll()
        if(restartButton != nil) {
            restartButton?.removeFromSuperview()
        }
        if(quitButton != nil) {
            quitButton?.removeFromSuperview()
        }
        playerCell.removeFromSuperview()
        StartGame()
    }
    
    @IBAction func buttonRight(_ sender: Any) {
        if(startGame) {
            MoveRight()
        }
    }
    
    @IBAction func buttonLeft(_ sender: Any) {
        if(startGame) {
            MoveLeft()
        }
    }
    
    @IBAction func buttonDown(_ sender: Any) {
        if(startGame) {
            MoveDown()
        }
    }
    
    @IBAction func buttonUp(_ sender: Any) {
        if(startGame) {
            MoveUp()
        }
    }
    
    
    @IBAction func startButton(_ sender: Any) {
            StartGame()
    }
    
    
    @IBAction func swipeRight(_ sender: Any) {
        if(startGame) {
            MoveRight()
        }
    }
    @IBAction func swipeLeft(_ sender: Any) {
        if(startGame) {
            MoveLeft()
        }
    }
    @IBAction func swipeDown(_ sender: Any) {
        if(startGame) {
            MoveDown()
        }
    }
    @IBAction func swipeUp(_ sender: Any) {
        if(startGame) {
            MoveUp()
        }
    }
    
    @IBOutlet weak var displayBounds: UIView!
    
    func MoveRight() {
        if(playerPos.first+1<mazeWidth) {
            if(maze[playerPos.first][playerPos.second].dirs.contains(direction.east)) {
                playerPos.first = playerPos.first+1
                playerCell.removeFromSuperview()
                var xPos:Int = playerPos.first
                var yPos:Int = playerPos.second
                xPos = xPos*(southWallWidth ?? 0)
                yPos = yPos*(eastWallHeight ?? 0)
                playerRect = (CGRect(x: xPos, y: yPos, width: (southWallWidth ?? 0), height: (eastWallHeight ?? 0)))
                playerCell = UIView(frame: playerRect)
                playerCell.backgroundColor = playerColor
                displayBounds.addSubview(playerCell)
                displayBounds.sendSubviewToBack(playerCell)
                displayBounds.sendSubviewToBack(goalCell)
                if(xPos == goalPos.first) && (yPos == goalPos.second) {
                    gameWon()
                }
            }
        }
    }
    func MoveLeft() {
        if(playerPos.first-1>=0) {
            if(maze[playerPos.first][playerPos.second].dirs.contains(direction.west))
            {
                playerPos.first = playerPos.first-1
                playerCell.removeFromSuperview()
                var xPos:Int = playerPos.first
                var yPos:Int = playerPos.second
                xPos = xPos*(southWallWidth ?? 0)
                yPos = yPos*(eastWallHeight ?? 0)
                playerRect = (CGRect(x: xPos, y: yPos, width: (southWallWidth ?? 0), height: (eastWallHeight ?? 0)))
                playerCell = UIView(frame: playerRect)
                playerCell.backgroundColor = playerColor
                displayBounds.addSubview(playerCell)
                displayBounds.sendSubviewToBack(playerCell)
                displayBounds.sendSubviewToBack(goalCell)
                if(xPos == goalPos.first) && (yPos == goalPos.second) {
                    gameWon()
                }
            }
        }
    }
    
    func MoveUp() {
        if(playerPos.second-1>=0) {
            if(maze[playerPos.first][playerPos.second].dirs.contains(direction.north)) {
                playerPos.second = playerPos.second-1
                playerCell.removeFromSuperview()
                var xPos:Int = playerPos.first
                var yPos:Int = playerPos.second
                xPos = xPos*(southWallWidth ?? 0)
                yPos = yPos*(eastWallHeight ?? 0)
                playerRect = (CGRect(x: xPos, y: yPos, width: (southWallWidth ?? 0), height: (eastWallHeight ?? 0)))
                playerCell = UIView(frame: playerRect)
                playerCell.backgroundColor = playerColor
                displayBounds.addSubview(playerCell)
                displayBounds.sendSubviewToBack(playerCell)
                displayBounds.sendSubviewToBack(goalCell)
                if(xPos == goalPos.first) && (yPos == goalPos.second) {
                    gameWon()
                }
            }
        }
    }
    
    
    func MoveDown() {
        if(playerPos.second+1<mazeHeight) {
            if(maze[playerPos.first][playerPos.second].dirs.contains(direction.south)) {
                playerPos.second = playerPos.second+1
                playerCell.removeFromSuperview()
                var xPos:Int = playerPos.first
                var yPos:Int = playerPos.second
                xPos = xPos*(southWallWidth ?? 0)
                yPos = yPos*(eastWallHeight ?? 0)
                playerRect = (CGRect(x: xPos, y: yPos, width: (southWallWidth ?? 0), height: (eastWallHeight ?? 0)))
                playerCell = UIView(frame: playerRect)
                playerCell.backgroundColor = playerColor
                displayBounds.addSubview(playerCell)
                displayBounds.sendSubviewToBack(playerCell)
                displayBounds.sendSubviewToBack(goalCell)
                if(xPos == goalPos.first) && (yPos == goalPos.second) {
                    gameWon()
                }
            }
        }
    }
    
    
    var mazeBounds:[UIView] = []
    public var mazeWidth:Int = 20
    public var mazeHeight:Int = 10
    
    var maze:[[Node]] = []
    
    var eastWallWidth:Int?
    var eastWallHeight:Int?
    var southWallWidth:Int?
    var southWallHeight:Int?
    
    
    func generateMaze()
    {
        
        var visitedStack:stack<pair<Int, Int>> = stack()
        
        var visitedCount:Int = 0
        var visitedTotal:Int = 0
        let tempNode:Node = Node(visited: false, dirs: [direction.none])

        maze = [[Node]](repeating: [Node](repeating: tempNode, count: mazeHeight), count: mazeWidth)
        for i in 0...mazeWidth-1 {
            for j in 0...mazeHeight-1 {
                maze[i][j] = tempNode
            }
        }
        visitedTotal = mazeWidth*mazeHeight
        
        visitedCount = 1
        visitedStack.push(pair(first: 0, second: 0))
        
        var x:Int = 0
        var y:Int = 0
        
        maze[x][y].visited = true
        while (visitedCount<visitedTotal) {
            var possibleDirections:[direction] = []
            //print(visitedStack?.top()?.first ?? -1)
            x = visitedStack.top()?.first ?? 0
            y = visitedStack.top()?.second ?? 0
            
            if (y-1 >= 0) {
                if(!maze[x][y-1].visited) {
                    possibleDirections.append(direction.north)
                }
            }
            if (y+1<mazeHeight) {
                if(!maze[x][y+1].visited) {
                    possibleDirections.append(direction.south)
                }
            }
            
            if (x-1 >= 0) {
                if(!maze[x-1][y].visited) {
                    possibleDirections.append(direction.west)
                }
            }
            if (x+1<mazeWidth) {
                if(!maze[x+1][y].visited) {
                    possibleDirections.append(direction.east)
                }
            }
            
            if(!possibleDirections.isEmpty) {
                var canContinue:Bool = false
                while(!canContinue) {
                    var nextDir:pair<Int, Int> = pair(first: x, second: y)
                    let index:Int = Int.random(in: 0...possibleDirections.count-1)
                    let testDirection:direction = possibleDirections[index]
                    var linkDirection:direction = .none
                    var linkDirInv:direction = .none
                    switch testDirection {
                        case .north:
                            nextDir.first = x
                            nextDir.second = y-1
                            linkDirection = .north
                            linkDirInv = .south
                        
                        case .south:
                            nextDir.first = x
                            nextDir.second = y+1
                            linkDirection = .south
                            linkDirInv = .north
                        case .east:
                            nextDir.first = x+1
                            nextDir.second = y
                            linkDirection = .east
                            linkDirInv = .west
                        case .west:
                            nextDir.first = x-1
                            nextDir.second = y
                            linkDirection = .west
                            linkDirInv = .east
                        case .none:
                            canContinue = false
                    }
                    
                    if(!maze[nextDir.first][nextDir.second].visited) {
                        canContinue = true
                        visitedCount+=1
                        maze[nextDir.first][nextDir.second].visited = true
                        maze[x][y].dirs.append(linkDirection)
                        maze[nextDir.first][nextDir.second].dirs.append(linkDirInv)

                        visitedStack.push(pair(first: nextDir.first, second: nextDir.second))
                    }
                    else {
                        possibleDirections.remove(at: index)
                    }
                    if(possibleDirections.isEmpty) {
                        canContinue = true
                        visitedStack.pop()
                    }
                }
            }
            else {
                visitedStack.pop()
            }
        }
    }
    func drawMaze() {
        var canGoSouth:Bool = false
        var canGoEast:Bool = false
        for i in 0...mazeWidth-1 {
            for j in 0...mazeHeight-1 {
                canGoEast = maze[i][j].dirs.contains(direction.east)
                canGoSouth = maze[i][j].dirs.contains(direction.south)
                if(i<mazeWidth-1) {
                    if (!canGoEast) {
                        let bound:CGRect = CGRect(x: ((southWallWidth ?? 0)*(i+1)), y: ((eastWallHeight ?? 0)*j), width: eastWallWidth ?? 0, height: eastWallHeight ?? 0)
                        let boundView:UIView = UIView(frame: bound)
                        boundView.backgroundColor = boundsColor
                        mazeBounds.append(boundView)
                        displayBounds.addSubview(boundView)
                    }
                }
                if(j<mazeHeight-1) {
                    if(!canGoSouth) {
                        let bound:CGRect = CGRect(x: ((southWallWidth ?? 0)*(i)), y: ((eastWallHeight ?? 0)*(j+1)), width: southWallWidth ?? 0, height: southWallHeight ?? 0)
                        let boundView:UIView = UIView(frame: bound)
                        boundView.backgroundColor = boundsColor
                        mazeBounds.append(boundView)
                        displayBounds.addSubview(boundView)
                    }
                }
                canGoEast = false
                canGoSouth = false
            }
        }
        playerPos.first = 0
        playerPos.second = 0
        var xPos:Int = playerPos.first
        var yPos:Int = playerPos.second
        xPos = xPos*(southWallWidth ?? 0)
        yPos = yPos*(eastWallHeight ?? 0)
        playerRect = (CGRect(x: xPos, y: yPos, width: (southWallWidth ?? 0), height: (eastWallHeight ?? 0)))
        playerCell = UIView(frame: playerRect)
        playerCell.backgroundColor = playerColor
        displayBounds.addSubview(playerCell)
        displayBounds.sendSubviewToBack(playerCell)
        outerBoundsTop.backgroundColor = boundsColor
        outerBoundsLeft.backgroundColor = boundsColor
        outerBoundsRight.backgroundColor = boundsColor
        outerBoundsBottom.backgroundColor = boundsColor
        xPos = southWallWidth ?? 0
        xPos = xPos * (mazeWidth-1)
        yPos = eastWallHeight ?? 0
        yPos = yPos * (mazeHeight-1)
        goalPos.first = xPos
        goalPos.second = yPos
        goalRect = CGRect(x: xPos, y: yPos, width: southWallWidth ?? 0, height: eastWallHeight ?? 0)
        goalCell = UIView(frame: goalRect)
        goalCell.backgroundColor = goalColor
        displayBounds.addSubview(goalCell)
        displayBounds.sendSubviewToBack(goalCell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let savedScores = saveData.value(forKey: "highScores") as? [String: Int] {
            highScores = savedScores
        }
        if let savedWidth = saveData.value(forKey: "mazeWidth") as? Int {
            mazeWidth = savedWidth
        }
        if let savedHeight = saveData.value(forKey: "mazeHeight") as? Int {
            mazeHeight = savedHeight
        }
        if let savedBorderColor = saveData.value(forKey: "borderColor") as? [CGFloat] {
            boundsColor = UIColor(red: savedBorderColor[0], green: savedBorderColor[1], blue: savedBorderColor[2], alpha: 1.0)
        }
        if let savedPlayerColor = saveData.value(forKey: "playerColor") as? [CGFloat] {
            playerColor = UIColor(red: savedPlayerColor[0], green: savedPlayerColor[1], blue: savedPlayerColor[2], alpha: 1.0)
        }
        if let savedGoalColor = saveData.value(forKey: "goalColor") as? [CGFloat] {
            goalColor = UIColor(red: savedGoalColor[0], green: savedGoalColor[1], blue: savedGoalColor[2], alpha: 1.0)
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        outerBoundsTop.backgroundColor = .clear
        outerBoundsLeft.backgroundColor = .clear
        outerBoundsRight.backgroundColor = .clear
        outerBoundsBottom.backgroundColor = .clear
        upButtonRef.isHidden = true
        downButtonRef.isHidden = true
        leftButtonRef.isHidden = true
        rightButtonRef.isHidden = true
        timeLabel.isHidden = true
    }

}

