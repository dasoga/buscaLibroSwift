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
    @IBOutlet var responseTextView: UITextView!

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
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                //print("Texto \(texto!)")
                dispatch_sync(dispatch_get_main_queue()){
                    self.showData(texto!)
                }
                
            }
            dt.resume()
        }else{
            let alert = UIAlertController(title: "Error", message: "Error, por favor intenta nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
        
    }
    
    func showData(response:NSString){
        //print("response \(response)")
        if response != "{}"{
            responseTextView.text = "\(response)"
        }else{
            let alert = UIAlertController(title: "No encontrado", message: "Error, no se encontro libro, por favor intenta nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
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

