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
    
    
    var playerPos:pair<Int, Int> = pair(first: 0, second: 0)
    
    var playerRect:CGRect = (CGRect(x: 0, y: 0, width: 1, height: 1))
    var playerCell:UIView = UIView()
    
    
    @IBOutlet weak var displayBounds: UIView!
    
    @IBAction func upPressed(_ sender: Any) {
        if(playerPos.second-1>0) {
            if(maze[playerPos.first][playerPos.second-1].dirs.contains(direction.north)) {
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
            }
        }
    }
    @IBAction func leftPressed(_ sender: Any) {
        if(playerPos.second+1<mazeHeight) {
            if(maze[playerPos.first][playerPos.second+1].dirs.contains(direction.south)) {
                playerPos.second = playerPos.second+1
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
            }
        }
    }
    @IBAction func downPressed(_ sender: Any) {
        if(playerPos.first-1>0) {
            if(maze[playerPos.first-1][playerPos.second].dirs.contains(direction.west)) {
                playerPos.first = playerPos.first-1
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
            }
        }
    }
    @IBAction func rightPressed(_ sender: Any) {
        if(playerPos.first+1<mazeWidth) {
            if(maze[playerPos.first+1][playerPos.second].dirs.contains(direction.east)) {
                playerPos.first = playerPos.first+1
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
        
        
        var canGoSouth:Bool = false
        var canGoEast:Bool = false
        for i in 0...mazeWidth-1 {
            for j in 0...mazeHeight-1 {
                canGoEast = maze[i][j].dirs.contains(direction.east)
                canGoSouth = maze[i][j].dirs.contains(direction.south)
                if(i<mazeWidth-1) {
                    if (!canGoEast) {
                        var x:CGFloat = CGFloat(((southWallWidth ?? 0)*(i+1)))
                        if(j<mazeHeight-1) {
                            x = x-CGFloat(((southWallWidth ?? 0)/2))
                        }
                        //if(i<mazeWidth/2) {
                        //    x = x+1
                        //}
                        //else if(i>mazeWidth/2) {
                        //    x = x-1
                        //}
                        let bound:CGRect = CGRect(x: Int(x), y: ((eastWallHeight ?? 0)*j), width: eastWallWidth ?? 0, height: eastWallHeight ?? 0)
                        let boundView:UIView = UIView(frame: bound)
                        boundView.backgroundColor = .red
                        mazeBounds.append(boundView)
                        displayBounds.addSubview(boundView)
                    }
                }
                if(j<mazeHeight-1) {
                    if(!canGoSouth) {
                        var y:CGFloat = CGFloat(((eastWallWidth ?? 0)*(j+1)))
                        if(i<mazeWidth-1) {
                            y = y-CGFloat(((eastWallWidth ?? 0)/2))
                        }
                        //if(j<mazeHeight/2) {
                        //    y = y+5
                        //}
                        //else if(j>mazeHeight/2) {
                        //    y = y-5
                        //}
                        let bound:CGRect = CGRect(x: ((southWallWidth ?? 0)*(i)), y: ((eastWallHeight ?? 0)*(j+1)), width: southWallWidth ?? 0, height: southWallHeight ?? 0)
                        let boundView:UIView = UIView(frame: bound)
                        boundView.backgroundColor = .red
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
        playerCell.backgroundColor = .blue
        displayBounds.addSubview(playerCell)
        
    }

}

