import Foundation


/**
 `4 The Managed Object Model`
 INTRO — Part of initialising our `Core Data stack`
 involves
 taking the `object graph`
 and creating a `schema` or outline of it for Core Data to work with .
 In this video ,
 we look at
 how we can easily achieve this
 using the `NSManagedObjectModel class` .
 */
/**
 The second part of our Core Data stack is the `Managed Object Model` .
 It is important to remember that the `Managed Object Model`
 is not the `Model Objects` themselves , but the entire `Object Graph` .
 Think of it this way ,
 each model
 — for example , an Employee class —
 is a `managed object` .
 Our `object graph` could contain three managed objects :
 Employee , Manager , and Department .
 The `Managed Object Model` — which we are about to create —
 is a `schema` or outline of all the `managed objects`
 and their relationships to one another .
 Remember , I said that `Core Data` is good at maintaining these relationships .
 Well , that is what the `Managed Object Model` does .
 While the `Managed Object Model` is created in code ,
 we'll actually use a graphical user interface — a GUI editor —
 to create each managed object , but more on that in a bit.
 The `Managed Object Model` is represented by the class `NSManagedObjectModel` .
 And to use this class in our code , we need to import the CoreData framework ,
 
 `import CoreData`
 
 We create the `managed object model` as a `lazy stored property` with a `closure`
 — just like we have been doing :
 
 `class CoreDataStack {`
     
     ...
     
     
     // Creates the Managed Object Model :
     lazy var managedObjectModel: NSManagedObjectModel = {}()
 `}`
 
 `NOTE` : Just for your information ,
 if you are doing this pattern ...
 
 `lazy var managedObjectModel: NSManagedObjectModel = {}()`
 
 ... where you are specifying the type
 and then assigning a `closure` that you call immediately ,
 if you don't assign this type
 then it is not going to work .
 First of all , because , the compiler can't infer it .
 And secondly , if you don't go ahead and return the object of that type immediately ,
 you might run into these cases where the compiler doesn't know
 how to auto complete
 or it returns an error on some of these things .
 And that is again because the compiler can't infer the type .
 So , just keep in mind that you are not doing anything wrong ,
 it is just the compiler trying to figure things out .
 
 The body of the closure is pretty simple .
 Since we'll be creating the `managedObjectModel` using a GUI editor ,
 we can initialise the `managedObjectModel` in code from a file.
 But first we need a `URL` for the file that we are going to initialise it with .
 We haven't created this file yet ,
 but let's go ahead and obtain a `URL` for it .
 We can do that because we know the name ,
 since when we created that file , we will give it the same name .
 We are going to use the `Bundle class`
 to find the `URL` for a resource in the main bundle :
 
 `lazy var managedObjectModel: NSManagedObjectModel = {`
     
     let modelURL = Bundle.main.url(forResource : "toDoList" ,
                                    withExtension : "momd")!
     
     return NSManagedObjectModel(contentsOf: modelURL)!
 `}()`
 
 Now that we have a `URL` that we have unwrapped ,
 
 `let modelURL = Bundle.main.url(forResource : "toDoList" ,`
                                `withExtension : "momd")!`
 
 we create and return a `NSManagedObjectModel` .
 
 `return NSManagedObjectModel(contentsOf: modelURL)!`
 
 `NSManagedObjectModel` has a failable initialiser ,
 so , we are going to force unwrap it as well .
 Now , this is unsafe — if you are thinking that , you are right .
 But in this case ,
 we actually do want the program to crash if we can't load our managed object model .
 Because then we can't use any of these.
    And that is the `managed object models` done .
 Let's make one quick change here .
 When we use this `Core Data stack` in the rest of our app ,
 we don't want anyone modifying these properties
 — the `applicationDocumentsDirectory` , the `managedObjectModel` —
 so , we are going to make them `private` properties .
 To make properties and methods private , we use the `private` keyword .
 But again , there is more nuance to it .
 If I want these properties to be readable publicly
 but not settable . So essentially , what we want to do , is ,
 make the `setter` `private` , but the `getter` `public` .
 To do that , we'll say
 
 `class CoreDataStack {`
     
     // Creates a destination to store the data :
     private(set) lazy var applicationDocumentsDirectory: URL = {
         
         let urls = FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,
                                             in : FileManager.SearchPathDomainMask.userDomainMask)
         
         let endIndex = urls.index(before : urls.endIndex)
         
         return urls[endIndex]
     }()
     
     
     // Creates the Managed Object Model :
     private(set) lazy var managedObjectModel: NSManagedObjectModel = {
         
         let modelURL = Bundle.main.url(forResource : "toDoList" ,
                                        withExtension : "momd")!
         
         return NSManagedObjectModel(contentsOf: modelURL)!
     }()
 `}`
 
 So now
 we could _read_ these properties
 — if we wanted to —
 from this `CoreDataStack class` ,
 but we can't _set_ it .
 This ensures that we can only modify the properties
 from inside the `class` .
 The `NSManagedObjectModel instance`
 
 `return NSManagedObjectModel(contentsOf: modelURL)!`
 
 describes the data
 that is going to be accessed by the `CoreDataStack` .
 During the creation of the `CoreDataStack` ,
 the `NSManagedObjectModel`
 — often referred to as the `MOM` , for `Managed Object Model` —
 is loaded into memory as the first step in the creation of the `CoreDataStack` .
 Once this object is initialised , the `coordinator object` is constructed .
 So , let's go to that next .
 */
