//
//  ChatsTableViewController.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-11.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class ChatsTableViewController: UITableViewController {

    @IBOutlet var chatTableView: UITableView!
    var chats : [Chat] = [Chat]()
    let chatService = ChatService()
    var selectedChatId = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        getUserChats()
    }
    
    func getUserChats() {
        chatService.getUserChats { (chats, error) in
            if chats != nil {
                self.chats = chats!
                self.reloadTableView()
            }
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView!.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChatTableViewCell
        let image = UIImage(named: "swift")
        cell?.chatImage.image = image
        cell?.chatNameLabel.text = String(chats[indexPath.row].name ?? "Not defined")
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedChat = chats[indexPath.row].id else {return}
        selectedChatId = selectedChat
        performSegue(withIdentifier: "toChat", sender: self)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChat" {
            let destination = segue.destination as? ChatViewController
            destination?.chatID = selectedChatId
        }
    }
    

}
