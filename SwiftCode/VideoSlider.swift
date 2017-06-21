//
//  VideoSlider.swift
//  SwiftCode
//
//  Created by Ivan Liu on 2017/6/19.
//  Copyright © 2017年 Sven Liu. All rights reserved.
//

import UIKit

public enum VideoSliderState {
    case VideoSliderStateNone
    case VideoSliderStateBegan
    case VideoSliderStateChanging
    case VideoSliderStateEnded
    case VideoSliderStateCancelled
}

struct VSConstants {
    static let LINE_HEIGHT: CGFloat = 2
    static let BUTTON_HEIGHT: CGFloat = 16
}

open class VideoSlider: UIControl {

    open var vsValue: CGFloat = 0.0
    // 缓冲值
    open var vsLoadingValue: CGFloat = 0.0
    
    open var vsState: VideoSliderState = .VideoSliderStateNone
    open var maxProgressColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }
    open var currentProgressColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }
    open var bufferProgressColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }
    open var thumbColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open var thumbImage: UIImage?

    // 进度条背景
    private var sliderBottom: UIView!
    // 未滑动进度条
    private var sliderMid: UIView!
    // 已滑动进度条
    private var sliderAbove: UIView!
    // 滑动按钮
    private var sliderButton: UIImageView!
    // 滑动按钮图片
    private var sliderButtonBack: UIImageView!

    // 手势的第一接触点是否在滑块内
    private var isPressButton: Bool = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatStartUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func creatStartUI() {

        self.sliderBottom = UIView.init()
        self.addSubview(self.sliderBottom)

        self.sliderMid = UIView.init()
        self.addSubview(self.sliderMid)

        self.sliderAbove = UIView.init()
        self.addSubview(self.sliderAbove)

        self.sliderButtonBack = UIImageView.init()
        self.addSubview(self.sliderButtonBack)

        self.sliderButton = UIImageView.init()
        self.sliderButton.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        self.sliderButton.layer.shadowRadius = 3
        self.sliderButton.layer.shadowOpacity = 0.4
        self.sliderButton.layer.shadowColor = UIColor.black.cgColor
        self.sliderButtonBack.addSubview(self.sliderButton)

        self.addValueObserve()
    }

    // MARK: -
    private func addValueObserve() {
        self.addObserver(self, forKeyPath: "vsValue", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "vsLoadingValue", options: .new, context: nil)
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "vsValue" || keyPath == "vsLoadingValue" {

            if self.vsValue > 1.0 {

                self.vsValue = 1.0
            } else if self.vsValue < 0.0 {

                self.vsValue = 0.0
            }

            if self.vsLoadingValue > 1.0 {

                self.vsLoadingValue = 1.0
            } else if self.vsLoadingValue < 0.0 {

                self.vsLoadingValue = 0.0
            }

            self.setNeedsLayout()
        }
    }

    // MARK: - layoutSubviews
    override open func layoutSubviews() {

        super.layoutSubviews()

        if self.frame.height <= 30.0 {
            self.frame = CGRect.init(origin: self.frame.origin, size: CGSize.init(width: self.frame.width, height: 30.0))
        }

        self.sliderBottom.frame = CGRect.init(x: self.vsValue*self.frame.width,
                                              y: self.frame.height/2-VSConstants.LINE_HEIGHT,
                                              width: (1-self.vsValue)*self.frame.width,
                                              height: VSConstants.LINE_HEIGHT)
        self.sliderBottom.backgroundColor = self.maxProgressColor ?? UIColor.lightGray
        self.sliderBottom.layer.cornerRadius = 2.0

        var midWidth: CGFloat = 0
        if ((self.vsLoadingValue-self.vsValue)*self.frame.width-VSConstants.BUTTON_HEIGHT/2 > 0) {
            midWidth = (self.vsLoadingValue-self.vsValue)*self.frame.width-VSConstants.BUTTON_HEIGHT/2;
        }
        self.sliderMid.frame = CGRect.init(x: self.vsValue*self.frame.width+VSConstants.BUTTON_HEIGHT/2,
                                           y: self.frame.height/2-VSConstants.LINE_HEIGHT,
                                           width: midWidth,
                                           height: VSConstants.LINE_HEIGHT)
        self.sliderMid.backgroundColor = self.bufferProgressColor ?? UIColor.darkGray

        self.sliderAbove.frame = CGRect.init(x: 0.0,
                                             y: self.frame.height/2-VSConstants.LINE_HEIGHT,
                                             width: self.vsValue*self.frame.width,
                                             height: VSConstants.LINE_HEIGHT)
        self.sliderAbove.backgroundColor = self.currentProgressColor ?? UIColor.white
        self.sliderAbove.layer.cornerRadius = VSConstants.LINE_HEIGHT/2;

        var btnCenterX: CGFloat = 0
        if (self.vsValue*self.frame.width-VSConstants.BUTTON_HEIGHT/2 < 0) {
            btnCenterX = VSConstants.BUTTON_HEIGHT/2;
        } else if ((self.vsValue*self.frame.width+VSConstants.BUTTON_HEIGHT/2) > self.frame.width) {
            btnCenterX = self.frame.width-VSConstants.BUTTON_HEIGHT/2;
        } else {
            btnCenterX = self.vsValue*self.frame.width;
        }

        self.sliderButtonBack.frame = CGRect.init(x: 0,
                                                  y: 0,
                                                  width: 50,
                                                  height: 40)
        self.sliderButtonBack.center = CGPoint.init(x: btnCenterX, y: self.frame.height/2)
        self.sliderButtonBack.backgroundColor = UIColor.clear
//        self.sliderButtonBack.layer.cornerRadius = VSConstants.BUTTON_HEIGHT/2

        self.sliderButton.frame = CGRect.init(x: 0,
                                              y: 0,
                                              width: VSConstants.BUTTON_HEIGHT,
                                              height: VSConstants.BUTTON_HEIGHT)
        self.sliderButton.center = CGPoint.init(x: self.sliderButtonBack.frame.width/2,
                                                y: self.sliderButtonBack.frame.height/2)
        self.sliderButton.backgroundColor = self.thumbColor ?? UIColor.white
        self.sliderButton.layer.cornerRadius = VSConstants.BUTTON_HEIGHT/2

    }

    // MARK: - super methods
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

        self.vsState = .VideoSliderStateBegan
        let startPoint: CGPoint = touch.location(in: self)
        self.isPressButton = self.sliderButtonBack.frame.contains(startPoint)
        self.sendActions(for: .valueChanged)
        return true
    }

    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

        self.vsState = .VideoSliderStateChanging
        if self.isPressButton {
            self.setValue(touch.location(in: self).x/self.frame.width, forKey: "vsValue")
//            self.vsValue = touch.location(in: self).x/self.frame.width
            self.sendActions(for: .valueChanged)
        }
        return true
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {

        self.vsState = .VideoSliderStateEnded
        self.isPressButton = false
        self.sendActions(for: .valueChanged)
    }

    open override func cancelTracking(with event: UIEvent?) {

        self.vsState = .VideoSliderStateEnded
        self.isPressButton = false
        self.sendActions(for: .valueChanged)
    }

    // MARK: - 屏蔽父视图滑动操作
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) {
            return false
        }
        return true
    }

    // MARK: - dealloc
    deinit {

        self.removeObserver(self, forKeyPath: "vsValue")
        self.removeObserver(self, forKeyPath: "vsLoadingValue")
    }


}


    
    
