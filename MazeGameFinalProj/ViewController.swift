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

class ViewController: UIViewController {

    var visitedStack:stack<pair<Int, Int>>?
    
    var visitedCount:Int = 0
    var visitedTotal:Int = 0
    
    enum direction {
        case north, south, east, west, none
    }
    

    
    var mazeWidth:Int = 20
    var mazeHeight:Int = 10
    
    var maze:[[direction]] = []
    
    var eastWallWidth:Int?
    var eastWallHeight:Int?
    var southWallWidth:Int?
    var southWallHeight:Int?
    
    var mazeBounds:Array<Any>?
    
    func generateMaze()
    {
        var mazeBool = [[Bool]](repeating: [Bool](repeating: false, count: mazeHeight), count: mazeWidth)
        maze = [[direction]](repeating: [direction](repeating: direction.none, count: mazeHeight), count: mazeWidth)
        for i in 0...mazeWidth-1 {
            for j in 0...mazeHeight-1 {
                maze[i][j] = direction.none
                mazeBool[i][j] = false
                //print("\t\(i)\t\(j)\t\(maze[i][j])")
            }
        }
        visitedTotal = mazeWidth*mazeHeight
        var possibleDirections:[direction] = []
        visitedCount = 1
        visitedStack?.push(pair(first: 0, second: 0))
        
        while (visitedCount<visitedTotal) {
            if (visitedStack?.top()?.second ?? 0>0) {
                possibleDirections.append(direction.north)
            }
            if (visitedStack?.top()?.second ?? 0<mazeHeight) {
                possibleDirections.append(direction.south)
            }
            if (visitedStack?.top()?.first ?? 0>0) {
                possibleDirections.append(direction.west)
            }
            if (visitedStack?.top()?.first ?? 0<mazeWidth) {
                possibleDirections.append(direction.east)
            }
            var canContinue:Bool = false
            while(!canContinue) {
                if(possibleDirections.count>0) {
                    var index:Int = 0
                    index = Int.random(in: 0...possibleDirections.count-1)
                    let tempPair = visitedStack?.top()
                    switch(possibleDirections[index]) {
                        case direction.north:
                        canContinue = maze[tempPair?.first ?? 0][(tempPair?.second ?? 0)-1] == direction.none
                        case direction.south:
                        canContinue = maze[tempPair?.first ?? 0][(tempPair?.second ?? 0)+1] == direction.none
                        case direction.west:
                        canContinue = maze[(tempPair?.first ?? 0)-1][tempPair?.second ?? 0] == direction.none
                        case direction.east:
                        canContinue = maze[(tempPair?.first ?? 0)+1][tempPair?.second ?? 0] == direction.none
                    case .none:
                        canContinue = false
                    }
                    if(canContinue){
                        visitedCount+=1
                        let tempPair = visitedStack?.top()
                        var x:Int = tempPair?.first ?? 0
                        var y:Int = tempPair?.second ?? 0
                        switch(possibleDirections[index]) {
                            case direction.north:
                                maze[x][y] = direction.north
                                y-=1
                                visitedStack?.push(pair(first: x, second: y))
                            maze[x][y] = direction.south
                                possibleDirections.removeAll()
                            case direction.south:
                            maze[x ][y ] = direction.south
                                y+=1
                                visitedStack?.push(pair(first: x, second: y))
                                maze[x][y] = direction.north
                                possibleDirections.removeAll()
                            case direction.west:
                                maze[x][y] = direction.west
                                x-=1
                                visitedStack?.push(pair(first: x, second: y))
                                maze[x][y] = direction.east
                                possibleDirections.removeAll()
                            case direction.east:
                                maze[x][y] = direction.east
                                x+=1
                                visitedStack?.push(pair(first: x, second: y))
                                maze[x][y] = direction.west
                                possibleDirections.removeAll()
                        case .none:
                            canContinue = false
                        }
                    }
                }
                else if(possibleDirections.count == 0) {
                    visitedStack?.pop()
                    possibleDirections.removeAll()
                }
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

