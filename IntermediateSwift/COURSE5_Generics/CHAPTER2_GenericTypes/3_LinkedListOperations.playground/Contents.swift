import Foundation


/**
 `3 Linked List Operations`
 INTRO — Let's add a few operations to our implementation of linked list .
 While this won't augment our understanding of generics ,
 this is a good lesson on
 how to build custom data structures
 for different uses .
 */
/**
 To make our data structures as robust as the `Array` type ,
 we'd have to do a lot of work . These range from operations
 describing
 ( 1 ) the addition of data — append and insert —
 ( 2 ) querying the data — getting data from a particular index value for example — ,
 ( 3 ) sub-scripting ,
 ( 4 ) counting the number of nodes ,
 ( 5 ) deleting data all at once from the head , tail , or a particular index ,
 and finally , ( 6 ) transforming the data inside the data structure .
 Obviously , we can't really do all of that — or even a major subset of it .
 So , we are just going to take a look at three operations ,
 ( A ) appending ,
 ( B ) retrieving , and
 ( C ) inserting .
 Let's start with append :
 */
class LinkedListNode<Key> {
    
    let key: Key
    var next: LinkedListNode?
    weak var previous: LinkedListNode?
    
    
    init(key: Key) { self.key = key }
}


class LinkedList<Element>: CustomStringConvertible {
    
    
    typealias Node = LinkedListNode<Element>
    
    /* MARK: PROPERTIES
     * * * * * * * * * */
    
    private var head: Node?
    
    
    
    /* MARK: COMPUTED PROPERTIES
     * * * * * * * * * * * * * */
    
    var description: String {
        
        var output = "["
        var node = head
        
        while node != nil {
            
            output += "\(node!.key)"
            node = node!.next
            
            if node != nil { output += ", " }
        }
        
        return output + "]"
    }
    
    
    var first: Node? { return head }
    
    
    var last: Node? {
        
        if var _node = head {
            
            while _node.next != nil { _node = _node.next! }
            
            return _node
        } else {
            return nil
        }
    }
    
    
    
    /* MARK: METHODS
     * * * * * * * */
    
    func append(_ value: Element) {
        
        let new = Node(key : value)
        
        
        if
            let _node = last {
            
            _node.next = new
            new.previous = _node
        } else {
            head = new
        }
    }
    
    
    func node(atIndex index: Int)
    -> Node {
        
        let node = head
        var counter: Int = 0
        
        while node != nil {
            if counter == index { return node! }
            
            counter += 1
            node?.next
        }
        
        fatalError("Index out of bounds .")
    }
    
    
    func insert(value: Element ,
                at index: Int) {
        
        let nodeAtIndex = node(atIndex : index)
        let nodeBeforeIndex = nodeAtIndex.previous
        let new = Node(key : value)
        
        new.previous = nodeBeforeIndex
        new.next = nodeAtIndex
        
        nodeAtIndex.previous = new
        nodeBeforeIndex?.next = new
        
        if nodeBeforeIndex == nil { head = new }
    }
}
/**
 Appending — like in an array — is just going to add a new node to the end of the list .
 We call this method append( ) , and it takes a value to append :
 `func append(_ value: Element) { ... }`
 This value is of type `Element` because that is the generic type of our linked list class :
 `class LinkedList<Element> { ... }`
 The first thing we need to do , is ,
 create a node that contains this value as data .
 `let new = Node(key : value)`
 The `Node` class has an initialiser that takes a key and will pass in the value .
 `init(key: Key) { self.key = key }`
 `NOTE` : The `key` value naming can be confusing . It is not the same way as a Dictionary .
 It is typically convention to name that property `key` in the node that contains the value that we want to store .
 
 Next ,
 we need to add this node to the end of the list .
 To get the last node in the list ,
 we query the last property we wrote .
 But since this is an optional ,
 we need to unwrap it :
 `if let _node = last { ... }`
 Now we have the unwrapped `_node` . But this is an _if let statement_ ,
 so there is obviously an _else case_ .
 The else case here
 `head = new`
 means that we don't have a last node
 — which also means that we don't have a head . So ,
 if we hit the else case ,
 we assign this new node that we are creating as the head :
 
 `if`
    `let _node = last {`
 
        `_node.next = new`
        `new.previous = _node`
    ` } else {`
        `head = new`
    `}`
 
 Inside the if let statement ,
 the body is really simple .
 The new node is going to be the `_node` .
 And the current `_node` is going to be one before the last .
 So , we first assign the `new` node to the next property of the current `_node` :
 `_node.next = new`
 And then assign what was previously the current `_node`
 to the previous property on the `new` node :
 `new.previous = _node`
 `NOTE` : If we were maintaining a reference to the `_node` — or the _tail_ —
 as a stored property ,
 we would have had to update this as well ,
 but since our code just traverses the entire list .
 We don't have to make any changes ,
 we'll always get the `_node` .
 
 Okay , so that is the `append( )` method .
 */


/**
 Next up is `node(atIndex)` .
 And we are going to use this method
 to retrieve a value from our linked list :
 
`func node(atIndex index: Int)`
 `-> Node {`
     
     let node = head
     var counter: Int = 0
     
     while node != nil {
         if counter == index { return node! }
         
         counter += 1
         node?.next
     }
     
    `fatalError("Index out of bounds .")`
 `}`
 
 For the return value of the `node(atIndex)` method ,
 there are two ways that we can approach this :
 ( 1 ) In a Dictionary , if a key doesn't exist , we return `nil` .
 ( 2 ) In an Array , if the index is out of bounds , we crash .
 Since we are using indexes here , we mimic the behaviour of Arrays .
 We'll keep it consistent , and set the return type to `Node` — not an optional one .
 First
 we assign the `head` of the list to a variable named `node` :
`let node = head`
 Next ,
 we are going to create a variable to keep track of the current iteration
 — or , which node we are on — as we traverse the list . So I say
 `var counter: Int = 0`
 Because our linked list doesn't have a concept of an index on its own .
 We have to do a bit of work ourselves .
 Next ,
 we traverse the list ,
 and we do that by using a `while` loop
 and checking if the current node is not `nil `:
 `while node != nil { ... }`
 If the current node is not `nil`
 — and at first , remember that `node` refers to the `head` of the list —
 then we check to see if the index matches the value of the counter :
 `if counter == index { ... }`
 If it does ,
 that means we are at the node that we are looking for ,
 so we can return it :
 `return node!`
 We return the node and we unwrap this .
 
 
 So , let’s just walk through this : 
 
 `STEP 1` : First ,
 we assign the very `head` of the list
 to a variable named `node` ,
 and we set the `counter` to `0` :
 `let node = head`
 `let counter = 0`
 
 `STEP 2` : Then we are going to say ,
 is the current node `nil` ?
 `while node != nil { ... }`
 Well ,  if it is not ,
 then we step into the body of the `while` loop :
 `while node != nil {`
    `if counter == index  { return node! }`
 
    `counter += 1`
    `node = node?.next`
 `}`
 
 If we have passed an `index` value of `0` ,
 `func node(atIndex : 0)`
 and the `counter` is at `0` ,
 that means that we are at the node that we are looking for ,
 so go ahead return it .
 `if counter == index  { return node! }`
 If it doesn't match ,
 then we need to go to the next node .
 So , we’ll increase the counter by 1
 `counter += 1`
 and then we'll go to the next node
 and we do that by assigning back to this node variable the next node in the list ,
 `node = node?.next`
 In this way ,
 our `while` loop will keep going to the `next` node
 until the `index` and the `counter` match .
 
 What if we exit the `while` loop and we have never matched ? So ,
 what if there are two items in our list , and the `index` is `3` ?
 Then , we are going to hit `nil` here
 `while node != nil { ... }`
 and exit our `while` loop ,
 so at the bottom ,
 we are going to mimic the behaviour of the Array
 and we will crash by saying
 `fatalError("Index out of bounds .")`
 And that is how we retrieve a value .
 */


/**
 Let's define our final method
 and that is inserting a new node at a given index value :
 
 `func insert(value: Element ,`
             `at index: Int) {`
     
     `let nodeAtIndex = node(atIndex : index)`
     `let nodeBeforeIndex = nodeAtIndex.previous`
     `let new = Node(key : value)`
     
     `new.previous = nodeBeforeIndex`
     `new.next = nodeAtIndex`
     
     `nodeAtIndex.previous = new`
     `nodeBeforeIndex?.next = new`
     
     `if nodeBeforeIndex == nil { head = new }`
 `}`
 
 We call this method `insert( )` ,
 it takes a `value` that we want to insert .
 Because remember that
 when you are actually interacting with this list ,
 you don't really want to care about nodes .
 When you are interacting with an Array ,
 you don't care about how the data is stored .
 You just want the value at a particular index . Similarly ,
 we are going to take an element — or a value — to insert :
 `func insert(value: Element , at index: Int) { ... }`
 The logic is fairly straightforward ,
 we are taking an `Element` to insert and the `index` position .
 So first , we retrieve the `Element` currently at that `index` value
 — because remember , we are inserting .
 We just defined the method to do this in a single line of code :
 `let nodeAtIndex = node(atIndex : index)`
 Now that we have the node at that index ,
 we also need a reference to node before this one . So we'll say ,
 `let nodeBeforeIndex = nodeAtIndex.previous`
 Since we are going to be inserting this new node
 between the two — OLIVIER : `nodeAtIndex` and `noteBeforeIndex` —
 we need to rewire the `next` and `previous` pointers — or references .
 The rest from here is pretty simple .
 We are going to create a new node ,
 `let new = Node(key : value)`
 The initialiser takes a `key`
 and we'll provide the `value` argument — OLIVIER : from the `insert( )` method .
 The new node’s previous value — or the node before this one — is `nodeBeforeIndex` ,
 `new.previous = nodeBeforeIndex`
 and its next node
 `new.next = nodeAtIndex`
 is the node that used to be at this index spot ,
 `let nodeAtIndex = node(atIndex : index)`
 Now the new node sits in between the two , which is exactly what we want .
 But we also need to reconfigure the pointers on the two nodes on either side of it ,
 which is relatively straightforward .
 So we'll say `nodeAtIndex.previous` is now the `new` node :
 `nodeAtIndex.previous = new`
 Before, it used to be nodeBeforeIndex ,
 and then finally,
 `nodeBeforeIndex?.next = new`
 
 There is one small edge case .
 What if `nodeBeforeIndex` is `nil` ?
 For example ,
 if we have a single element in the list and we insert at index `0` ,
 `nodeBeforeIndex` is `nil` in that point . In the event that happens ,
 that means our `new` node is the head of the list and we need to account for that .
 So we'll say ,
 `if nodeBeforeIndex == nil { head = new }`
 If it is `nil` up over here , 
 `let nodeBeforeIndex = nodeAtIndex.`previous`
 that is not going to cause any errors because these ...
 
 _let nodeBeforeIndex = nodeAtIndex._`previous`
 
 _new._`previous`_= nodeBeforeIndex_
 
 _new._`next`_= nodeAtIndex_
 
 _nodeAtIndex._`previous`_= new_
 
 _nodeBeforeIndex?._`next`_= new_
 
 ... are all optional properties as you can see ,
 so you'll get `nil`
 and it will silently fail .
 
 
 And with that ,
 we are done with our simple implementation of a linked list .
 Let's see this in action .
 */
let list = LinkedList<String>()
/**
 Let's append to that :
 */
list.append("Dorothy")
list.append("Gale")
list.insert(value : "17", at : 1)
/**
 And that works .
 So our operations work
 — or we think it does —
 because there is no way to verify .
 Because the result area [ of the Playground ] simply says `LinkedList<String>` ,
 which is the name of the class .
 Let's improve that .
 The information provided in the results area is obtained by the Playground
 calling description on an object .
 So we need to ( 1 ) conform to `CustomStringConvertible`
 and ( 2 ) provide an implementation for the `description` property .
 `NOTE` : In addition to improving usability ,
 I also want to show you that a generic type works more or less like a regular type
 — not always , but in most cases they do .
 Where in a regular class ,
 to conform to a protocol ,
 we add a colon after the class name ,
 and specify the protocol .
 With a generic type , we do the same thing ,
 but instead of [ OLIVIER : adding a colon ] right after the name ,
 we do it after the angle brackets :
 `class LinkedList<Element>: CustomStringConvertible { ... }`
 To conform to the `CustomStringConvertible` protocol
 I need to provide an implementation for the `description` property .
 And I am going to copy-paste this in :
 
 `var description: String {`
 
    `var output = "["`
    `var node = head`
 
    `while node != nil {`
 
        `output += "\(node!.key)"`
        `node = node!.next`
 
        `if node != nil { output += ", " }`
    `}`
 
    `return output + "]"`
 `}`
 
 And when I do that , [OLIVIER : Run the Playground]
 there we go .
 You can see that our list works just as expected :
 We start off with an empty linked list .
 We add `"Dorothy"` ,
 `list.append("Dorothy")`
 and that is the first item now in our list .
 `NOTICE` that it behaves like an Array . We don't really care .
 The underlying data structure is different .
 All we are doing , is ,
 inserting , appending , and removing .
 We have gone ahead and added `"Gale"` .
 `list.append("Gale")`
 You see that it is added after `"Dorothy"` ,
 and then when we insert `"17"`
 `list.insert(value : "17", at : 1)`
 it inserts it between the two — `"Dorothy"` and `"17"`
 — and rewires those connections .
 We can also retrieve the value from the list if we want it ,
 */
list.node(atIndex : 1).key


/**
 There is one final thing I want to show you about generic types .
 We created a class here
 `class LinkedList<Element>: CustomStringConvertible { ... }`
 but you can create a generic struct
 — like an Array , and Enum —
 as you saw in the case of optionals as well .
 With generic classes ,
 you can subclass a generic class , but ,
 a neat trick is
 that you can specify a concrete type of the generic base class .
 Here is what I mean ,
 so right now ,
 our linked list allowed us to specify any type as the underlying data
 by substituting it for the generic type parameter ,
 `class LinkedList<Element>: CustomStringConvertible { ... }`
 which is great,
 but every time we create the instance
 we have to specify what the type is .
 `let list = LinkedList<String>()`
 We can change how we construct these instances
 so that the compiler can infer it . For example ,
 we don't have to always create an array using the generic type signature
 and then creating an instance .
 We have annotated the type
 and the compiler knows what we want to do ,
 but suppose that 90% of my use cases are linked lists containing integers .
 We want to make it easier to create them quickly .
 We can create a subclass of linked list .
 We'll call this , `LinkedIntegers` and we'll inherit from `LinkedList` :
 */
class LinkedIntegers: LinkedList<Int> {}
/**
 Remember that when you create an instance of `LinkedList`
 you need to provide a more concrete type
 and we directly say `Int` is the type that we want .
 Now , instances of `LinkedIntegers`
 always use `Int` as the concrete type .
 And we don't have to specify what the type parameter is
 when creating an instance ,
 because that is already specified here .
 _class LinkedIntegers: LinkedList_`<Int>`_{ }_
 So , we’ll say
 */
let integerList = LinkedIntegers() // []
/**
 Without having to provide a type specification ,
 I can just create an instance .
 And now , if I were to call
 */
integerList.append(2) // [2]
/**
 We get all the same behaviour with a more specific type .
 Okay . Hopefully you had fun building that
 and that should give you a good idea of
 how generics are used
 to create custom types
 — particularly data structures .
 Hopefully you got a good glimpse of
 how Arrays and Dictionaries work under the hood .
 
 We still have a good bit to learn though ,
 so on to the next video .
 */

print("hello world")
