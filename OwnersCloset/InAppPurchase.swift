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
    
    var product_id: NSString?;
    
    override func viewDidLoad() {
        product_id = "neva3Con";
        super.viewDidLoad()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
        //set up top label
        var topText = "Thank you for using cabtrack. I hope you and your guests were able to take advantage of its convenience."
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        var attString = NSAttributedString(string: topText, attributes: [NSParagraphStyleAttributeName: paragraphStyle, NSBaselineOffsetAttributeName: NSNumber(float: 0)])
        self.topLabel.attributedText = attString
        self.topLabel.numberOfLines = 0
        
        // set up bottom label
        
        var bottomText = "As an owner your 3 week trial period has ended. This app is free for guests to use but in order to keep your places within the app please click the purchase button below."
        var paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.alignment = NSTextAlignment.Justified
        var attString1 = NSAttributedString(string: bottomText, attributes: [NSParagraphStyleAttributeName: paragraphStyle1, NSBaselineOffsetAttributeName: NSNumber(float: 0)])
        self.bottomLabel.attributedText = attString1
        self.bottomLabel.numberOfLines = 0

        
    }
    @IBAction func cancelBtnPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func purchaseAppBtnPressed(sender: UIButton) {
        
       println("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            var productID:NSSet = NSSet(object: self.product_id!);
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
                    self.dismissViewControllerAnimated(true, completion: nil)
                    break;
                case .Failed:
                    println("Purchased Failed: \(transaction.error.debugDescription)");
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
