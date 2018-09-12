//: Playground - noun: a place where people can play

import RxSwift

//: Transforming Operators

example(of: "toArray") {
    let disposeBag = DisposeBag()
    // 1
    Observable.of("A", "B", "C")
        // 2
        .toArray()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

example(of: "map") {
    let disposeBag = DisposeBag()
    // 1
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    // 2
    Observable<NSNumber>.of(123, 4, 56)
        // 3
        .map { formatter.string(from: $0) ?? "" }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

example(of: "enumerated and map") {
    let bag = DisposeBag()
    Observable.of(1, 2, 3, 4, 5, 6)
        .enumerated()
        .map { $0 > 2 ? $1 * 2 : $1 }
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
}

struct Student {
    
    var score: BehaviorSubject<Int>
    
}
