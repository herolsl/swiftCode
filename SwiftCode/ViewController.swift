//
//  ViewController.swift
//  SwiftCode
//
//  Created by Ivan Liu on 2017/6/19.
//  Copyright © 2017年 Sven Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let aSlider: UISlider = UISlider.init(frame: CGRect.init(x: 20, y: 200, width: 260, height: 60))
        aSlider.backgroundColor = UIColor.blue
        self.view.addSubview(aSlider)


        let slider: VideoSlider = VideoSlider.init(frame: CGRect.init(x: 20, y: 400, width: 260, height: 60))
        slider.backgroundColor = UIColor.blue
        self.view.addSubview(slider)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

