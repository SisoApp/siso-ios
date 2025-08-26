//
//  MyPageCoordinatorDelegate.swift
//  auth
//
//  Created by 멘태 on 8/19/25.
//

public protocol MyPageCoordinatorDelegate: AnyObject {
    func pushMyPage(_ page: MyPage)
    func pushMyPageToProfile()
    func pop()
    func popToRoot()
}


