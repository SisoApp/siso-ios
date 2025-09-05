//
//  SueFeedBackView.swift
//  auth
//
//  Created by jdios on 8/24/25.
//

import SwiftUI

public struct ReportFeedBackView: View {
    
    var onDismiss: () -> Void = {}
    
    public init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }
    
  public  var body: some View {
      ZStack {
          Color.black.opacity(0.3)
          VStack{
              Text("신고 완료")
                  .font(.system(size: 24, weight: .bold))
                  .padding()
              
              Text("접수되었습니다.\n신고 내용은 운영 정책에 따라\n처리될 예정입니다.")
                  .font(.system(size: 20, weight: .semibold))
                  .multilineTextAlignment(.center)
                  .padding()
              
              Button {
                  print("close")
                  onDismiss()
              } label: {
                  Text("닫기")
                      .font(.system(size: 18, weight: .semibold))
                      .foregroundStyle(.black)
                      .padding()
                      .frame(maxWidth: .infinity)
                      .background(
                          RoundedRectangle(cornerRadius: 30)
                              .foregroundStyle(Color.Siso.Primary._50)
                      )
                      .padding()
          }
          
          }
          .frame(width: 330, height: 313)
      }
      .frame(minWidth: .infinity, minHeight: .infinity)
        
    }
}
