//
//  LiveVideosTableViewController.swift
//  FootyCast
//
//  Created by Evan Robertson on 25/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit

class LiveVideosTableViewController: UITableViewController {
    
    var loading: Bool = false
    weak var delegate: LiveVideosTableViewControllerDelegate?
    var liveVideos: [AFLLiveVideo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Live Videos"
        
        addCastButton()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Loading
    
    func setLoading(_ loading: Bool) {
        self.loading = loading
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
        delegate?.LiveVideosTableViewController(self, didSelectLiveVideo: liveVideo)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol LiveVideosTableViewControllerDelegate: class {
    func LiveVideosTableViewController(
        _ liveVideosTableViewController: LiveVideosTableViewController,
        didSelectLiveVideo liveVideo: AFLLiveVideo)
}
