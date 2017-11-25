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

class ViewController: UIViewController {
  
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var imageView2: UIImageView!
  @IBOutlet private weak var imageView3: UIImageView!
  private let imagePainter = ImagePainter()
  
  private var selectedColor = UIColor.white {
    didSet {
      updateColors()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateColors()
  }
  
  @IBAction private func shadeStepperChanged(_ sender: UIStepper) {
  }
  
  @IBAction private func colorSchemeSelectionChanged(_ sender: UISegmentedControl) {
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
    
    navigationController?.pushViewController(colorPicker, animated: true)
  }
  
  private func updateColors() {

      imageView2.image = imagePainter.paint(image: #imageLiteral(resourceName: "sofa"), color: selectedColor)
      imageView3.image = imagePainter.paint(image: #imageLiteral(resourceName: "bookshelf"), color: selectedColor)
      imageView.image = imagePainter.paint(image: #imageLiteral(resourceName: "armchair"), color: selectedColor)
  }
  
}
