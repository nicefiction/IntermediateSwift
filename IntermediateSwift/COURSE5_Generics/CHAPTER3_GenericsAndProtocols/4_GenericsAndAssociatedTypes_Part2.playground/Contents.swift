import Foundation


/**
 `4 Generics and Associated Types` PART 2 of 4
 */
/**
 To illustrate the point of this entire example ,
 let's define a `start( )` method .
 In this class — `ViewController` — we have a view and we have a source of data ,
 and we'd like to configure the view to display it .
 We don't know anything about these objects . In fact , we haven't defined classes yet ,
 or data models , or anything of the sort . That doesn't matter though .
 Since we have defined an interface to get the data ,
 we can retrieve it by using that interface .
 So , for example ,
 to get an instance of the data
 that I am going to give the view , I can say ,
 */

protocol DataProvider {
    
    associatedtype Object
    func object(atIndex index: Int) -> Object
}


protocol ConfigurableView {
    
    associatedtype Data
    func configure(with data: Data)
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
    
    
    func start() {
        
        let object = data.object(atIndex : 0)
        
        // view.configure(with : object) // ERROR : Cannot convert value of type 'DataSource.Object' to expected argument type 'View.Data' .
    }
}

/**
 Again — because this is just an example —
 we are not actually going to bother with what is the `data` we are actually using .
 So , we just provide an index value of `0` .
 So now we have `data` ,
 because this interface specifies how we access that data .
 And if you OPTION click to look at the type of `object` ,
 it is the `associatedtype` : The type of the `object` is `DataSource.object` .
 Now that we have the `data` , let's use this `data` to configure the `view` :
 
 `view.configure(with : object)`
 
 `NOTE` : Again ,
 we don't know anything about the actual view types that we are going to define ,
 but it doesn't matter , because we have a standard interface .
 
 We can say `view.configure`
 because we are guaranteed that
 whatever we pass in as the `view` implements that method ,
 and then we'll pass in the object as our data :
 
 `view.configure(with : object)`
 
 Unfortunately , this doesn't work .
 
 `// ERROR : Cannot convert value of type 'DataSource.Object' to expected argument type 'View.Data' .`
 
 Since we don't have any concrete types defined ,
 all the logic that we have put here
 depends on this contract that we have created
 through various protocols and generic types .
 Right now , all that we know about this `DataProvider` is ,
 that it returns an instance of the `data` :

 `let object = data.object(atIndex : 0)`
 
 Also , we know that a `view` can accept some `data` .
 
 `view.configure(with : object) // ERROR : Cannot convert value of type 'DataSource.Object' to expected argument type 'View.Data' .`
 
 However , we haven't guaranteed to the compiler
 that the data being returned from the DataSource — in this line of code —
 
 `let object = data.object(atIndex : 0)`
 
 will be the same kind of data that the view expects .
 
 `view.configure(with : object) // ERROR : Cannot convert value of type 'DataSource.Object' to expected argument type 'View.Data' .`
 */
/**
 👉 Continue in PART 3
 */
