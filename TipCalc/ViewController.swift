//
//  ViewController.swift
//  TipCalc
//
//  Created by Daniel ZHANG on 3/8/17.
//  Copyright © 2017 Daniel ZHANG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	@IBOutlet var containerView: UIView!
	@IBOutlet weak var billField: UITextField!
	@IBOutlet weak var tipLabel: UILabel!
	@IBOutlet weak var totalLabel: UILabel!
	@IBOutlet weak var tipControl: UISegmentedControl!
	@IBOutlet weak var shareLabel: UILabel!
	@IBOutlet weak var numShareLabel: UILabel!
	
	let defaults = NSUserDefaults.standardUserDefaults()
	
//	var astr:String = ""
	
	var tipValStrings:[String] = []
	
	var tipValues:[Double] = []
	
	var shareInt: Int = 1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.billField.becomeFirstResponder()
		self.billField.placeholder="$"
		
		self.getSettings()
		
		self.setValues()
		
		self.calculateTip(self)

	}
	
	func setValues(){
		
		billField.text = defaults.stringForKey("Bill")
		tipValues = defaults.arrayForKey("Rate_Opt") as! [Double]
		shareInt = defaults.integerForKey("Share_Num")
		self.numShareLabel.text = "\(shareInt)"
		
		tipValStrings = []
		for i in 0..<3 {
			
			tipValStrings.append(String.init(format: "%.0f%%",tipValues[i]*100 ))
			
			tipControl.setTitle(tipValStrings[i], forSegmentAtIndex: i)
			
		}
		
		
	}
	
	func getSettings(){
		
		if((defaults.arrayForKey("Rate_Opt")) == nil){
			defaults.setObject([0.15,0.20,0.25], forKey: "Rate_Opt")
			defaults.synchronize()
		}
		
		if( (defaults.integerForKey("Share_Num")) == 0 ){
			defaults.setInteger(1, forKey: "Share_Num")
			defaults.synchronize()
		}
		
		if( defaults.stringForKey("Bill") == nil){
			defaults.setObject("", forKey: "Bill")
			defaults.synchronize()
		}
		
	}
	
	// receiveMemoryWarning
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillDisappear(animated: Bool) {
		
		defaults.setObject(billField.text, forKey: "Bill")
		defaults.setObject(self.tipValues, forKey: "Rate_Opt")
		defaults.setInteger(self.shareInt, forKey: "Share_Num")
		defaults.synchronize()
		
		super.viewWillDisappear(animated)
	}
	
	override func viewWillAppear(animated: Bool) {
		self.getSettings()
		self.setValues()
		
		self.calculateTip(self)
		super.viewWillAppear(animated)
	}
	
	@IBAction func onTap(sender: AnyObject){
		
		view.endEditing(true)
	}

	@IBAction func calculateTip(sender: AnyObject) {
		
		if billField.text == nil || billField.text == ""{
//			containerView.hidden = true
			UIView.animateWithDuration(0.4, animations: {
				self.containerView.alpha = 0
			})
		}else{
//			containerView.hidden = false
			UIView.animateWithDuration(0.4, animations: {
				self.containerView.alpha = 1
			})
		}
		
		
		let tipPercentage = tipValues
		
		let bill = Double( billField.text! ) ?? 0
		let tip = bill*tipPercentage[tipControl.selectedSegmentIndex]
		let total = tip+bill
		
		if(shareInt == 0){shareInt = 1}
		
		let every = total/Double(shareInt)
		
		tipLabel.text = String.init(format: "$%.2f", tip)
		totalLabel.text = String.init(format: "$%.2f", total)
		shareLabel.text = String.init(format: "$%.2f", every)
		
		
	}
}

