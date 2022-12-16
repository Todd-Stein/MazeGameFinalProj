//
//  highScoreView.swift
//  MazeGameFinalProj
//
//  Created by Guest User on 12/16/22.
//

import UIKit

class highScoreView : UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        row.textLabel?.text = cellsArray[indexPath.row]
        return row
    }
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet var table:UITableView!
    var cellsArray:[String] = []
    
    public var highScores: [String: Int] = [:]
    public var prevVC:pauseMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScores = prevVC!.highScores
        for i in highScores {
            var temp = i.key
            temp = temp+(": ")
            temp = temp+String(i.value)
            cellsArray.append(temp)
        }
        table.delegate = self
        table.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textLabel.text = "High Score:\nDimensions: Score"
    }
}
