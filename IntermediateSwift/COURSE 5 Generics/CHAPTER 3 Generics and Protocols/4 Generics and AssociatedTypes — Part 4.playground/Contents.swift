import Foundation


/**
 `4 Generics and Associated Types` PART 4 of 4
 */
protocol DataProvider {
    
    associatedtype Object
    func object(atIndex index: Int) -> Object
}


protocol ConfigurableView {
    
    associatedtype Data
    func configure(with data: Data)
}


// class ViewController<View: ConfigurableView ,
//                      DataSource: DataProvider> {
class ViewController<View: ConfigurableView ,
                     DataSource: DataProvider>
where View.Data == DataSource.Object {
    
    let view: View
    let data: DataSource
    
    
    init(view: View ,
         data: DataSource) {
        
        self.view = view
        self.data = data
    }
    
    
    func start() {
        
        let object = data.object(atIndex : 0)
        view.configure(with : object)
    }
}


struct StringDataProvider: DataProvider {
    
    let data = [ "someValue" , "anotherValue" ]
    
    func object(atIndex index: Int)
    -> String { return data[index]
    }
}


struct IntView: ConfigurableView {
    
    func configure(with data: Int) {}
}


struct StringView: ConfigurableView {
    
    func configure(with data: String) {}
}


// let controller = ViewController(view: IntView() ,
//                                 data: StringDataProvider())
// ERROR : Generic class 'ViewController' requires the types 'Int' and 'String' be equivalent .
let controller = ViewController(view : StringView() ,
                                data : StringDataProvider())

/**
 ⚠️
 So here is the interesting thing ,
 and the entire point of this complicated example .
 When defining generic constraints
 — as we have done with the `ViewController` class —
 
 `class ViewController<View: ConfigurableView ,`
 `                                               DataSource: DataProvider> { ... }`
 
 if the constraints are protocols that have associatedtypes ,
 you have access to those underlying associatedtypes .
 _What does this mean ?_
 Well , it is pretty straightforward .
 So back in the definition of `ViewController` ,
 we are going to add another constraint to a generic type
 using a `where` clause , and here we are going to say ,
 
 `class ViewController<View: ConfigurableView ,`
                      `DataSource: DataProvider>`
 `where View.Data == DataSource.Object { ... }`
 
 The `where` clause is a new kind of constraint
 where we are saying that the two types
 defined by these underlying associatedtypes
 have to be of the same type .
 `NOTE` that we are not saying that they have to be the same instance
 and be equal to one another . Instead ,
 we are saying that they both have to be the same type .
 
 When we do this ,
 our code at the bottom does not work ,

 `let controller = ViewController(view: IntView() ,`
                                 `data: StringDataProvider())`
 `// ERROR : Generic class 'ViewController' requires the types 'Int' and 'String' be equivalent .`
 
 And now , if I comment this out ,
 
 `// let controller = ViewController(view: IntView() ,`
                                    `data: StringDataProvider())`
 
 it should compile.
 And if I go back to the `ViewController` class
 and uncomment these lines of code ,
 which — remember earlier — we had an issue with this ,
 
 `func start() {`
 
    `let object = data.object(atIndex : 0)`
    `view.configure(with : object)`
 `}`
 
 If I uncomment those ,
 we won't have an error.
 This is because now we are guaranteeing
 that the object returned by the `DataSource`
 
 `let object = data.object(atIndex : 0)`
 
 will be of the same type that the `view` accepts when configuring ,
 
 `view.configure(with : object)`
 
 And now , we can go all the way back down and comment this back in :
 
 `let controller = ViewController(view: IntView() ,`
                                 `data: StringDataProvider())`
 `// ERROR : Generic class 'ViewController' requires the types 'Int' and 'String' be equivalent .`
 
 And we still get an error ,
 because the `associatedtype` defined by `IntView` over here is now `Int` .
 
 `struct IntView: ConfigurableView {`
 
    `func configure(with data: Int) {}`
 `}`
 
 And the one in `StringDataProvider` is now `String` ,
 and they don't match .
 The only way to get rid of this error — and get our code to work — is ,
 to specify the correct types ,
 make sure that those associatedtypes match .
 And we do that by specifying `StringView`
 
 `struct StringView: ConfigurableView {`
 
    `func configure(with data: String) {}`
 `}`
 
 as the argument for `view` ,
 
 `let controller = ViewController(view : StringView() ,`
                                 `data : StringDataProvider())`
 
 and now it works .
 
 By adding an additional constraint on associatedtypes of our underlying generic types ,
 we were able to create some pretty robust code .
 We can now create a `ViewController` that
 ( 1 ) contains a view that displays data ,
 And ( 2 ) ensures — guarantees — that we can only pass in data
 that can be displayed by the view we are selecting .
 There is no room for error here ,
 the compiler prevents you from doing that .
 The other main takeaway from all this ,
 was the third and final type of constraint that you just learned :
 
 `class ViewController<View: ConfigurableView ,`
                      `DataSource: DataProvider>`
 `where View.Data == DataSource.Object { ... }`
 
 
 
 I realise I have gone on quite a bit about this ,
 but let's take one final video
 to look at how what we just learned
 — accessing the underlying `associatedtype` to add a constraint on it —
 can be used in other creative ways .
 */
