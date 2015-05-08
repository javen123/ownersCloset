//
//  InAppPurchase.swift
//  CabTrack2.1
//
//  Created by Jim Aven on 4/22/15.
//  Copyright (c) 2015 Jim Aven. All rights reserved.
//

import UIKit

class InAppPurchase: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
   
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    
    var topText:String!
    
    var product_id = "owncloset299"
    var bottomText:String!
    
    override func viewDidLoad() {
        
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        super.viewDidLoad()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
        //set up top label
        
       
        self.topText = "Thank you for using Owners Closet. I hope you and/or your guests were able to take advantage of its convenience."
        
        if needToPurchase == true {
            
            self.bottomText = "As an owner your 3 week trial period has ended. This app is free for guests to use but in order to keep your places within the app please click the purchase button below."
        }
        
        else {
            self.bottomText = "If you would like to discontinue receiving ads and/or would just like to contribute to helping make this app even better then click the purchase button below.  Also, if you have any enhancement ideas please send us an email at ownerscloset@appsneva.com"
        }
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        var attString = NSAttributedString(string: topText, attributes: [NSParagraphStyleAttributeName: paragraphStyle, NSBaselineOffsetAttributeName: NSNumber(float: 0)])
        self.topLabel.attributedText = attString
        self.topLabel.numberOfLines = 0
        
        // set up bottom label
        
       
        var paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.alignment = NSTextAlignment.Justified
        var attString1 = NSAttributedString(string: bottomText, attributes: [NSParagraphStyleAttributeName: paragraphStyle1, NSBaselineOffsetAttributeName: NSNumber(float: 0)])
        self.bottomLabel.attributedText = attString1
        self.bottomLabel.numberOfLines = 0

        
    }
  
    
    @IBAction func purchaseAppBtnPressed(sender: UIButton) {
        
       println("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            var productID:NSSet = NSSet(object: self.product_id);
            var productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>);
            productsRequest.delegate = self;
            productsRequest.start();
            println("Fetching Products");
        }
        else{
            println("can't make purchases");
        }
    }

    
    // Helper Methods
    
    func buyProduct(product: SKProduct){
        println("Sending the Payment Request to Apple");
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
        
    }
    
    
    // Delegate Methods for IAP
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        println("got the request from Apple")
        var count : Int = response.products.count
        if (count>0) {
            var validProducts = response.products
            var validProduct: SKProduct = response.products[0] as! SKProduct
            if (validProduct.productIdentifier == self.product_id) {
                println(validProduct.localizedTitle)
                println(validProduct.localizedDescription)
                println(validProduct.price)
                buyProduct(validProduct);
            } else {
                println(validProduct.productIdentifier)
            }
        } else {
            println("nothing")
        }
    }
    
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
        println("La vaina fallo");
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)    {
        println("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    println("Product Purchased");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    needToPurchase = false
                    purchased = 1
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(purchased, forKey: "PURCHASED")
                    
                    ads = false
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewControllerWithIdentifier("entry") as! UIViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                    break;
                case .Failed:
                    println("Purchased Failed: \(transaction.error.debugDescription)")
                    
                    var alert = UIAlertController(title: "Failed", message: transaction.error.debugDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                    // case .Restored:
                    //[self restoreTransaction:transaction];
                default:
                    break;
                }
            }
        }
    }
}
