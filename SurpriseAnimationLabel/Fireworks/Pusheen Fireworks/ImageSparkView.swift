import UIKit

/// 带图片的 SparkView,我们可以自定义各种各样的 SparkView，图片的，绘制的...
public final class ImageSparkView: SparkView {

    public init(image: UIImage, size: CGSize) {
        super.init(frame: CGRect(origin: .zero, size: size))

        let imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)

        imageView.image = image
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
