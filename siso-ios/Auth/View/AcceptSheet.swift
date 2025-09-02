//
//  AcceptSheet.swift
//  auth
//
//  Created by 김용해 on 9/2/25.
//

import SwiftUI

public struct AcceptSheet: View {
    let title: String
    let content: String
    var delegate: AuthCoordinatorDelegate?
    public init(title: String,content: String, delegate: AuthCoordinatorDelegate?) {
        self.title = title
        self.content = content
        self.delegate = delegate
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                Text(content)
                    .padding()
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "xmark")
                        .onTapGesture {
                            delegate?.dismissSheet()
                        }
                }
            }
        }
    }
}

#Preview {
    AcceptSheet(
        title: "개인정보 처리방침",
        content: """
    개인정보처리방침

    본 개인정보처리방침은 시팅(이하 “서비스 제공자”)이 무료 및 유료 혼합(Freemium) 서비스 형태로 제공하는 모바일 애플리케이션 시팅(이하 “애플리케이션”)에 적용됩니다. 본 서비스는 “있는 그대로(AS IS)” 제공됩니다.

    개인정보 수집 및 이용 애플리케이션은 사용자가 다운로드 및 이용하는 과정에서 다음과 같은 정보를 수집할 수 있습니다. 기기의 인터넷 프로토콜(IP) 주소
    사용자가 방문한 애플리케이션 내 페이지, 방문 일시, 각 페이지 사용 시간
    애플리케이션 사용 시간
    모바일 기기의 운영체제(OS) 정보
    애플리케이션은 사용자의 정확한 위치정보는 수집하지 않습니다.
    다만, 기기의 위치정보를 수집하여 서비스 제공자는 이를 활용해 대략적인 지역적 위치를 파악하고 아래와 같은 방식으로 사용할 수 있습니다.
    위치 기반 서비스 제공: 맞춤형 콘텐츠, 추천 서비스, 위치 기반 기능 제공
    분석 및 개선: 익명화·집계된 위치 데이터 분석을 통한 사용자 행동 파악, 서비스 품질 향상
    외부 서비스 제공: 필요 시 익명화된 위치 데이터를 외부 서비스에 전송하여 애플리케이션 기능 및 서비스 최적화
    또한, 서비스 제공자는 사용자가 제공한 정보를 활용하여 중요 안내, 법적 고지, 마케팅 프로모션 등을 안내할 수 있습니다.
    더 나은 서비스 경험을 위해, 서비스 제공자는 특정 개인정보 제공을 요청할 수 있으며, 해당 정보는 본 정책에서 명시된 범위 내에서만 보관·이용됩니다.

    제3자 제공 서비스 제공자는 익명화·집계된 데이터만을 외부 서비스에 주기적으로 전송하여 애플리케이션 개선 및 서비스 고도화에 활용합니다. 또한, 서비스 제공자는 본 개인정보처리방침에 명시된 범위 내에서 제3자와 정보를 공유할 수 있습니다. 애플리케이션은 다음과 같은 제3자 서비스를 이용하며, 각 서비스는 자체 개인정보처리방침을 가지고 있습니다.
    Google Analytics for Firebase
    Firebase Crashlytics
    서비스 제공자는 다음의 경우 사용자 제공 정보 및 자동 수집 정보를 공개할 수 있습니다.
    법령상 요구되는 경우(예: 영장, 법적 절차 준수 등)
    권리 보호, 사용자 및 제3자의 안전 보장, 사기 조사, 정부 요청 대응을 위한 경우
    서비스 제공자의 위탁을 받아 업무를 수행하는 신뢰할 수 있는 협력사에게 제공하는 경우(단, 독자적인 활용 불가 및 본 방침 준수 조건)

    3. 이용자의 권리(Opt-Out)
    사용자는 언제든지 애플리케이션 삭제(제거)를 통해 정보 수집을 중단할 수 있습니다.
    이는 모바일 기기 내 표준 삭제 절차 또는 앱 마켓/스토어를 통해 가능합니다.

    4. 개인정보 보관 및 파기
    서비스 제공자는 사용자가 애플리케이션을 사용하는 동안 및 그 이후 합리적인 기간 동안 사용자가 제공한 정보를 보관합니다.
    사용자가 제공한 개인정보의 삭제를 원할 경우, master@likelion.net 으로 문의하시면 합리적인 기간 내에 삭제 조치를 취하겠습니다.

    5. 아동의 개인정보
    서비스 제공자는 만 13세 미만 아동으로부터 고의로 개인정보를 수집하거나 마케팅하지 않습니다.
    애플리케이션은 만 13세 미만 아동을 대상으로 하지 않으며, 만약 13세 미만 아동이 개인정보를 제공한 사실을 인지할 경우 즉시 해당 정보를 서버에서 삭제합니다.
    보호자 또는 법정대리인은 자녀가 개인정보를 제공했음을 알게 될 경우, master@likelion.net으로 연락해 주시기 바랍니다.

    6. 보안 조치
    서비스 제공자는 사용자의 개인정보를 안전하게 보호하기 위해 물리적·전자적·절차적 안전장치를 마련하고 있습니다.

    7. 개인정보처리방침의 변경
    본 개인정보처리방침은 필요에 따라 개정될 수 있습니다. 변경 사항 발생 시 본 페이지에 최신 버전을 게시하며, 사용자는 정기적으로 확인하는 것이 권장됩니다.
    애플리케이션을 계속 이용하는 것은 변경된 정책에 동의하는 것으로 간주됩니다.
    본 개인정보처리방침은 2026년 8월 20일부터 시행됩니다.

    8. 이용자의 동의
    사용자가 애플리케이션을 이용함으로써, 본 개인정보처리방침에 따른 개인정보 처리에 동의하는 것으로 간주됩니다.

    9. 문의처
    개인정보 보호 관련 문의사항이 있을 경우 아래 이메일로 연락 주시기 바랍니다.
    📧 master@likelion.net

    ✦ 본 개인정보처리방침은 App Privacy Policy Generator를 기반으로 작성되었습니다.
    """,
        delegate: nil
    )
}
