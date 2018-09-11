//: Playground - noun: a place where people can play

import RxSwift

//: Sharing subscriptions
// The observable calls its create closure each time you subscribe to it
// in some situations, this might produce some bedazzling effects
// 每次订阅, 都会导致 observable 调用它的 create 闭包
// 在一些情况下, 这可能会产生一些令人费解的效果

example(of: "Sharing subscriptions") {
    
    var start = 0
    func getStartNumber() -> Int {
        start += 1
        return start
    }
    
    let numbers = Observable<Int>.create { observer in
        let start = getStartNumber()
        observer.onNext(start)
        observer.onNext(start+1)
        observer.onNext(start+2)
        observer.onCompleted()
        return Disposables.create()
    }
    //    output
    //    element [1]
    //    element [2]
    //    element [3]
    //    ---------------
    numbers
        .subscribe(onNext: { el in
            print("element [\(el)]")
        }, onCompleted: {
            print("---------------")
        })
    
    //    output
    //    element [2]
    //    element [3]
    //    element [4]
    //    ---------------
    numbers
        .subscribe(onNext: { el in
            print("element [\(el)]")
        }, onCompleted: {
            print("---------------")
        })
    // The problem is that each time you call subscribe(...), this creates a new Observable
    // for that subscription — and each copy is not guaranteed to be the same as the previous.
    // And even when the Observable does produce the same sequence of elements, it’s
    // overkill to produce those same duplicate elements for each subscription. There’s no
    // point in doing that.
    // 每次调用 subscribe(...), 都会为相应的 subscription 创建新的 Observable (调用 Observable 的 create 闭包)
    // 并不保证每个副本与前一个相同
    // 即使 Observable 生成相同的序列元素, 为每个 subscription 生成相同的重复元素也是一种浪费
    // 这样做毫无意义
    
    // To share a subscription, you can use the share() operator. A common pattern in Rx
    // code is to create several sequences from the same source Observable by filtering out
    // different elements in each of the results.
    // 为了共享 subscription, 你可以使用 share() operator
    // Rx 代码中的一个通用模式是:
    // 对相同的源 Observable, 调用不同的过滤操作来创建多个特定 Observable
}
