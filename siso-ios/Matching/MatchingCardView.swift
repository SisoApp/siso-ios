//
//  CardView.swift
//  auth
//
//  Created by jdios on 8/13/25.
//

import SwiftUI
import designSystem
import model
import AVFoundation

struct MatchingCardView: View {
    @StateObject var cardViewModel: CardViewModel
    @State var isPlaying = false
    fileprivate func stateView() -> HStack<TupleView<(some View, Spacer)>> {
        return HStack{
            makeUserStateView()
            Spacer()
        }
    }
    
    fileprivate func profileImageView() -> some View { // url이미지 처리필요
        return Rectangle()
            .frame(maxWidth: .infinity, maxHeight: 242)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal)
            .overlay {
                Image("testimg")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 242)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.horizontal)
            }
    }
    
    var body: some View {
        
        VStack {
            stateView()
                .padding(.horizontal)
            
            profileImageView()
            
            
            HStack {
                Group{
                    Text("\(cardViewModel.nickname),")
                    Text("\(cardViewModel.age)세")
                }
                .font(.system(size: 24, weight: .bold, design: .default))
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Button {
                    if let voiceurl = cardViewModel.voiceSample {
                        isPlaying.toggle()
                    }
                    
                } label: {
                    if let voiceurl = cardViewModel.voiceSample {
                        isPlaying ? Image(systemName: "pause.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                        : Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                           
                    } else {
                        Image(systemName: "play.slash")
                            .resizable()
                            .frame(width: 44, height: 44)
                    }
                    
                }
                .frame(minWidth: 44, minHeight: 44)
                .border(.red)
                
                WaveformView(count: 10, height: 44, isPlaying: $isPlaying)
                    .frame(width: 100)
                
                Spacer()
            }
            
            .frame(width: 200)
            .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.Siso.Gray._10)
                    
                )
            
            HStack {
                Group {
                    ForEach(cardViewModel.interestTags, id: \.self) { interest in
                        Text("#\(interest)")
                            
                            
                    }
                }
            }
            .padding()
            
            
            Text(sampleIntroduction)
                .lineLimit(3)
                .padding()
                .onTapGesture {
                    print ("show all text")
                }
            
            
            HStack {
                Button {
                    print("dfd")
                } label: {
                    Text("전화걸기")
                }

            }
        }
    }
    @ViewBuilder
    func makeUserStateView() -> some View {

        if cardViewModel.isOnline {
            HStack {
                Circle()
                    .fill(.green)
                    .frame(width: 10, height: 10)
                
                Text("온라인")
            }
            
        } else {
            HStack {
                Circle()
                    .fill(.gray)
                    .frame(width: 10, height: 10)
                
                Text("오프라인")
            }
            
        }
    }
}




#Preview {
    let cardViewModel = CardViewModel(
        nickname: "삼성전자회장이나야",
        age: 58,
        isOnline: true,
        interestTags: ["여행✈️", "사진", "카페투어", "애플게시판에 욕설쓰기"],
        profileImages: [
            // Lorem Picsum 서비스를 사용하여 실제 이미지를 가져옵니다. seed를 사용해 항상 같은 이미지가 나오도록 합니다.
            // 샘플 코드이므로 강제 언래핑(!)을 사용했지만, 실제 앱에서는 guard let으로 안전하게 처리해야 합니다.
            URL(string: "https://picsum.photos/seed/jane1/600/400")!,
            URL(string: "https://picsum.photos/seed/jane2/400/600")!,
            URL(string: "https://picsum.photos/seed/jane3/400/600")!
        ],
        // 실제 작동하는 샘플 오디오 파일 (출처: Google)
        voiceSample: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"),
        introduction: "안녕하세요! 좋은 인연을 찾고 있어요. 함께 맛있는 거 먹으러 다녀요.",
        location: "인천 미추홀구"
    )
    MatchingCardView(cardViewModel: cardViewModel)
}



let sampleIntroduction = "[Web발신]\n 너는나를존중해야한다나는발롱도르5개와수많은개인트로피를들어올렸으며2016유로에서포르투갈을이끌고우승을차지했고동시에A매치역대최다득점자이다또한챔스역대최다득점자이자5번이나우승을차지한레알마드리드의상징이다또한36세의나이에도프리미어리그에서18골을기록하고챔스에서5경기연속골을기록하며내가세계최고임을증명해냈다은혜를모르는맨유보드진과팬들은내가맨유의골칫덩이라며쫓아냈지만내가세계최고이고내가팀보다위대하다는사실은바뀌지않는다내가사우디에간이유는메시에대한자격지심이아니라유럽에서이룰수있는모든것을이루었기에아시아를정복하기위해간것이지단지돈을위해서간것이아니다"
