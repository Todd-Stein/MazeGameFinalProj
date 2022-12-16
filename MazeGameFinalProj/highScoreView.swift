//
//  highScoreView.swift
//  MazeGameFinalProj
//
//  Created by Guest User on 12/16/22.
//

import UIKit

class highScoreView : UIViewController {
    
    
    public var highScores: [String: Int] = [:]
    public var prevVC:pauseMenu?
    var table:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        highScores = prevVC!.highScores
        let tableRect:CGRect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        table = UITableView(frame: tableRect, style: .plain)
        if(highScores.count>0) {
            table?.insertRows(at: [IndexPath(row: highScores.count-1, section: 0)], with: .automatic)
        }
    }
}
