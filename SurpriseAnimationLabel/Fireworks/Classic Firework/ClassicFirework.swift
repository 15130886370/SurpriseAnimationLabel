import UIKit

public class ClassicFirework: Firework {

    /**
     x     |     x
        x  |   x
           |
     ---------------
         x |  x
       x   |
           |     x
     **/

    private struct FlipOptions: OptionSet {

        let rawValue: Int

        static let horizontally = FlipOptions(rawValue: 1 << 0)
        static let vertically = FlipOptions(rawValue: 1 << 1)
    }

    private enum Quarter {

        case topRight
        case bottomRight
        case bottomLeft
        case topLeft
    }

    public var origin: CGPoint
    public var scale: CGFloat
    public var sparkSize: CGSize

    /// 粒子发射器的大小
    public var maxChangeValue: Int {
        return 35
    }

    public var trajectoryFactory: SparkTrajectoryFactory {
        return ClassicSparkTrajectoryFactory()
    }

    public var classicTrajectoryFactory: ClassicSparkTrajectoryFactoryProtocol {
        return self.trajectoryFactory as! ClassicSparkTrajectoryFactoryProtocol
    }

    public var sparkViewFactory: SparkViewFactory {
        return PusheenSparkViewFactory()
    }

    private var quarters = [Quarter]()

    public init(origin: CGPoint, sparkSize: CGSize, scale: CGFloat) {
        self.origin = origin
        self.scale = scale
        self.sparkSize = sparkSize
        self.quarters = self.shuffledQuarters()
    }

    public func sparkViewFactoryData(at index: Int) -> SparkViewFactoryData {
        return DefaultSparkViewFactoryData(size: self.sparkSize, index: index)
    }

    public func sparkView(at index: Int) -> SparkView {
        return self.sparkViewFactory.create(with: self.sparkViewFactoryData(at: index))
    }

    public func trajectory(at index: Int) -> SparkTrajectory {
        let quarter = self.quarters[index]
        let flipOptions = self.flipOptions(for: quarter)
        
        /**
            注意！如果需要粒子从不同的发射点喷出，可以在这里计算随机出发点，使喷射更加随机，更加分散
            我们这里需要粒子在一条直线上爆炸，如果 origin 不加 changeVector， 那就是在原点爆炸
         
             *     *          *
                *   *      *
                 *   *   *
                   * * *
                -----------
         */
        let changeVector = self.randomChangeVector(flipOptions: flipOptions, maxValue: self.maxChangeValue)
        let sparkOrigin = self.origin.adding(vector: changeVector)
        return self.randomTrajectory(flipOptions: flipOptions).scale(by: self.scale).shift(to: sparkOrigin)
    }

    private func flipOptions(`for` quarter: Quarter) -> FlipOptions {
        var flipOptions: FlipOptions = []
        if quarter == .bottomLeft || quarter == .topLeft {
            flipOptions.insert(.horizontally)
        }

        if quarter == .bottomLeft || quarter == .bottomRight {
            flipOptions.insert(.vertically)
        }

        return flipOptions
    }

    /// 这里只有上半圈的两个方向，如果想随机多个方向发出
    /// 可以在这里修改方向
    private func shuffledQuarters() -> [Quarter] {
        return [
            .topRight, .topRight,
            .topRight, .topRight,
            .topLeft, .topLeft,
            .topLeft, .topLeft
        ].shuffled()
    }

    private func randomTrajectory(flipOptions: FlipOptions) -> SparkTrajectory {
        var trajectory: SparkTrajectory

        if flipOptions.contains(.vertically) {
            trajectory = self.classicTrajectoryFactory.randomBottomRight()
        } else {
            trajectory = self.classicTrajectoryFactory.randomTopRight()
        }

        return flipOptions.contains(.horizontally) ? trajectory.flip() : trajectory
    }

    private func randomChangeVector(flipOptions: FlipOptions, maxValue: Int) -> CGVector {
        let values = (self.randomChange(maxValue), self.randomChange(maxValue))
        let changeX = flipOptions.contains(.horizontally) ? -values.0 : values.0
        
        /**
            注意！这里不设置 changeY，说明粒子的出发点在一条直线上
             如果想设置初始点在四面八方，加一个 changeY 就好
            
         let changeY = flipOptions.contains(.vertically) ? values.1 : -values.0
         */
        return CGVector(dx: changeX, dy: 0.0)
    }

    private func randomChange(_ maxValue: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(maxValue)))
    }
}
