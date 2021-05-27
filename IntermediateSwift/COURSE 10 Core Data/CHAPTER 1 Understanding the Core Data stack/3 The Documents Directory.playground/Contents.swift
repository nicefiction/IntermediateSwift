import Foundation
import CoreData


/**
 `3 The Documents Directory`
 INTRO — Before we start using our stack ,
 we need to create a destination on the user's device to store the data .
 In this video , we explore the role of the documents directory .
 */
/**
 As always , let's open up Xcode ,
 and use the `Single View Application template` to create our project .
 Name the project ToDoList .
 There are two ways we can go about using this project .
 First , we can let Xcode generate all the Core Data related code for us ,
 or we can add things manually .
 If we check this box , Xcode is going to do the work for us ,
 but we are going to leave this unchecked .
 By requiring that
 you write out every line of code
 to get the stack setup ,
 you will know way more about the stack than by just reading the code .
 So , make sure you have this box unchecked .
 Okay , next ,
 let’s add a new file to the project .
 So , RIGHT click , New File , this is going to be a Swift file ,
 and we are going to name this `CoreDataStack` .
 When we discussed how the stack looks like in the last video ,
 
 `Managed Object Context`
    `|`
 `Persistent Store Coordinator`
    `|`
 `Persistent Store`
 
 we said that the model layer is persistent — or saved — to a SQL lite database
 somewhere in the app's funnel system .
 So , the first thing that we need to do , is ,
 create that location in the file system .
 Let's create a class here as our `Core Data object `.
 We are going to encapsulate all the Core Data related functionality
 in the `CoreDataStack.swift file` :
 
 `class CoreDataStack {}`
 
 Every app in iOS exists inside a sandbox ,
 which is an environment that provides
 limited access to the operating system .
 Inside an app's sandbox ,
 it has access to a file system and a series of containers .
 Each container has a specific role within an app :
 
 (`1`) So , first is the `bundle container` .
 We have talked about the application's bundle before .
 This is where the app binary is stored
 along with any resources used.
 
 Other than the bundle container ,
 we have (`2`) a `data container`
 that contains data used by the application and the user .
 The `data container` is further divided into a number of directories
 that the app uses to organise data .
 The `documents directory` is the one we care about here .
 Typically
 we store user generated content in the `documents directory` .
 This means that we can persist our data in here .
 The `documents directory` is backed up either to `iCloud` or `iTunes`
 depending upon how you back up your phone .
 And by saving the database in here
 we ensure that it is always backed up .
 So , let’s create a `lazy stored property`
 that maintains a reference to this location via a `URL` :
*/

class CoreDataStack {
    
    // Creates a destination to store the data :
    private(set) lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,
                                            in : FileManager.SearchPathDomainMask.userDomainMask)
        
        let endIndex = urls.index(before : urls.endIndex)
        
        return urls[endIndex]
    }()
}

/**
 To the `lazy stored property`
 we assign our usual pattern of an immediately executing `closure` .
 
 `NOTE` :
 Remember that the `URL` type that we are using here
 — like the one we have used in the context of networking —
 stores any type of `URL` , including one that refers to a location on disk .
 
 This `lazy property` is assigned a `closure` ,
 and we are going to execute it immediately
 in order to get access to that `URL` .
 The `class` that we are going to use
 to program the file system
 is called `FileManager` :

 `FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,`
                          `in : FileManager.SearchPathDomainMask.userDomainMask)`
 
 Using `FileManager`
 we are going to retrieve an array of `urls`
 that specifies the location of the documents directory .
 First
 we get the `default` file manager
 that pertains to the file system for this app ,
 and from there
 we are going to ask for `urls`.
 And in that path ,
 we'll say we are looking for the `.documentDirectory` — which is an `enum` ,
 
 `FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,`
                          `in : FileManager.SearchPathDomainMask.userDomainMask)`
 
 The second argument is a `.userDomainMask` ,
 This instructs the `FileManager` in which file system to look
 for the specified directory .
 And this is also enum ,
 
 `FileManager.SearchPathDomainMask.userDomainMask`
 
 So , this specifies that we look in the user's home directory inside of this app .
 
 `NOTE`:
 Check the documentation to refer to other places that you can search .
 
 Okay , ...
 
 `lazy var applicationDocumentsDirectory: URL = {`
     
     let urls = FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,
                                         in : .userDomainMask)
 `}()` // ERROR : Missing return in a closure expected to return 'URL'
 
 ... so this method now returns an array of URLs .
 The directories in the array are ordered
 according to the order of the `.userDomainMask constants` ,
 with items in the user domain first
 and items in the system domain last .
 The URL we are looking for
 is at the very last position in the array .
 So , let's return that .
 So , first , we'll get that `endIndex` :
 
 `lazy var applicationDocumentsDirectory: URL = {`
     
     let urls = FileManager.default.urls(for : FileManager.SearchPathDirectory.documentDirectory ,
                                         in : FileManager.SearchPathDomainMask.userDomainMask)
     
     let endIndex = urls.index(before : urls.endIndex)
     
     return urls[endIndex]
 `}()`
 
 I don't like using values — like numbers — directly ,
 so instead we are going to just traverse the index using a few properties .
 So , `endIndex` returns the very last index after the last item .
 So , we are going to say
 return the index before that one ,
 
 `let endIndex = urls.index(before : urls.endIndex)`
 
 And this is an alternative way
 instead of (`A`) using numbers
 or (`B`) the `count` property and subtraction .
 
 `return urls[urls.count - 1] // OLIVIER`
 
 So , if the array has 5 items ,
 the highest valid subscript or index is 4 .
 And the index would be 5 here .
 And then we are going to use that value to return 1 less than that .
 All right , now that we have the `endIndex`
 we can return the right URL ,
 
 `return urls[endIndex]`
 
 
 
 Okay , step one , we have a place to store our database .
 Let's move on to our next step ,
 the `Managed Object Model` in the next video .
 */
