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
    
    
    @IBOutlet weak var outerBoundsTop: UIView!
    
    @IBOutlet weak var outerBoundsLeft: UIView!
    
    
    @IBOutlet weak var outerBoundsBottom: UIView!
    
    @IBOutlet weak var outerBoundsRight: UIView!
    
    
    var playerPos:pair<Int, Int> = pair(first: 0, second: 0)
    var playerRect:CGRect = (CGRect(x: 0, y: 0, width: 1, height: 1))
    var playerCell:UIView = UIView()
    var playerColor:UIColor = .blue
    
    
    var goalRect:CGRect = CGRect(x: 0, y:0, width: 1, height: 1)
    var goalCell:UIView = UIView()
    var goalColor:UIColor = .green
    
    var boundsColor:UIColor = .red
    
    
    @IBAction func swipeRight(_ sender: Any) {
        MoveRight()
    }
    @IBAction func swipeLeft(_ sender: Any) {
            MoveLeft()
    }
    @IBAction func swipeDown(_ sender: Any) {
            MoveDown()
    }
    @IBAction func swipeUp(_ sender: Any) {
            MoveUp()
    }
    
    @IBOutlet weak var displayBounds: UIView!
    
    func MoveRight() {
        if(playerPos.first+1<mazeWidth) {
            print("moveRight1")
            if(maze[playerPos.first][playerPos.second].dirs.contains(direction.east)) {
                print("moveRight2")
                playerPos.first = playerPos.first+1
                playerCell.removeFromSuperview()
                var xPos:Int = playerPos.first
                var yPos:Int = playerPos.second
                xPos = xPos*(southWallWidth ?? 0)
                yPos = yPos*(eastWallHeight ?? 0)
                playerRect = (CGRect(x: xPos, y: yPos, width: (southWallWidth ?? 0), height: (eastWallHeight ?? 0)))
                playerCell = UIView(frame: playerRect)
                playerCell.backgroundColor = .blue
                displayBounds.addSubview(playerCell)
                displayBounds.sendSubviewToBack(playerCell)
                displayBounds.sendSubviewToBack(goalCell)
            }
        }
    }
    func MoveLeft() {
        print(playerPos.first)
        if(playerPos.first-1>=0) {
            print("moveLeft1")
            if(maze[playerPos.first][playerPos.second].dirs.contains(direction.west))
            {
                print("moveLeft2")
                playerPos.first = playerPos.first-1
                playerCell.removeFromSuperview()
                var xPos:Int = playerPos.first
                var yPos:Int = playerPos.second
                xPos = xPos*(southWallWidth ?? 0)
                yPos = yPos*(eastWallHeight ?? 0)
                playerRect = (CGRect(x: xPos, y: yPos, width: (southWallWidth ?? 0), height: (eastWallHeight ?? 0)))
                playerCell = UIView(frame: playerRect)
                playerCell.backgroundColor = .blue
                displayBounds.addSubview(playerCell)
                displayBounds.sendSubviewToBack(playerCell)
                displayBounds.sendSubviewToBack(goalCell)
            }
        }
    }
    
    func MoveUp() {
        if(playerPos.second-1>0) {
            print("moveUp1")
            if(maze[playerPos.first][playerPos.second].dirs.contains(direction.north)) {
                print("moveUp2")
                playerPos.second = playerPos.second-1
                playerCell.removeFromSuperview()
                var xPos:Int = playerPos.first
                var yPos:Int = playerPos.second
                xPos = xPos*(southWallWidth ?? 0)
                yPos = yPos*(eastWallHeight ?? 0)
                playerRect = (CGRect(x: xPos, y: yPos, width: (southWallWidth ?? 0), height: (eastWallHeight ?? 0)))
                playerCell = UIView(frame: playerRect)
                playerCell.backgroundColor = .blue
                displayBounds.addSubview(playerCell)
                displayBounds.sendSubviewToBack(playerCell)
                displayBounds.sendSubviewToBack(goalCell)
            }
        }
    }
    
    
    func MoveDown() {
        if(playerPos.second+1<mazeHeight) {
            print("moveDown1")
            if(maze[playerPos.first][playerPos.second].dirs.contains(direction.south)) {
                print("moveDown2")
                playerPos.second = playerPos.second+1
                playerCell.removeFromSuperview()
                var xPos:Int = playerPos.first
                var yPos:Int = playerPos.second
                xPos = xPos*(southWallWidth ?? 0)
                yPos = yPos*(eastWallHeight ?? 0)
                playerRect = (CGRect(x: xPos, y: yPos, width: (southWallWidth ?? 0), height: (eastWallHeight ?? 0)))
                playerCell = UIView(frame: playerRect)
                playerCell.backgroundColor = .blue
                displayBounds.addSubview(playerCell)
                displayBounds.sendSubviewToBack(playerCell)
                displayBounds.sendSubviewToBack(goalCell)
            }
        }
    }
    
    
    var mazeBounds:[UIView] = []
    var mazeWidth:Int = 20
    var mazeHeight:Int = 10
    
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
                        boundView.backgroundColor = .red
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
        xPos = xPos * mazeWidth
        yPos = eastWallHeight ?? 0
        yPos = yPos * mazeHeight
        goalRect = CGRect(x: xPos, y: yPos, width: southWallWidth ?? 0, height: eastWallHeight ?? 0)
        goalCell = UIView(frame: goalRect)
        goalCell.backgroundColor = goalColor
        displayBounds.sendSubviewToBack(goalCell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("ebhfuwebf")
        let screenWidth = displayBounds.bounds.width
        let screenHeight = displayBounds.bounds.height

        eastWallHeight = Int(screenHeight)/mazeHeight
        eastWallWidth = Int(Float(Int(screenWidth)/mazeWidth)*0.1)
        southWallWidth = Int(screenWidth)/mazeWidth
        southWallHeight = Int(Float(Int(screenHeight)/mazeHeight)*0.1)
        generateMaze()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawMaze()
    }

}

