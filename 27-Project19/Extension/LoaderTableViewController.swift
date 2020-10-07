//
//  LoaderTableViewController.swift
//  Extension
//
//  Created by diayan siat on 04/10/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

protocol LoaderDelegate {
    func loader(_ loader: LoaderTableViewController, didSelect scripts: String)
    
    func loader(_ loader: LoaderTableViewController, didUpdate scripts: [UserScripts])
}

class LoaderTableViewController: UITableViewController {
    
    var saveScriptsByName: [UserScripts]!
    var saveScriptsByNameKey: String!
    
    var delegate: LoaderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard saveScriptsByName != nil && saveScriptsByNameKey != nil else {
            print("Parameters not set")
            navigationController?.popViewController(animated: true)
            return
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveScriptsByName.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Script", for: indexPath)
        cell.textLabel?.text = saveScriptsByName[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.loader(self, didSelect: saveScriptsByName[indexPath.row].script)
        navigationController?.popViewController(animated: true)
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
