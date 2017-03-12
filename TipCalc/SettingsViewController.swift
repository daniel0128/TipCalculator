//
//  SettingsViewController.swift
//  TipCalc
//
//  Created by Daniel ZHANG on 3/9/17.
//  Copyright © 2017 Daniel ZHANG. All rights reserved.
//

import UIKit

let CELL_ID = "Cell"



class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet var settingsTableView: UITableView!
	
	let settings = NSUserDefaults.standardUserDefaults()
	
	var shareInt:Int = 1
	
	var rateArray:[Double] = [0.15, 0.20, 0.25]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		settingsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
		
		settingsTableView.dataSource = self
		settingsTableView.delegate = self
		
		self.getSettings()
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillDisappear(animated: Bool) {
		
		self.saveSettings()
		
		settings.setInteger(shareInt, forKey: "Share_Num")
		
		settings.setObject(rateArray, forKey: "Rate_Opt")
		
		settings.synchronize()
		
		super.viewWillDisappear(animated)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var rowCount = 0
		if section == 0 {
			rowCount = 3
		}
		if section == 1 {
			rowCount = 1
		}
		return rowCount
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let cell:UITableViewCell = self.settingsTableView.cellForRowAtIndexPath(indexPath)!
		
		let txtF:UITextField = cell.contentView.subviews[1] as! UITextField
		
		txtF.becomeFirstResponder()
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell:UITableViewCell = self.settingsTableView.dequeueReusableCellWithIdentifier(CELL_ID)!
		
		let detailTxtField: UITextField = UITextField(frame: CGRect(x: 320, y: 10, width: 90, height: 30 ))
		detailTxtField.textAlignment = NSTextAlignment.Right
		detailTxtField.placeholder = "%"
		detailTxtField.keyboardType = UIKeyboardType.NumberPad
		
		var cellStr = ""
		
		if(indexPath.section == 0){
			var detailStr = ""
			
			switch indexPath.row {
			case 0:
				cellStr = "Min Rate"
				detailStr = String.init(format: "%.0f", rateArray[0]*100)
				detailTxtField.text? = detailStr
				break
			case 1:
				cellStr = "Mid Rate"
				detailStr = String.init(format: "%.0f", rateArray[1]*100)
				detailTxtField.text? = detailStr
				break
			case 2:
				detailStr = String.init(format: "%.0f", rateArray[2]*100)
				detailTxtField.text? = detailStr
				cellStr = "Max Rate"
				break
			default:
				cellStr = ""
			}
		}else if(indexPath.section == 1){
			cellStr = "Number of Share"
			detailTxtField.placeholder = "Share"
			detailTxtField.text? = "\(self.shareInt)"
		}
		
		cell.textLabel?.text = cellStr
		cell.contentView.addSubview(detailTxtField)
		
		return cell
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var title:String = ""
		if section == 0{
			title = "Rate"
		}else if section == 1{
			title = "Number of Share"
		}
		return title
	}
	
	func getSettings() {
		shareInt = settings.integerForKey("Share_Num")
		
		rateArray = settings.arrayForKey("Rate_Opt") as! [Double]
	}
	
	func saveSettings(){
		var indexPath: NSIndexPath
		var cell:UITableViewCell
		var txtField: UITextField
		
		for index in 0..<3{
			indexPath = NSIndexPath(forRow: index, inSection: 0)
			cell = self.settingsTableView.cellForRowAtIndexPath(indexPath)!
			txtField = cell.contentView.subviews[1] as! UITextField
			var rate = Double(txtField.text!) ?? -1.0
			rate /= 100
			if(rate>0.000000001){
				rateArray[indexPath.row] = rate
			}
		}
		
		indexPath = NSIndexPath(forRow: 0, inSection: 1)
		
		cell = self.settingsTableView.cellForRowAtIndexPath(indexPath)!
		txtField = cell.contentView.subviews[1] as! UITextField
		shareInt = Int( txtField.text! ) ?? 1
		
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
