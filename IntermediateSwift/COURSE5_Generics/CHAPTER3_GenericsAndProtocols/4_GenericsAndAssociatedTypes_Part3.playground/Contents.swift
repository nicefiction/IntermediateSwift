import Foundation


/**
 `4 Generics and Associated Types` PART 3 of 4
 */
/**
 I am going to paste in some code :
 */

protocol DataProvider {
    
    associatedtype Object
    func object(atIndex index: Int) -> Object
}


protocol ConfigurableView {
    
    associatedtype Data
    func configure(withData data: Data)
}


class ViewController<View: ConfigurableView ,
                     DataSource: DataProvider> {
    
    let view: View
    let data: DataSource
    
    
    init(view: View ,
         data: DataSource) {
        
        self.view = view
        self.data = data
    }
    

//    func start() {
//
//        let object = data.object(atIndex: 0)
//        view.configure(with : object)
//    }
}


struct StringDataProvider: DataProvider {
    
    let data = [ "someValue" , "anotherValue" ]
    
    
    func object(atIndex index: Int)
    -> String {
        
        return data[index]
    }
}


struct IntView: ConfigurableView {
    
    func configure(withData data: Int) {}
}


struct StringView: ConfigurableView {
    
    func configure(withData data: String) {}
}


let controller = ViewController(view : IntView() ,
                                data : StringDataProvider())

/**
 Okay , let's scroll back up to the top .
 So here is what I have pasted in .
 We have a couple of different objects here
 that conform to the protocols we have created .
 So first is a `DataProvider` that contains some underlying string `data` :
 
 `struct StringDataProvider: DataProvider {`
 
    `let data = [ "someValue" , "anotherValue" ]`

 
    `func object(atIndex index: Int)`
    `-> String {`
     
        `return data[index]`
    `}`
 `}`
 
 The `StringDataProvider` object implements the `object() atIndex` method ,
 and we specify an `associatedtype` here as `String` .
 So now this DataProvider returns a specific type String . After that , down here ,
 
 `struct IntView: ConfigurableView {`
 
    `func configure(with data: Int) {}`
 `}`
 
 
 `struct StringView: ConfigurableView {`
 
    `func configure(with data: String) {}`
 `}`
 
 we have two objects — `IntView` and `StringView` — that represent views .
 These views are modelled to display very specific types of data .
 `IntView` can only display integers
 — as seen by the fact that the `configure()` protocol method accepts an `Int` —
 and a `StringView` accepts and displays a `String` .
 As stated by the names and the type of code we are trying to write ,
 we want `StringView` to be the view associated with `StringDataProvider` :
 
 `struct StringDataProvider: DataProvider {`
 
    `let data = [ "someValue" , "anotherValue" ]`

 
    `func object(atIndex index: Int)`
    `-> String {`
     
        `return data[index]`
    `}`
 `}`
 
 But as you can see at the bottom ,
 
 `let controller = ViewController(view : IntView() ,`
                                 `data : StringDataProvider())`
 
 we can create an instance .
 Let me go up here and comment all this out ,
 
 `//    func start() {`
 `//`
 `//        let object = data.object(atIndex: 0)`
 `//        view.configure(with : object)`
 `//    }`
 
 and run this ,
 so it should compile okay .
 And as you can see at the bottom here ,
 
 `let controller = ViewController(view : IntView() ,`
                                 `data : StringDataProvider())`
 
 we can create an instance of the `ViewController`
 with an `IntView` and a `StringDataProvider` ,
 and this compiles perfectly .
 Our code , as it stands ,
 does not allow a way to guarantee that the data returned
 by the `DataProvider` ,
 which is a `String` in this case , i
 s the same as the data accepted by the `ConfigurableView` ,
 which is an `Int` in this case :
 
 `let controller = ViewController(view : IntView() ,`
                                 `data : StringDataProvider())`
 
 These two types ,
 what the `DataProvider` returns and the `ConfigurableView` accepts ,
 are defined by their relevant `associatedtypes` :
 
 `protocol DataProvider {`
 
    `associatedtype Object`
    `func object(atIndex index: Int) -> Object`
 `}`
 
 
 `protocol ConfigurableView {`
 
    `associatedtype Data`
    `func configure(withData data: Data)`
 `}`
 */
/**
👉 Continue in PART 4
*/
