//
//  ReplayTypesTableViewController.swift
//  FootyCast
//
//  Created by Evan Robertson on 25/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit

enum SeasonType: Int {
    case premiership, preseason
    
    var title: String {
        switch self {
        case .preseason:
            return "Preseason"
        case .premiership:
            return "Premiership"
        }
    }
}

class ReplayTypesTableViewController: UITableViewController {
    
    weak var delegate: ReplayTypesTableViewControllerDelegate?
    
    var currentSeasonId: String?
    
    var allSeasons: [SeasonType: [AFLSeason]] = [.preseason: [],
                                                 .premiership: []]
    
    func setSeasons(seasons: [AFLSeason], forType type: SeasonType) {
        allSeasons[type] = seasons
        
        if isViewLoaded {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCastButton()
        
        title = "Replays"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return allSeasons.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = SeasonType(rawValue: section)!
        return allSeasons[key]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = SeasonType(rawValue: indexPath.section)!
        let season = allSeasons[key]![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath)
        cell.textLabel?.text = "\(season.year) \(season.shortName)"
        cell.detailTextLabel?.text = season.id == currentSeasonId ? "Current" : ""
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SeasonType(rawValue: section)!.title
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = SeasonType(rawValue: indexPath.section)!
        let season = allSeasons[key]![indexPath.row]
        delegate?.replayTypesTableViewController(self, didSelectSeason: season)
    }
}

protocol ReplayTypesTableViewControllerDelegate: class {
    func replayTypesTableViewController(_ replayTypesTableViewController: ReplayTypesTableViewController,
                                        didSelectSeason season: AFLSeason)
}
