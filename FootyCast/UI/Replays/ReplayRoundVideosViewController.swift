//
//  ReplayRoundVideosTableViewController.swift
//  FootyCast
//
//  Created by Evan Robertson on 15/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit

class ReplayRoundVideosViewController: UITableViewController {
    
    weak var delegate: ReplayRoundVideosViewControllerDelegate?
    
    var round: AFLRound?
    
    var roundVideos: [AFLRoundVideo] = [] {
        didSet {
            if isViewLoaded { tableView.reloadData() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCastButton()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        guard let round = self.round else {
            setLoading(false)
            return
        }
        
        self.delegate?.replayRoundVideosViewController(self, refreshRound: round)
    }
    
    func setLoading(_ loading: Bool) {
        guard let refreshControl = self.refreshControl else {
            return
        }
        
        if loading && !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        } else if !loading && refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundVideos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath)
        let roundVideo = roundVideos[indexPath.row]
        
        cell.textLabel?.text = roundVideo.title
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = roundVideos[indexPath.row]
        delegate?.replayRoundVideosViewController(self, didSelectVideo: video)
    }
}

// MARK: - ReplayRoundVideosViewControllerDelegate

protocol ReplayRoundVideosViewControllerDelegate: class {
    func replayRoundVideosViewController(_ replayRoundVideosViewController: ReplayRoundVideosViewController,
                                         didSelectVideo video: AFLRoundVideo)
    
    func replayRoundVideosViewController(_ replayRoundVideosViewController: ReplayRoundVideosViewController,
                                         refreshRound round: AFLRound)
}
