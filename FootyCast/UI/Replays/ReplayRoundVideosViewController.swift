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
    
    var roundVideos: [AFLRoundVideo] = [] {
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

protocol ReplayRoundVideosViewControllerDelegate: class {
    func replayRoundVideosViewController(_ replayRoundVideosViewController: ReplayRoundVideosViewController,
                                         didSelectVideo video: AFLRoundVideo)
}
