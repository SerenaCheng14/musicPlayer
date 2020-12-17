//
//  TableViewController.swift
//  iTuesPreview
//
//  Created by Serena on 2020/12/15.
//

import UIKit

class TableViewController: UITableViewController {
    
    var items = [StoreItem]()
    let searchtext: String
    
    init?(coder: NSCoder, searchtext: String) {
        self.searchtext = searchtext
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
          fatalError()
    }
    

    func fetchItems(searchItem: String) {
        if let urlStr = "https://itunes.apple.com/search?term=\(searchItem)&media=music".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let searchResonse = try decoder.decode(SearchResonse.self, from: data)
                        if searchResonse.resultCount == 0{
                            print("NO response")
//                          showAlert
                            let alert = UIAlertController(title: "Wrong Artist Name", message: "We couldn't find the artist you're looking for. Please go back and try again, thanks.", preferredStyle: .alert)
                            let action = UIAlertAction(title: "okey-dokey", style: .default) { (UIAlertAction) in
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                        self.items = searchResonse.results
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    catch {
                        print("error",error)
                    }
                }
            }.resume()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 120
        tableView.estimatedRowHeight = 0
        
        fetchItems(searchItem: searchtext)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)", for: indexPath) as! TableViewCell
        
        let item = items[indexPath.row]
        cell.nameLabel.text = item.trackName
        cell.collectionLabel.text = item.collectionCensoredName
//        cell.priceLabel.text = item.trackPrice?.description
        if let price = item.trackPrice  {
            let Price = String(price)
            cell.priceLabel.text = "$ \(Price)"
        } else{
            cell.priceLabel.text = "free"
        }

        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.cornerRadius = 30
        
        URLSession.shared.dataTask(with: item.artworkUrl100) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data)
                }
            }
        }.resume()
        

        return cell
    }
    
    
    @IBSegueAction func showDetail(_ coder: NSCoder) -> PlayViewController? {
        
        if let row = tableView.indexPathForSelectedRow?.row {
            return PlayViewController(coder: coder, item: items[row])
        }else{
            return nil
        }
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
