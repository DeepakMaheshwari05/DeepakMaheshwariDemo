//
//  UIColor+Extensions.swift
//  DeepakMaheshwariDemo
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import UIKit

extension UIColor {
    /// Convenience initializer for hex color values
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: 
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
    /// Helper to create adaptive color for light and dark mode
    static func adaptive(light: String, dark: String) -> UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        }
    }
    
    // MARK: - App Colors
    
    static var appPrimary: UIColor {
        adaptive(light: "#4A3887", dark: "#6B59A6")
    }
    
    static var appBackground: UIColor {
        adaptive(light: "#F2F2F7", dark: "#1F1F24")
    }
    
    static var tableBackground: UIColor {
        adaptive(light: "#E8E8ED", dark: "#29292E")
    }
    
    static var cardBackground: UIColor {
        adaptive(light: "#FFFFFF", dark: "#2C2C2E")
    }
    
    // MARK: - Text Colors
    
    static var primaryText: UIColor {
        adaptive(light: "#000000", dark: "#FFFFFF")
    }
    
    static var secondaryText: UIColor {
        adaptive(light: "#3C3C43", dark: "#EBEBF5").withAlphaComponent(0.6)
    }
    
    static var tertiaryText: UIColor {
        adaptive(light: "#3C3C43", dark: "#EBEBF5").withAlphaComponent(0.3)
    }
    
    static var separatorColor: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark 
                ? UIColor(hex: "#545458").withAlphaComponent(0.65)
                : UIColor(hex: "#3C3C43").withAlphaComponent(0.29)
        }
    }
    
    // MARK: - P&L Colors
    
    static var profitGreen: UIColor {
        adaptive(light: "#34C759", dark: "#33C759")
    }
    
    static var lossRed: UIColor {
        adaptive(light: "#FF3B30", dark: "#FF453A")
    }
    
    // MARK: - Other Colors
    
    static var portfolioHeaderBackground: UIColor {
        adaptive(light: "#4A3887", dark: "#403373")
    }
    
    static var shadowColor: UIColor {
        return UIColor { traitCollection in
            UIColor(hex: "#000000").withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.3 : 0.05)
        }
    }
}


