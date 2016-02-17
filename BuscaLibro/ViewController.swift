//
//  ViewController.swift
//  BuscaLibro
//
//  Created by Dante Solorio on 2/9/16.
//  Copyright © 2016 Dante Solorio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var isbTextField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var imageBook: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isbTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getBookDataFunction(isbn: String){
        let urlBase = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let url = NSURL(string: urlBase + isbn)
        //print("peticion \(url!)")
        let session = NSURLSession.sharedSession()
        if url != nil{
            let dt = session.dataTaskWithURL(url!) { (datos, response, error) -> Void in
                //let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                
                dispatch_sync(dispatch_get_main_queue()){
                    self.showData(datos!)
                }
                
            }
            dt.resume()
        }else{
            let alert = UIAlertController(title: "Error", message: "Error, por favor intenta nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
        
    }
    
    func showData(response:NSData){
        //print("response \(response)")
        self.authorLabel.text = ""
        if response != ""{
            //responseTextView.text = "\(response)"
            //print("respose \(response)")
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.MutableLeaves)
                let objectDic = json as! NSDictionary
                let level = "ISBN:\(isbTextField.text!)"
                //let dic2 = objectDic[level] as! NSDictionary
                
                if let exist = objectDic[level]{
                    // Check Title
                    if let title = exist["title"] as? String{
                        print("Title \(title)")
                        self.titleLabel.text = title
                    }
                    // Check Author
                    if let authors = exist["authors"] as? NSArray{
                        for author in authors{
                            let name  = author["name"] as? String
                            self.authorLabel.text = self.authorLabel.text! + "\(name!)\n"
                        }
                    }
                    
                    
                    if let cover = exist["cover"] as? NSDictionary{
                        print("cover \(cover)")
                        getBookCoverFromURL(cover["large"] as! String)
                    }else{
                        self.imageBook.image = nil
                    }
                }else{
                    showAlertErrorMessage()
                }
                
//                if let title = objectDic[level]!["title"]  {
//                    if let
//                    self.titleLabel.text = title as? String
//                    if let authorDic = objectDic[level]?["authors"] {
//                        
//                        for author in authorDic as! NSArray{
//                            let authorS = author["name"] as! String
//                            self.authorLabel.text = self.authorLabel.text! + "\(authorS)\n"
//                            
//                        }
//                    }
                

                    
                    
//                    if let coverURL = objectDic[level]!["cover"]{
//                        print("cover \(coverURL!)")
//                        getBookCoverFromURL(coverURL as! String)
//                    }
                    
//                }else{
//                    self.showAlertErrorMessage()
//                }
            }catch{
                
            }
            
        }else{
            showAlertErrorMessage()
        }
    }
    
    func getBookCoverFromURL(urlString: String){
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        if url != nil{
            let dt = session.dataTaskWithURL(url!) { (datos, response, error) -> Void in
                //let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                dispatch_sync(dispatch_get_main_queue()){
                    self.imageBook.image = UIImage(data: datos!)
                }
                
            }
            dt.resume()
        }else{
            print("no image")
        }
    }
    
    func showAlertErrorMessage(){
        let alert = UIAlertController(title: "No encontrado", message: "Error, no se encontro libro, por favor intenta nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text! != ""{
            getBookDataFunction(textField.text!)
        }else{
            let alert = UIAlertController(title: "Error", message: "Por favor ingresa un ISBN para busqueda.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
        textField.resignFirstResponder()
        return true
    }
    
    
    

}

