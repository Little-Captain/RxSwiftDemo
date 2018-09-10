//: Playground - noun: a place where people can play

import RxSwift

//: Subject
// Observer, Observable, Subscriber, Event, Value
// Observer 收集 Value, 形成 Observable
// Subscriber 订阅 Observable, 捕获 Event, 获取 Value
example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    subject.onNext("Is anyone listening")
    let subscriptionOne = subject
        .subscribe(onNext: { string in
            print(string)
        })
    subject.on(.next("1"))
    subject.onNext("2")
    let subscriptionTwo = subject
        .subscribe({ event in
            print("2)", event.element ?? event)
        })
    subject.onNext("3")
    subscriptionOne.dispose()
    subject.onNext("4")
    // 1
    subject.onCompleted()
    // 2
    subject.onNext("5")
    // 3
    subscriptionTwo.dispose()
    let disposeBag = DisposeBag()
    // 4
    subject
        .subscribe {
            print("3)", $0.element ?? $0)
        }
        .disposed(by: disposeBag)
    subject.onNext("?")
}

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

example(of: "BehaviorSubject") {
    let subject = BehaviorSubject(value: "Initial value")
    subject.onNext("X")
    let disposeBag = DisposeBag()
    subject
        .subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
    // 1
    subject.onError(MyError.anError)
    // 2
    subject
        .subscribe {
            print(label: "2)", event: $0)
        }
        .disposed(by: disposeBag)
}

example(of: "ReplaySubject") {
    // 1
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
    // 2
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    // 3
    subject
        .subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
    subject
        .subscribe {
            print(label: "2)", event: $0)
        }
        .disposed(by: disposeBag)
    subject.onNext("4")
    subject.onError(MyError.anError)
    //    subject.dispose()
    subject
        .subscribe {
            print(label: "3)", event: $0)
        }
        .disposed(by: disposeBag)
}

example(of: "Variable") {
    // 1
    let varibale = Variable("Initial value")
    let disposeBag = DisposeBag()
    // 2
    varibale.value = "New initial value"
    // 3
    varibale.asObservable()
        .subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
    
    // 1
    varibale.value = "1"
    varibale.asObservable()
        .subscribe {
            print(label: "2)", event: $0)
    }
        .disposed(by: disposeBag)
    varibale.value = "2"
}
