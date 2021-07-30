import UIKit

public final class ClassicSparkTrajectoryFactory: ClassicSparkTrajectoryFactoryProtocol {

    public init() {}

    /// 如果需要调轨迹，可以去 https://www.desmos.com/calculator/epunzldltu?lang=zh-CN 生成抛物线的四个点
    /// 另外，因为在 iOS 系统中，越接近屏幕顶部 y 轴的值越小，所以 y 轴的值需要翻转一下
    private lazy var topRight: [SparkTrajectory] = {
        return [
            CubicBezierTrajectory(0.00, 0.00, 0.31, -0.56, 0.84, -0.49, 0.99, -0.39),
            CubicBezierTrajectory(0.00, 0.00, 0.31, -0.56, 0.62, -0.69, 0.88, -0.49),
            CubicBezierTrajectory(0.00, 0.00, 0.10, -0.64, 0.44, -0.73, 0.66, -0.60),
            CubicBezierTrajectory(0.00, 0.00, 0.19, -0.56, 0.41, -0.73, 0.65, -0.65),
        ]
    }()

    private lazy var bottomRight: [SparkTrajectory] = {
        return [
            CubicBezierTrajectory(0.00, 0.00, 0.42, -0.01, 0.68, 0.11, 0.87, 0.44),
            CubicBezierTrajectory(0.00, 0.00, 0.35, 0.00, 0.55, 0.12, 0.62, 0.45),
            CubicBezierTrajectory(0.00, 0.00, 0.21, 0.05, 0.31, 0.19, 0.32, 0.45),
            CubicBezierTrajectory(0.00, 0.00, 0.18, 0.00, 0.31, 0.11, 0.35, 0.25),
        ]
    }()

    public func randomTopRight() -> SparkTrajectory {
        return self.topRight[Int(arc4random_uniform(UInt32(self.topRight.count)))]
    }

    public func randomBottomRight() -> SparkTrajectory {
        return self.bottomRight[Int(arc4random_uniform(UInt32(self.bottomRight.count)))]
    }
}
