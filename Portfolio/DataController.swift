//
//  DataController.swift
//  Portfolio
//
//  Created by イトマサ on 2023/07/20.
//

import CoreData
import SwiftUI

// CoreDataとのデータ連携、各Viewで使用するデータ整形を一手に担うクラス
class DataController: ObservableObject {
    
    // プレビュー用インスタンス
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    // CoreDataを使用するためのコンテナ
    // iCloudと同期しデバイス間で同じデータを共有する役割を担う
    let container: NSPersistentCloudKitContainer
    
    // エンティティのモデルファイルを読み込む
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        
        return managedObjectModel
    }()
    
    // SidebarViewで選択されているフィルタを保持する
    @Published var selectedFilter: Filter? = Filter.all
    
    // ContentViewで選択されているIssueを保持する
    @Published var selectedIssue: Issue?
    
    // ContentViewの検索boxに入力された文字列を保持する
    @Published var filterText = ""
    
    // ContentViewの検索boxで選択されたトークンを保持する
    @Published var filterTokens = [Tag]()
    
    // ContentViewのIssue絞り込みフィルターの有効状態On/Offを保持する
    @Published var filterEnabled = false
    
    // ContentViewのIssue絞り込みフィルター条件(優先度)を保持する
    @Published var filterPriority = -1
    
    // ContentViewのIssue絞り込みフィルター条件(状態_All/Opne/Closed)を保持する
    @Published var filterStatus = Status.all
    
    // ContentViewのIssue一覧リストのソートタイプ(作成日/更新日)を保持する
    @Published var sortType = SortType.dateCreated
    
    // ContentViewのソート順を日付が新しい順に並べるかどうか保持する
    @Published var sortNewestFirst = true
    
    // ContentViewの検索Boxで提案されるトークンの一覧を返す
    var suggestedFilterTokens: [Tag] {
        guard filterText.starts(with: "#") else {
            return []
        }
        
        let trimmedFilterText = String(filterText.dropFirst()).trimmingCharacters(in: .whitespaces)
        let request = Tag.fetchRequest()
        
        // #の後に文字が入力されていた場合、その文字を名前に含むTagをフェッチする
        if trimmedFilterText.isEmpty == false {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", trimmedFilterText)
        }
        return (try? container.viewContext.fetch(request).sorted()) ?? []
    }
    
    // DetailVeiwにおける変更保存前のスリープタスクを保持する
    private var saveTask: Task<Void, Error>?
    
    // データコントローラの初期化
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        
        // プレビュー用データはディスクではなくメモリへ保存するための設定
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        // データ変更が競合した際のポリシー設定
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        // リモートでのデータの変更通知を有効にするための設定
        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
        )
        
        // リモートデータストア内で変更が行われた場合に通知を受け取るための通知オブザーバを設定
        NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator,
            queue: .main,
            using: remoteStoreChanged
        )
        
        // 親コンテキストからの変更が自動的に子コンテキストにマージされるようにする設定
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // ディスクデータをコンテナへ読み込み
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
#if DEBUG
            // UIテスト時にアプリのデータをゼロの状態へ戻す
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
            }
#endif
        }
    }
    
    // プレビュー用サンプルデータとしてTagを5個、各Tagに対しIssue10個を生成
    func createSampleData() {
        let viewContext = container.viewContext
        
        for tagCounter in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(tagCounter)"
            
            for issueCounter in 1...10 {
                let issue = Issue(context: viewContext)
                issue.title = "Issue \(tagCounter)-\(issueCounter)"
                issue.content = NSLocalizedString("Description goes here", comment: "Write description here")
                issue.creationDate = .now
                issue.completed = Bool.random()
                issue.priority = Int16.random(in: 0...2)
                tag.addToIssues(issue)
            }
        }
        
        try? viewContext.save()
    }
    
    // 変更をディスクへ反映
    func save() {
        saveTask?.cancel()
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    // 特定のTag、Issueを削除しディスクへ反映
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    // 全てのTag、Issueを削除しディスクへ反映
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
        delete(request2)
        
        save()
    }
    
    // FetchRequestを受け取り、全Tag、もしくは全Issueデータの削除を実行
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    // リモートでの変更を検知した際にUIを更新する
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    // Issueに紐づいていないタグを全て返す
    func missingTags(from issue: Issue) -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []
        
        let allTagsSet = Set(allTags)
        let difference = allTagsSet.symmetricDifference(issue.issueTags)
        
        return difference.sorted()
    }
    
    // DetailViewにてIssueの情報が更新された際に保存処理を行う
    func queueSave() {
        saveTask?.cancel()
        
        // 過多な頻度で保存処理が生じぬよう最終更新から3秒間経過後に保存処理を行う
        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(3))
            save()
        }
    }
    
    // ContentViewで表示するFilter条件に合致したIssueだけを返す
    func issuesForSelectedFilter() -> [Issue] {
        let filter = selectedFilter ?? .all
        
        // Issueフェッチ時の条件を格納する
        var predicates = [NSPredicate]()
        
        // FilterがTagを持つ場合、ユーザフィルタを指す。フェッチ条件へtagを持つことを追加。
        // FilterがTagを持たない場合、スマートフィルタを指す。フェッチ条件へminModificationDateより前であることを追加
        if let tag = filter.tag {
            let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
            predicates.append(tagPredicate)
        } else {
            let datePredicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            predicates.append(datePredicate)
        }
        
        // ContentViewの検索boxに文字列が入力されていれば、文字列をタイトル/コンテンツに含むIssueをフェッチ条件へ追加
        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)
        
        if trimmedFilterText.isEmpty == false {
            let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", trimmedFilterText)
            let contentPredicate = NSPredicate(format: "content CONTAINS[c] %@", trimmedFilterText)
            let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, contentPredicate])
            predicates.append(combinedPredicate)
        }
        
        // ユーザ選択されたトークン(複数の可能性あり)を持つIssueをフィルタ
        if filterTokens.isEmpty == false {
            let tokenPredicate = NSPredicate(format: "ANY tags IN %@", filterTokens)
            predicates.append(tokenPredicate)
        }
        
        //フィルタ設定がON時のフィルタ
        if filterEnabled {
            // Issueの優先度条件に合致することをフェッチ条件へ追加
            if filterPriority >= 0 {
                let priorityFilter = NSPredicate(format: "priority = %d", filterPriority)
                predicates.append(priorityFilter)
            }
            
            // Issueのステータス(Open/Closed)に合致することをフェッチ条件へ追加
            if filterStatus != .all {
                let lookForClosed = (filterStatus == .closed)
                let statusFilter = NSPredicate(format: "completed = %@", NSNumber(value: lookForClosed))
                predicates.append(statusFilter)
            }
        }
        
        let request = Issue.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)]
        
        let allIssues = (try? container.viewContext.fetch(request)) ?? []
        return allIssues
    }
    
    // ContetnViewで表示する各Issue行の背景色を返す
    func colorForSelectedFilter(issue: Issue) -> Color {
        if issue.completed {
            return .gray.opacity(0.5)
        } else {
            switch issue.priority {
            case 1:
                return .yellow.opacity(0.2)
            case 2:
                return .red.opacity(0.2)
            default:
                return .green.opacity(0.2)
            }
        }
    }
    
    // 新たなIssueを作成する
    func newIssue() {
        let issue = Issue(context: container.viewContext)
        issue.title = NSLocalizedString("New issue", comment: "Create a new issue")
        issue.creationDate = .now
        issue.priority = 1
        if let tag = selectedFilter?.tag {
            issue.addToTags(tag)
        }
        save()
        selectedIssue = issue
    }
    
    // 新たなTagを作成する
    func newTag() {
        let tag = Tag(context: container.viewContext)
        tag.id = UUID()
        tag.name = NSLocalizedString("New tag", comment: "Create a new tag")
        save()
    }
    
    // フェッチリクエスト対象の件数を返す (Unitテストにて使用)
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    // 引数として渡されたアワードを獲得済みかどうかを返す
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "issues":
            // returns true if they added a certain number of issues
            let fetchRequest = Issue.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        case "closed":
            // returns true if they closed a certain number of issues
            let fetchRequest = Issue.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        case "tags":
            // return true if they created a certain number of tags
            let fetchRequest = Tag.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        default:
            // an unknown award criterion; this should never be allowed
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
}

// ContentViewのIssueリストのソート順を定義した型
enum SortType: String {
    case dateCreated = "creationDate"
    case dateModified = "modificationDate"
}

// ContentViewのIssueリストのフィルタ利用としてIssueのステータスを定義した型
enum Status {
    case all, open, closed
}
