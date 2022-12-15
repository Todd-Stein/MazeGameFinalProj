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
    

    
    var mazeWidth:Int = 20
    var mazeHeight:Int = 10
    
    var maze:[[Node]] = []
    
    var eastWallWidth:Int?
    var eastWallHeight:Int?
    var southWallWidth:Int?
    var southWallHeight:Int?
    
    var mazeBounds:Array<Any>?
    
    func generateMaze()
    {
        
        var visitedStack:stack<pair<Int, Int>> = stack()
        
        var visitedCount:Int = 0
        var visitedTotal:Int = 0
        var tempNode:Node = Node(visited: false, dirs: [direction.none])

        maze = [[Node]](repeating: [Node](repeating: tempNode, count: mazeHeight), count: mazeWidth)
        for i in 0...mazeWidth-1 {
            for j in 0...mazeHeight-1 {
                maze[i][j] = tempNode
                //print("\t\(i)\t\(j)\t\(maze[i][j])")
            }
        }
        visitedTotal = mazeWidth*mazeHeight
        
        visitedCount = 1
        visitedStack.push(pair(first: 0, second: 0))
        
        var x:Int = 0
        var y:Int = 0
        
        while (visitedCount<visitedTotal) {
            var possibleDirections:[direction] = []
            //print(visitedStack?.top()?.first ?? -1)
            x = visitedStack.top()?.first ?? 0
            y = visitedStack.top()?.second ?? 0
            print("\(visitedCount)\t\(x)\t\(y)")
            //print("\(x)\t\(y)")
            
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
                        maze[x][y].visited = true
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
        for i in 0...mazeWidth-1 {
            for j in 0...mazeHeight-1 {
                //maze[i][j] = direction.none
                print("\t\(i)\t\(j)\t\(maze[i][j])")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height
        eastWallHeight = Int(screenHeight)/mazeHeight
        eastWallWidth = Int(Float(Int(screenWidth)/mazeWidth)*0.1)
        southWallWidth = Int(screenWidth)/mazeWidth
        southWallHeight = Int(Float(Int(screenHeight)/mazeHeight)*0.1)
        generateMaze()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let bound = CGRect(x: 20, y:50, width:southWallWidth ?? 0, height: southWallHeight ?? 0)
        
        let boundView = UIView(frame: bound)
        boundView.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        self.view.addSubview(boundView)
        print(boundView)
    }

}

