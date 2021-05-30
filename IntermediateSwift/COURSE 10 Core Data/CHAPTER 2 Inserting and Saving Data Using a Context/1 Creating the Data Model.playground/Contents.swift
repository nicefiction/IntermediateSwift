import Foundation


/**
 `CHAPTER 2`
 `Inserting and Saving Data Using a Context`
 The most basic operation we can undertake
 in order to persist user data
 is
 a save operation .
 In this stage
 we are going to look at
 how we can insert items into a `managed object context`
 and save it .
 Most of the work is done by Core Data
 so we just need to make sure
 everything is in place
 for the magic to happen .
 */



/**
 `1 Creating the Data Model`
 INTRO — Over the course of the last few videos
 we built up what we called the `Core Data stack` .
 In order to actually use our stack however ,
 we need to create a data model for it to use .
 In this video ,
 let's add an `Entity` to our model .
 */
/**
 Over the course of the last few videos ,
 we built up what we called the `core data stack` .
 In order to actually use our stack , however ,
 we need to create a `data model` for it to use .
 So , let’s bring up the core data stack diagram again .
 
 `Managed Object Context`
    `|`
 `Persistent Store Coordinator`
    `|`
 `Persistent Store = TodoList.sqlite`
 
 At the bottom ,
 we have our `Persistent Store`
 — which is now the `TodoList.sqlite database` .
 We have the `Persistent Store Coordinator` that talks to
 (`A`) the `database` ,
 (`B`) the `Managed Object Model` ,
 and (`C`) the `Managed Object Context` .
 The `Managed Object Model`
 — which is our `object graph layer` —
 is specified as a `"momd" file`
 named `"TodoList"` .
 Essentially , that is where our `data model` is , ...
 
 `class CoreDateStackTheory {`
    `...`
 
    `private(set) lazy var managedObjectModel: NSManagedObjectModel = {`
     
        let modelURL = Bundle.main.url(forResource : "toDoList" ,
                                       withExtension : "momd")!
     
        return NSManagedObjectModel(contentsOf: modelURL)!
    `}()`
 
    `...`
 `}`
 
 ... but as I mentioned earlier , when creating it , we don't have that file yet .
 So , let’s add it to the project .
 We’ll add a `New File` to the ToDoList — to the main group .
 Now this time , instead of going with the default Swift or Cocoa Touch Class ,
 we are going to scroll down to the Core Data section ,
 and we are going to select `Data Model` .
 Select `Next` ,
 and make sure over here — this is very important —
 make sure you are giving it the same name
 that you listed as the name in your core data stack code :
 
 `ToDoList`
 
 So if you went with route number one
 — where we wrote out all the individual parts ,

 `class CoreDateStackTheory {`
    `...`
 
    `private(set) lazy var managedObjectModel: NSManagedObjectModel = {`
     
        let modelURL = Bundle.main.url(forResource : "toDoList" ,
                                       withExtension : "momd")!
     
        return NSManagedObjectModel(contentsOf: modelURL)!
    `}()`
 
 
 `private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {`
     
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel : managedObjectModel)
     
        let url = self.applicationDocumentsDirectory.appendingPathComponent("ToDoList.sqlite")
     
        do {
            try coordinator.addPersistentStore(ofType : NSSQLiteStoreType ,
                                               configurationName : nil ,
                                               at : url)
        } catch let error {
            print(error)
         
            abort()
        }
     
        return coordinator
    }()
 
    ...
 `}`
 
 we specified `"ToDoList"`
 `"momd"` .
 And in our `persistentContainer` ,
 we specify `"ToDoList"` there as well .
 So , we need a `ToDoList file` here .
 So make sure that you stick to this name ,
 otherwise we won't match up with what the stack is looking for .
 Select _Create_ ,
 and now you should have this new file in your project directory ,
 
 `ToDoList.xcdatamodeld`
 
 This is the `GUI editor` , the `core data model editor` ,
 where we will define our `data model` .
 In this editor , we can define the `schema` , that is ,
 the structure and relationships of our data model .
 The editor has two styles ,
 ( 1 ) a tabular style , which is what you see here , which lists the different models ,
 and ( 2 ) a visual style .
 If you look down in the bottom right hand corner , it says _Editor Style_ ,
 and you can click the tab over to switch to the visual style ,
 that is better at depicting the relationships .
 Right now , we can't do that ,
 because we have no models in here , so there is nothing to depict .
 Since we are building a simple app , we will only have a single model .
 So we are going to keep the editor in this default tabular style .
 Models in core data are called `entities` ,
 and to create our first entity , we are going to click ,
 down here in the lower left hand corner of the editor ,
 we are going to click on the _Add Entity button_ . So now ,
 we have a single `empty entity` added to our `model editor` ,
 and you should be able to see it in the entities list right above .
 So , let’s go ahead and edit this entity , select it from the list
 and then open up the utilities panel .
 In the data model inspector ,
 we are going to change the entity `Name` to `Item` .
 This `entity` — or `model` — is going to represent each item in our to-do list .
 Like models in code have stored properties ,
 entities have attributes .
 Since we are creating a to do application ,
 an item only needs to be concerned about two things .
 ( 1 ) What is the description of this task ,
 and ( 2 ) has it been completed ?
 For the first one , the description , a text attribute will do .
 So , make sure you have the `item entity` selected here .
 And you can either click _Add Attribute _in the bottom submenu ,
 or you can just click the _plus button_ right here in this Attribute section , to add a new one .
 Let's name this `Attribute` _text_ .
 For the Attribute's Type ,
 we can select from a series of different types using this drop down menu .
 And for the _text_ `Attribute` , we are going to select `String` ,
 so the item entity has an attribute named text of type `String` .
 Next , we want to know whether a task has been completed or not .
 So , let’s add another `Attribute` .
 We'll name the `Attribute` _isCompleted_ , and the type here is `Boolean` .
 You'll notice in the `Show the Data Model inspector` that for each `Attribute` ,
 there are a few different properties :
 [ 1 ] The first property here is named `Transient` ,
 `Transient` means that this property should not be persisted ,
 and is going to be calculated at runtime .
 For example , consider an attribute fullName , which is made up of first and last name .
 fullName doesn't need to be stored in the database , but can be computed at runtime
 by combining the first and last name when accessed .
 [ 2 ] The next property is an `Optional property` , which is checked by default .
 If left unchecked , Core Data will throw an error
 if we try to save an object without a value for this attribute .
 So , select the `text` attribute ,
 and make sure the `Optional property` is _unchecked_ .
 Although some applications do let you do that ,
 it doesn't make sense to create a to-do list item without any text .
    After the Properties ,
 we have the `Attribute Type` ,
 which we have selected as `Boolean` [OLIVIER : with the isCompleted Attribute selected] .
    Next , we have a `Default Value` .
 We can associate a `Default Value` with an `attribute` if we wish to do so .
 Since each new item we add to our to-do list will always be incomplete ,
 for the `isCompleted` attribute , we can change the `Default Value` .
 First , we can make the `Property` non-Optional ,
 and then we can change the `Default Value`
 to `NO` — which is essentially `false` .
    The `Index in Spotlight property`
 allows the system to search through this attribute
 when the user is searching `Spotlight` on their phone or on the Mac .
 We could make our to-do list searchable via Spotlight , but we are not going to .
    Now finally , `Store in External Record File` is used
 to store large formats . So images or binary objects ,
 they are essentially too large to be stored in a database like `SQLite` .
 So in that case , the attribute would be stored on the disk ,
 and the model contains a `URL` that points to that asset .

 And just like that , we have our `data model` ,
 pretty simple , right ?
 The `data model editor` in `Core Data` makes it really easy
 to define models and relationships .
 We don't have any relationships for this course ,
 but we'll get to that in the future .
 So now that we have defined an `Item` with a few attributes ,
 Xcode is going to turn this `ToDoList.xcdatamodeId file`
 into a `compiled schema` .
 So that at runtime , it loads with an extension of `momd`
 containing information that the `Core Data stack` can communicate with .
 Perfect , now that we have a `data model` ,
 we can start using our stack to build our app .
 */
