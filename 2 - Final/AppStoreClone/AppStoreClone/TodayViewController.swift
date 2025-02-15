import UIKit

final class TodayViewController: UIViewController {
    
    /*
     DiffableDataSource:
     indexpathで管理していたものをアイテム固有のidentifierで管理できるようになる。
     performbatchupdatesで生じていた不整合なindexpathへの操作によるエラーを回避できる。
     
     performbatchupdates: https://qiita.com/shiz/items/2e9771fe56e39544ff3e#performbatchupdates
     */
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self

        collectionView.register(TodayHeaderCell.nib, forCellWithReuseIdentifier: TodayHeaderCell.reuseIdentifier)
        collectionView.register(TodayAppCell.nib, forCellWithReuseIdentifier: TodayAppCell.reuseIdentifier)

        return collectionView
    }()

    lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }

            let snapshot = self.dataSource.snapshot()
            let sectionKind = snapshot.sectionIdentifiers[sectionIndex].kind

            switch sectionKind {
            case .todayHeader:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(82))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.893), heightDimension: .estimated(82))
                let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitems: [item])
                innerGroup.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .flexible(0), top: nil, trailing: .flexible(0), bottom: nil)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(82))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])

                let section = NSCollectionLayoutSection(group: group)
                return section
            case .todayApp:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.179))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

                let section = NSCollectionLayoutSection(group: group)
                return section
            default:
                return nil
            }
        }
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        configureDataSource()
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { [weak self] (collectionView, indexPath, item) in
            guard let self = self else { return nil }

            let snapshot = self.dataSource.snapshot()
            let sectionKind = snapshot.sectionIdentifiers[indexPath.section].kind
            
            // セクションのcellにデータを渡す必要があればここで渡す
            switch sectionKind {
            case .todayHeader:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayHeaderCell.reuseIdentifier, for: indexPath)
                return cell
            case .todayApp:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayAppCell.reuseIdentifier, for: indexPath)
                return cell
            default:
                return nil
            }
        }

        // 更新後データの整形
        let sections = [
            Section(kind: .todayHeader, items: [Item()]),
            Section(kind: .todayApp, items: [
                Item(),
                Item(),
                Item(),
            ]),
        ]

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension TodayViewController: UICollectionViewDelegate {}
