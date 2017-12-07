///// Copyright (c) 2017 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import ChameleonFramework

class ViewController: UIViewController {
  
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var imageView2: UIImageView!
  @IBOutlet private weak var imageView3: UIImageView!
  @IBOutlet private weak var shadeStepper: UIStepper!
  
  private let imagePainter = ImagePainter()
  
  private var selectedColor = UIColor.white {
    didSet {
      paintImages()
      updateAppTheme()
    }
  }
  
  private var selectedColorWithShade: UIColor? {
    let shadePercentage = CGFloat(abs(stepperValue / 100))
    if stepperValue >= 0 {
      return selectedColor.lighten(byPercentage: shadePercentage)
    } else {
      return selectedColor.darken(byPercentage: shadePercentage)
    }
  }
  
  private var stepperValue = 0.0 {
    didSet {
      paintImages()
    }
  }
  
  private var selectedColorScheme = ColorScheme.analogous {
    didSet {
      paintImages()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    paintImages()
    navigationController?.navigationBar.isTranslucent = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    shadeStepper.value = 0
    stepperValue = 0
    super.viewWillAppear(animated)
  }
  
  @IBAction private func shadeStepperChanged(_ sender: UIStepper) {
    stepperValue = sender.value
  }
  
  @IBAction private func colorSchemeSelectionChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      selectedColorScheme = .analogous
    case 1:
      selectedColorScheme = .complementary
    case 2:
      selectedColorScheme = .triadic
    default:
      return
    }
  }
  
  @IBAction private func showColorPicker(_ sender: Any) {
    
    let viewController = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(withIdentifier: "ColorPickerIdentifier")
    
    guard let colorPicker = viewController as? ColorPickerViewController else {
      return
    }
    
    colorPicker.onColorPicked { [weak self] in
      self?.selectedColor = $0
    }
    
    colorPicker.view.backgroundColor = UIColor(gradientStyle: .topToBottom,
                                   withFrame: colorPicker.view.frame,
                                   andColors: [.flatWhite, .flatWhite, selectedColor])
    
    navigationController?.pushViewController(colorPicker, animated: true)
  }
  
  private func paintImages() {
    
    let imageColor = selectedColorWithShade ?? selectedColor
    let colorsFromScheme = ColorSchemeOf(
      selectedColorScheme, color: imageColor, isFlatScheme: false)
    
    imageView.image = imagePainter.paint(image: UIImage(named: "sofa"),
                                         color: colorsFromScheme[1])
    imageView2.image = imagePainter.paint(image: UIImage(named: "armchair"),
                                          color: colorsFromScheme[2])
    imageView3.image = imagePainter.paint(image: UIImage(named: "bookshelf"),
                                          color: colorsFromScheme[3])
  }
  
  private func updateAppTheme() {
    Chameleon.setGlobalThemeUsingPrimaryColor(selectedColor, with: .contrast)
    
    navigationController?.navigationBar.barTintColor = selectedColor
    
    let contrastingColor = UIColor(contrastingBlackOrWhiteColorOn:selectedColor, isFlat: true)
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : contrastingColor]
  }
  
}
