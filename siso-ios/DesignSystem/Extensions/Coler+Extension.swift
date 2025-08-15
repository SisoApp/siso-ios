import SwiftUI

// Hex 코드로 Color를 쉽게 생성할 수 있도록 도와주는 생성자입니다.
// 파일 내에서만 사용되도록 fileprivate으로 선언합니다.
public extension Color {
    init(hex: String) {
        // # 기호 및 공백 제거
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0

        // Hex 값을 스캔하여 UInt64로 변환
        guard scanner.scanHexInt64(&hexNumber) else {
            self.init(UIColor.clear) // 실패 시 투명색으로 초기화
            return
        }
        
        // 각 R, G, B 채널 값을 0-1 사이의 Double로 변환
        let r = Double((hexNumber & 0xff0000) >> 16) / 255
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255
        let b = Double(hexNumber & 0x0000ff) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - siso Design System Colors
public extension Color {
    
    /// siso 디자인 시스템의 색상을 모아놓은 네임스페이스입니다.
    struct Siso {
        
        // MARK: - Primary Colors
        public struct Primary {
            /// #FFD666
            public static let main = Color(hex: "#FFD666")
            /// #FFE58F
            public static let secondary = Color(hex: "#FFE58F")
            
            /// #FFFBFO
            public static let _10 = Color(hex: "#FFFBF0")
            /// #FFF1CC
            public static let _20 = Color(hex: "#FFF1CC")
            /// #FFE499
            public static let _30 = Color(hex: "#FFE499")
            /// #FFE499
            public static let _40 = Color(hex: "#FFE499")
            /// #FFC833
            public static let _50 = Color(hex: "#FFC833")
            /// #FFBB00
            public static let _60 = Color(hex: "#FFBB00")
            /// #CC9500
            public static let _70 = Color(hex: "#CC9500")
            /// #997000
            public static let _80 = Color(hex: "#997000")
            /// #664B00
            public static let _90 = Color(hex: "#664B00")
            /// #332500
            public static let _100 = Color(hex: "#332500")
        }
        
        // MARK: - Gray Scale Colors
        public struct Gray {
            /// #FFFFFF
            public static let _0 = Color(hex: "#FFFFFF")
            /// #FAFAFA
            public static let _5 = Color(hex: "#FAFAFA")
            /// #F5F5F5
            public static let _10 = Color(hex: "#F5F5F5")
            /// #F0F0F0
            public static let _20 = Color(hex: "#F0F0F0")
            /// #BFBFBF
            public static let _40 = Color(hex: "#BFBFBF")
            /// #8C8C8C
            public static let _50 = Color(hex: "#8C8C8C")
            /// #595959
            public static let _60 = Color(hex: "#595959")
            /// #434343
            public static let _70 = Color(hex: "#434343")
            /// #262626
            public static let _80 = Color(hex: "#262626")
            /// #1F1F1F
            public static let _90 = Color(hex: "#1F1F1F")
            /// #141414
            public static let _95 = Color(hex: "#141414")
            /// #000000
            public static let _100 = Color(hex: "#000000")
        }
        
        // MARK: - Semantic Colors
        /// 상태나 의미를 나타내는 색상 그룹입니다.
        public struct Semantic {
            /// #FF4D4F (Error)
            public static let error = Color(hex: "#FF4D4F")
            /// #1890FF (Link)
            public static let link = Color(hex: "#1890FF")
            /// #52C41A (Success)
            public static let success = Color(hex: "#52C41A")
            /// #FAAD14 (Warning)
            public static let warning = Color(hex: "#FAAD14")
        }
        
        // MARK: - Red Colors
        public struct Red {
            public static let _10 = Color(hex: "#FFF1F0")
            public static let _20 = Color(hex: "#FFCCC7")
            public static let _30 = Color(hex: "#FFA39E")
            public static let _40 = Color(hex: "#FF7875")
            public static let _50 = Color(hex: "#FF4D4F")
            public static let _60 = Color(hex: "#F5222D")
            public static let _70 = Color(hex: "#CF1322")
            public static let _80 = Color(hex: "#A8071A")
            public static let _90 = Color(hex: "#820014")
            public static let _100 = Color(hex: "#5C0011")
        }
        
        // MARK: - Blue Colors
        public struct Blue {
            public static let _10 = Color(hex: "#E6F4FF")
            public static let _20 = Color(hex: "#BAE0FF")
            public static let _30 = Color(hex: "#91CAFF")
            public static let _40 = Color(hex: "#69B1FF")
            public static let _50 = Color(hex: "#4096FF")
            public static let _60 = Color(hex: "#1677FF")
            public static let _70 = Color(hex: "#0958D9")
            public static let _80 = Color(hex: "#003EB3")
            public static let _90 = Color(hex: "#002C8C")
            public static let _100 = Color(hex: "#001D66")
        }
        
        // MARK: - Orange Colors
        public struct Orange {
            public static let _10 = Color(hex: "#FFF7E6")
            public static let _20 = Color(hex: "#FFE7BA")
            public static let _30 = Color(hex: "#FFD591")
            public static let _40 = Color(hex: "#FFC069")
            public static let _50 = Color(hex: "#FFA940")
            public static let _60 = Color(hex: "#FA8C16")
            public static let _70 = Color(hex: "#D46B08")
            public static let _80 = Color(hex: "#AD4E00")
            public static let _90 = Color(hex: "#873800")
            public static let _100 = Color(hex: "#612500")
        }
        
        // MARK: - Green Colors
        public struct Green {
            public static let _10 = Color(hex: "#F6FFED")
            public static let _20 = Color(hex: "#D9F7BE")
            public static let _30 = Color(hex: "#B7EB8F")
            public static let _40 = Color(hex: "#95DE64")
            public static let _50 = Color(hex: "#73D13D")
            public static let _60 = Color(hex: "#52C41A")
            public static let _70 = Color(hex: "#389E0D")
            public static let _80 = Color(hex: "#237804")
            public static let _90 = Color(hex: "#135200")
            public static let _100 = Color(hex: "#092B00")
        }
    }
}
