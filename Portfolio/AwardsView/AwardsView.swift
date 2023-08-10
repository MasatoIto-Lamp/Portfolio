//
//  AwardsView.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/30.
//

import SwiftUI

// Issueの作成数やクローズ数をベースに獲得アワードを表示するView
struct AwardsView: View {
    // 環境からDataControllerインスタンスを読み取るためのプロパティ
    @EnvironmentObject var dataController: DataController
    
    // ユーザが選択したアワードを保持する
    @State private var selectedAward = Award.example
    
    // アワードの詳細情報を表示するトリガー
    @State private var showingAwardDetails = false
    
    // アワードの詳細情報を表示するアラート画面のタイトル
    var awardTitle: String {
        if dataController.hasEarned(award: selectedAward) {
            return "Unlocked: \(selectedAward.name)"
        } else {
            return "Locked"
        }
    }
    
    // アワードをVGride表示する際のアワードのサイズ設定
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    // アワードをボタンとしてGrid状に配置するView
    // アワードボタンを押すとアラートの詳細情報を示すアラート画面が表示される
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(color(for: award))
                        }
                        .accessibilityLabel(label(for: award))
                        .accessibilityHint(award.description)
                    }
                }
            }
            .navigationTitle("Awards")
        }
        .alert(awardTitle, isPresented: $showingAwardDetails) {
        } message: {
            Text(selectedAward.description)
        }
    }
    
    // 獲得したアワードに対しては本来の色を返すが、獲得していない場合は半透明のセカンダリ色を返す
    func color(for award: Award) -> Color {
        dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5)
    }

    
    func label(for award: Award) -> LocalizedStringKey {
        dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked"
    }
}

//struct AwardsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AwardsView()
//            .environmentObject(DataController.preview)
//    }
//}
