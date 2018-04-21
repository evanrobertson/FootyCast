//
//  LiveVideosTableViewController.swift
//  FootyCast
//
//  Created by Evan Robertson on 25/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit

class LiveVideosTableViewController: UITableViewController {
    
    var lastLoad: Date = Date()
    var loading: Bool = false
    weak var delegate: LiveVideosTableViewControllerDelegate?
    var liveVideos: [AFLLiveVideo] = [] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Live Videos"
        
        addCastButton()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(reload(sender:)), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !loading && Date().timeIntervalSince(lastLoad) > (10 * 60) {
            delegate?.reloadLiveVideosTableViewController(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Loading
    
    func setLoading(_ loading: Bool) {
        self.loading = loading
        if loading {
            self.refreshControl?.beginRefreshing()
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - IBOutlets
    
    @objc func reload(sender: UIRefreshControl) {
        delegate?.reloadLiveVideosTableViewController(self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveVideos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveCell", for: indexPath)
        
        let video = liveVideos[indexPath.row]
        
        cell.textLabel?.text = video.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let liveVideo = liveVideos[indexPath.row]
        delegate?.liveVideosTableViewController(self, didSelectLiveVideo: liveVideo)
    }
}

protocol LiveVideosTableViewControllerDelegate: class {
    func liveVideosTableViewController(
        _ liveVideosTableViewController: LiveVideosTableViewController,
        didSelectLiveVideo liveVideo: AFLLiveVideo)
    
    func reloadLiveVideosTableViewController(
        _ liveVideosTableViewController: LiveVideosTableViewController)
}
