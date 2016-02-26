//
//  DetailBookViewController.swift
//  BuscaLibro
//
//  Created by Dante Solorio on 2/26/16.
//  Copyright © 2016 Dante Solorio. All rights reserved.
//

import UIKit
import CoreData

class DetailBookViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var imageBook: UIImageView!
    
    
    var bookIsbn:String = ""
    var bookTitle:String = ""
    var bookAuthors:String = ""
    var bookImage:NSData!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = bookTitle
        self.authorLabel.text = bookAuthors
        if bookImage != nil{
            self.imageBook.image = UIImage(data: bookImage)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
