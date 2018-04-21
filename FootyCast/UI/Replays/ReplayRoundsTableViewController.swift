//
//  ReplayRoundsTableViewController.swift
//  FootyCast
//
//  Created by Evan Robertson on 14/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit

class ReplayRoundsTableViewController: UITableViewController {

    weak var delegate: ReplayRoundsTableViewControllerDelegate?
    
    var rounds: [AFLRound] = [] {
        didSet {
            if isViewLoaded { tableView.reloadData() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCastButton()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let round = rounds[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "roundCell", for: indexPath)
        
        cell.textLabel?.text = round.name
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let round = rounds[indexPath.row]
        delegate?.replayRoundsTableViewController(self, didSelectRound: round)
    }
}

protocol ReplayRoundsTableViewControllerDelegate: class {
    func replayRoundsTableViewController(_ replayRoundsTableViewController: ReplayRoundsTableViewController,
                                         didSelectRound round: AFLRound)
}
