import Foundation


/**
 `COURSE 10`
 `Introduction to Core Data`
 Saving data on your device is a fundamental part of building apps
 and in this course
 we are going to learn
 how to use the Core Data framework
 to persist data between launches
 by building a simple to-do list app .
 We'll also learn
 how to utilise table views
 to display , edit , and delete data by communicating with Core Data .
 
 What you will learn :
 `•` Core Data
 `•` Fetched Results Controller
 `•` Persisted Store Coordinator
 `•` Managed Object Context
 */



/**
 `CHAPTER 1`
 `Understanding the Core Data Stack`
 Core Data is one the most fundamental frameworks in iOS ,
 allowing us to persist data across apps and devices .
 In this stage ,
 we are going to look at
 the many moving parts of a Core Data stack
 and how they work in coordination
 to manage our object graph and save data .
 */



/**
 `1 What is Core Data ?`
 INTRO — Is Core Data the only option we have for saving data ?
 Certainly not , and in this video
 we start by exploring
 the different options for saving simple structured data .
 */
/**
 In this course,
 we are going to take a look at
 Apple's solution for persisting data in our apps .
 This is a fairly advanced topic
 and I expect you to be familiar with the basics of building an iOS app
 including how to use table views .
 If those concepts seem unfamiliar to you , check the prerequisites list ,
 and take those courses before starting this one .
    So , what is core data , and why is it important ?
 Every time we use an app ,
 we don't expect to start all over again from square one .
 If we have input some information or taken some action ,
 we expect to come back to where we left off .
 Essentially , users expect the app to persist , or store , their data .
 Pull out your iPhone if it's near you ,
 and go to the Reminders app .
 Each time you take a note , or set a reminder ,
 that data is stored within the app .
 You can close the app or even restart the device ,
 and the data is stored permanently
 until you delete it yourself .
 There are many ways we can do this ,
 some of which we have explored in previous courses  :
 
 (`1`) Our first option would be to save it to a `plain text file` .
 This could potentially work , but it would be quite rudimentary .
 A reminder is more structured than a simple `String` :
 
 _Structure of a Reminder :_
 _ • Text_
 _ • Due Date_
 _ • Status_
 _ • Priority_
 
 It has text , a due date ,
 and a status — that is , whether it has been completed or not .
 And by saving this information in a plain text format ,
 we would have to parse a `String`
 and extract relevant information out of it every time ,
 and this is error prone and cumbersome .
 
 
 (`2`) In the past , we have worked with `p-lists` .
 If you remember , p-lists offer a more structured way to store simple data ,
 and under the hood they are presented in XML ,
 
 `<plist version="1.0">`
 `<dict>`
     `<key>CFBundleDevelopmentRegion</key>`
     `<string>$(DEVELOPMENT_LANGUAGE)</string>`
     `<key>CFBundleExecutable</key>`
     `<string>$(EXECUTABLE_NAME)</string>`
     `<key>CFBundleIdentifier</key>`
     `<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>`
     `<key>CFBundleInfoDictionaryVersion</key>`
     `<string>6.0</string>`
     `<key>CFBundleName</key>`
     `<string>$(PRODUCT_NAME)</string>`
     `<key>CFBundlePackageType</key>`
     `<string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>`
     `<key>CFBundleShortVersionString</key>`
     `<string>1.0</string>`
     `<key>CFBundleVersion</key>`
     `<string>1</string>`
     `<key>LSRequiresIPhoneOS</key>`
     `<true/>`
     `<key>UIApplicationSceneManifest</key>`
     `<dict>`
         `<key>UIApplicationSupportsMultipleScenes</key>`
         `<true/>`
     `</dict>`
     `<key>UIApplicationSupportsIndirectInputEvents</key>`
     `<true/>`
     `<key>UILaunchScreen</key>`
     `<dict/>`
     `<key>UIRequiredDeviceCapabilities</key>`
     `<array>`
         `<string>armv7</string>`
     `</array>`
     `<key>UISupportedInterfaceOrientations</key>`
     `<array>`
         `<string>UIInterfaceOrientationPortrait</string>`
         `<string>UIInterfaceOrientationLandscapeLeft</string>`
         `<string>UIInterfaceOrientationLandscapeRight</string>`
     `</array>`
     `<key>UISupportedInterfaceOrientations~ipad</key>`
     `<array>`
         `<string>UIInterfaceOrientationPortrait</string>`
         `<string>UIInterfaceOrientationPortraitUpsideDown</string>`
         `<string>UIInterfaceOrientationLandscapeLeft</string>`
         `<string>UIInterfaceOrientationLandscapeRight</string>`
     `</array>`
 `</dict>`
 `</plist>`
 
 Okay ,
 we could try storing all of the reminders in a more structured `XML data file` .
 We could get away with doing this ,
 but there are several drawbacks .
 To read the data ,
 we would have to parse the `XML` ,
 which isn't that bad an operation .
 But inserting and deleting information
 would mean rewriting the entire `XML` file .
 And the biggest drawback though , is , that ,
 with an `XML` file ,
 we really don't have the ability to search for a reminder .
 Okay , so let's cross `XML` off the list .
 
 
 (`3`) A better approach would be to store this data in a `Database` .
 A database is an organised collection of data
 and we would be able to easily _read_ , _write_ , and _delete_ any reminders in our app .
 Moreover , databases make it trivial to search for the data .
 At this point , we haven't had any experience working directly with databases .
 To interact with a database , we use a specialised programming language called `SQL` ,
 
 `SELECT * FROM Friends WHERE First_Name LIKE 'en';`
 
 `SQL` stands for `Structured Query Language` ,
 it is used to write instructions to a variety of different database types .
 There are many different kinds of databases
 — like MySQL , PostgreSQL , SQLite , and so on .
 We could write `SQL` directly to interact with these databases ,
 but if we change the structure or `schema`
 — and we'll get to this term in a bit —
 of our data
 then we’d have to refactor all of our hard coded SQL queries ,
 and that is less than ideal .
 
 
 (`4`) So while all these are good options ,
 we are not going to use them .
 _Why ?_
 Because our last and most convenient option is to use `Core Data` .
 `Core Data` is not a storage solution like a database is .
 Instead , it is both (`A`) a `persistence framework`
 and (`B`) a `Model layer technology` .
 Think of that as a framework
 that hides all the details of
 how objects are stored , updated , read , or deleted .
 We just tell Core Data _what_ we want to persist , and it handles the rest .
 To actually store the data ,
 Core Data uses one of the solutions we talked about earlier ,
 notably a `SQLite database` .
 But , we are not going to worry about those details .
 When programming an iOS app ,
 we mainly use the object oriented paradigm .
 In the case of the Reminders app , each reminder is an object .
 Core Data helps us manage this `object graph` .
 
 
 
 Let's take a break here .
 In the next video ,
 let's look at
 what we mean by `object graph` ,
 and take a look at all the moving parts that Core Data uses
 to persist an object graph to disk .
 */
