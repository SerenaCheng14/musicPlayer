//
//  PlayViewController.swift
//  iTuesPreview
//
//  Created by Serena on 2020/12/15.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController {

    @IBOutlet weak var playingImage: UIImageView!
    @IBOutlet weak var pressedImage: UIButton!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    
    
    let item: StoreItem
    var player: AVPlayer?
    
    init?(coder: NSCoder, item: StoreItem) {
        self.item = item
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songLabel.text = item.trackName
        collectionLabel.text = item.collectionCensoredName
        player = AVPlayer(url: item.previewUrl)
        
        pressedImage.setImage(UIImage(named: "playImage"), for: .normal)
        
        URLSession.shared.dataTask(with: item.artworkUrl100) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.playingImage.image = UIImage(data: data)
                }
            }
        }.resume()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func pressedB(_ sender: UIButton) {
        switch player?.rate {
        case 0:
            player?.play()
            sender.setImage(UIImage(named: "pauseImage") , for: .normal)
        case 1:
            player?.pause()
            sender.setImage(UIImage(named: "playImage"), for: .normal)
        default:
            break
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
