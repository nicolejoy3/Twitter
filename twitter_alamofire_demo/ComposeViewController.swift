//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Chavane Minto on 12/20/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ComposeViewControllerDelegate: class {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController {
    
    weak var delegate: ComposeViewControllerDelegate?
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var tweetText: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var tweetButton: UIButton!
    
    let user = User.current!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.masksToBounds = true;
        profileImage.layer.cornerRadius = 30;
        profileImage.af_setImage(withURL: URL(string: user.imageURL)!)
        
        cancelButton.layer.masksToBounds = true;
        tweetButton.layer.masksToBounds = true;
        cancelButton.layer.cornerRadius = 15;
        tweetButton.layer.cornerRadius = 15;
        
        // Handle showing and hiding the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShows), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHides), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
        
    }
    
    @objc func handleKeyboardShows(notification: NSNotification) {
        
        if (tweetText.text == "") || (tweetText.text == "What's Happening?") {
            tweetText.text = ""
        }
        
    }
    
    @objc func handleKeyboardHides(notification: NSNotification) {
        
        if tweetText.text == "" {
            tweetText.text = "What's Happening?"
        }
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        tweetText.text = "What's Happening?";
        
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func onTweet(_ sender: Any) {
        APIManager.shared.composeTweet(with: tweetText.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
