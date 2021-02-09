import Foundation


/**
 `4 Generics and Associated Types` PART 1 of 4
 INTRO — So far we have looked at
 generic type parameters and associated types
 as two different concepts
 but more often than not
 we will be using them together .
 In this video , we are going to look at
 some of the limitations
 of having protocols with associated types
 and how generics helps us resolve that .
 */
/**
 Okay , let's take a look at another use case for associatedtypes .
 Like in the last video , heads up , this is decently hard to grasp conceptually .
 So don't worry too much if you don't get it . This is one of those cases
 where you don't expect you'll be writing code like this often at all ,
 but the Standard Library does . So , at the very minimum ,
 this will help you understand what is going on in the language .
 Imagine a scenario where we have
 ( 1 ) different kinds of data in our app
 and ( 2 ) different kinds of views to display them .
 For a given type of data ,
 we have a very specific view that can display it .
 We can simply write whatever code works for each pairing of data and view
 to make sure that a view can accept data in a format .
 But we are sensible programmers .
 We want to write our code in such a way
 that we have standard interfaces across our models and views
 in regards to how they communicate with one another .
 So , let’s start here by defining a protocol :
 */

protocol DataProvider {
    
    associatedtype Object
    func object(atIndex index: Int) -> Object
}

/**
 Objects that conform to `DataProvider`
 act as DataProviders for different views .
 We assume that the underlying data is stored in different ways ,
 depending on the model . All we care about is
 how the view asks the model for the data , so
 we define a single standard method :
 
 `func object(atIndex index: Int) -> Object`
 
 Given an index — we are making an assumption here
 that the underlying data storage is an Array , or a linked list ,
 but let's ignore all that .
 Let’s say that given an index , we'd like an instance of the model or a model value .
 To specify the return type though — remember
 that we are going to conform to this interface
 across a wide variety of models
 — so , the return type is going to vary , and we'll need to make it generic .
 And since we are in a protocol ,
 that means an `associatedtype` :
 
 `associatedtype Object`
 
 So this is the minimal interface for a data model :
 
 `protocol DataProvider {`
 
    `associatedtype Object`
    `func object(atIndex index: Int) -> Object`
 `}`
 
 Objects that conform to it — models that conform to it —
 have to implement this method ,
 and then each of those models
 returns an instance of whatever data it is storing .
 
 _What about a view ?_
 For a view
 to accept data and display it ,
 it needs to be configurable ,
 but every view has different UI elements ,
 and different ways of displaying data .
 So the actual way data is displayed , well ,
 we can't define a standard interface around that .
 But what we can try and guarantee , is ,
 that a view has a defined interface
 to accept some data and configure itself .
 So regardless of the view ,
 we can call this method
 and pass in some data ,
 and we are guaranteed that the view will configure itself .
 So let's define another protocol ,
 */

protocol ConfigurableView {
    
    associatedtype Data
    func configure(with data: Data)
}

/**
 Views that conform to `ConfigurableView`
 have a standard interface to accept some `data` .
 Remember that views accept a range of data ,
 so we can't specify a single type .
 We could list `DataProvider` as the type of data that this view accepts .
 Because then we are at least restricted to models with that defined interface ,
 but there are several issues with that . For starters ,
 we don't want a view to accept — as an argument — the entire `DataProvider` ,
 just an instance of the `data` to display .
 As you learned in the last video , though ,
 by specifying a protocol as the type ,
 we can specify any type that conforms to the protocol .
 But we don't want to do that here ,
 we want a view to display a very specific kind of data .
 Now , even if that was the case ,
 we cannot list the `DataProvider` protocol as an argument type ,
 because it has an `associatedtype` requirement :
 
 `protocol DataProvider {`
 
    `associatedtype Object`
    `func object(atIndex index: Int) -> Object`
 `}`
 
 Anyway , all of that indicates
 that what we need here
 is another `associatedtype` requirement ,
 
 `protocol ConfigurableView {`
 
    `associatedtype Data`
    `func configure(with data: Data)`
 `}`
 
 Okay , now that we have that type ,
 let's add in a single requirement
 that views can accept `data`
 and `configure()` themselves with it :
 
 `func configure(with data: Data)`
 
 So , we have a `configure()` method that takes some `data` ,
 And then each view will implement its own way
 to use that `data` to display it .
 We are off to a good start .
 The final bit of this puzzle is
 an object that facilitates the data and view pairing .
 We'll call this object a `ViewController` :
 */

class ViewController<View: ConfigurableView ,
                     DataSource: DataProvider> {
    
    let view: View
    let data: DataSource
    
    
    init(view: View ,
         data: DataSource) {
        
        self.view = view
        self.data = data
    }
}

/**
 The `ViewController` is initialised
 with a stored property — `view` — that is configurable :
 
 `let view: View`
 
 What is the type of this view going to be , though ?
 Well , it is any view that is configurable .
 Again , remember though ,
 that we cannot specify the `ConfigurableView` protocol as the type ,
 because it has `associatedtype` requirements .
 Which means that we need to make this `ViewController` class , generic ,
 and introduce some type parameters :
 
 `class ViewController<View: ConfigurableView ,`
                      `DataSource: DataProvider> { ... }`
 
 We say that the `ViewController`
 has a generic type parameter — `View` —
 and we want to restrict this `View`
 to be any type that conforms to `ConfigurableView` .
 That means that
 now we can specify the type of `view` as `View` , which is our generic type :
 
 `let view: View`
 
 We also need data to configure this `view` ,
 so we'll add a stored property for that as well .
 
 `let dataSource: DataSource`
 
 Just like the `View` ,
 the Data types we want to accept
 are those that conform to `DataProvider` .
 And since this protocol also has an `associatedtype` requirement ,
 we need to add an additional type parameter — `DataSource` :
 
 `class ViewController<View: ConfigurableView ,`
                      `DataSource: DataProvider> { ... }`
 
 We call it `DataSource` ,
 and this type needs to conform to `DataProvider` .
 Finally , `data` is going to be of type `DataSource` :
 
 `let data: DataSource`
 
 Since we have our relevant stored properties now ,
 we need to add an initialiser
 just to satisfy class requirements ,
 
 `init(view: View ,`
 `data: DataSource) {`

    `self.view = view`
    `self.data = data`
 `}`
 
 */
/**
 👉 Continue in PART 2
 */
