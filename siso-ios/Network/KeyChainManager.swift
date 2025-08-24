//
//  UserInfoDefault.swift
//  network
//
//  Created by 김용해 on 8/15/25.
//

import Foundation
import Security

/**
 * @class UserInfoDefault
 * @brief 사용자 인증 토큰을 iOS의 안전한 저장소인 키체인에 저장하고 관리합니다.
 *
 * 이 클래스는 UserDefaults가 아닌 Keychain을 사용하여 accessToken과 refreshToken을 안전하게 보관합니다.
 */
public final class KeyChainManager: Sendable {
    
    public static let shared = KeyChainManager()
    
    // 키체인 서비스를 식별하는 고유 문자열입니다. 앱의 번들 ID 등을 사용하는 것이 일반적입니다.
    private let service = "com.siso.siso-ios"

    private init() {}

    /**
     * 토큰을 키체인에 저장합니다.
     * - Parameters:
     *   - token: 저장할 토큰 문자열
     *   - key: 토큰을 식별하는 키 (예: "accessToken", "refreshToken")
     */
    public func save(token: String, for key: String) {
        guard let data = token.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // 기존에 동일한 키로 저장된 값이 있다면 삭제합니다. (업데이트를 위해)
        SecItemDelete(query as CFDictionary)
        
        // 새로운 값을 키체인에 추가합니다.
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Keychain save error: \(status)")
        }
    }

    /**
     * 키체인에서 토큰을 불러옵니다.
     * - Parameter key: 불러올 토큰을 식별하는 키
     * - Returns: 저장된 토큰 문자열. 값이 없으면 nil을 반환합니다.
     */
    public func get(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }

    /**
     * 키체인에서 토큰을 삭제합니다.
     * - Parameter key: 삭제할 토큰을 식별하는 키
     */
    public func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Keychain delete error: \(status)")
        }
    }
    
    /**
     * 키체인에 저장된 모든 토큰 (accessToken, refreshToken)을 삭제합니다.
     * 주로 로그아웃 시 사용됩니다.
     */
    public func clearAllTokens() {
        delete(for: "accessToken")
        delete(for: "refreshToken")
    }
}
