/*
1. 각 모듈별로 Coordinator Protocol 정의 <Profile/Coordinator/ProfileCoordinatorDelegate 참고>
    -> @ViewBuilder는 프로토콜에 정의할 수 없어서 우회해야 함. ex) func buildProfileView(_ page: ProfilePage) -> AnyView
2. 코디네이터를 사용할 뷰에 delegate 변수 선언 <Profile/BasicProfileView delegate 참고>
3. 코디네이터 모듈의 Coordinator에 해당 프로토콜의 구현부를 작성
4. 뷰빌더에서 delegate = self 를 주입
5. 뷰에서 화면 전환이 필요한 시점에 delegate의 메서드를 호출해 사용 <Profile/BasicProfileView 계속하기 버튼 참고>
 
Flow 교체는 아직 구현 x
*/
