import Foundation


/**
 `2 Linked Lists`
 INTRO — To understand the flexibility offered by generic types
 we are going to create a data structure
 known as a `linked list` .
 Linked lists are similar to arrays on the surface
 but the differences in implementation make them
 two uniquely useful structures .
 In this video ,
 we will use generics
 to create a data structure
 that can be used to store any underlying data .
 */
/**
 We have worked with arrays several times since we started learning how to code .
 And as a collection type
 arrays have served us well ,
 but there are times
 when we need different data structures for different purposes .
 With an array
 we have a single data structure to hold and have data .
 If this Array holds a large amount of data
 and we have to mutate the Array by either deleting or inserting elements .
 We have to conduct several move operations
 so that we maintain the array’s basic properties .
 In such cases
 it would be better to have a collection
 where each item is an individual element
 and each element simply knows about the next element _in order_ .
 This is what a `linked list` is ,
 A linked list is sequence of data items
 that are connected to each other
 through links .
 Each item in the sequence is referred to as a `node` .
 Each node contains the data that we want to store .
 There are two types of linked lists :
 `( 1 ) a singly linked list`
 where each node only has a reference or knows about the next node ,
 and `( 2 ) a doubly linked list`
 for each node knows about both the previous and the next node .
 Now in addition ,
 we need to keep track of where the `node` — or the list — begins , and ends .
 This is also called the `head` and `tail` of the list .
 
 `linked lists` are particularly useful when we mutate large datasets .
 With an Array , if we removed an element
 we'd have to move every element after it into the previous spot .
 With a linked list however ,
 all we need to do , is ,
 modify the references on a few nodes .
 
 Okay , so let's build one .
 Since a linked list is made up of individual nodes ,
 let's start by defining a node :
 */
// Creates an individual node :
class LinkedListNode<Key> {
    
    let key: Key
    var next: LinkedListNode?
    weak var previous: LinkedListNode?
    
    
    init(key: Key) {
        
        self.key = key
    }
}
/**
 To define a generic type , we define it just like we normally do .
 So here we create a class and we call this LinkedList .
 After the class name — just like with a function — we define the type parameters .
 We have a single type parameter , and we call it `Key` .
 Like arrays , we want our custom structure to be typed
 in that we want all nodes to contain the same type of data .
 `<Key>` here , is the type parameter that , once substituted ,
 defines the type of data our linked list can contain .
 In the body of this class , we add a few stored properties .
 First ,
 a property named `key` to hold onto our data :
 `let key: Key`
 And again ,
 the parameter here is `Key` , which is the type parameter we defined .
 We make this stored property a constant
 so that our data can't be mutated .
 
 Next is a reference to the next node :
 `var next: LinkedListNode?`
 This is also of type `LinkedListNode` .
 This stored property is a variable
 because in the event of mutation
 these pointers — or references — need to be changed .
 And because at the end of the list
 — `next` doesn’t mean anything —
 we mark this property as optional .
 
 Now , doubly linked lists are far more interesting ,
 so let's add a reference to the previous node
 by adding a stored property named `previous` ,
 `weak var previous: LinkedListNode?`
 We are making the stored property
 optional
 because at the head of the list ,
 `previous` doesn't mean anything , and we'd like to set it to `nil` .
 It is a variable ,
 so that we can mutate these references if nodes are added or removed .
 We need to make an additional consideration here :
 Given the nodes A and B ,
 if B is assigned to the `next` property of A ,
 and A is assigned to the `previous` property in B ,
 With both of these being strong relationships ,
 we have a _reference cycle_ .
 So we need to make the `previous` stored property `weak` .
 This is essentially the basic structure of a node :
 
 `class LinkedListNode<Key> {`
 
    `let key: Key`
    `var next: LinkedListNode?`
    `weak var previous: LinkedListNode?`
 
 
    `init(key: Key) {`
 
        `self.key = key`
    `}`
 `}`
 
 Now that we have modelled an individual node ,
 let's tackle the entire list by defining a new class :
 */
// Creates a list of nodes :
class LinkedList<Element> {
    
    typealias Node = LinkedListNode<Element>
    
    
    private var head: Node?
    
    
    var first: Node? { return head }
    
    
    var last: Node? {
        
        if var _node = head {
            
            while _node.next != nil { _node = _node.next! }
            
            return _node
        } else {
            
            return nil
        }
    }
}
/**
 This class has a single type parameter — `Element` .
 `class LinkedList<Element> { ... }`
 We could have named this `Key` as well
 but `Element` mimics the naming choices across built in collection types .
 A linked list only holds a reference to the first node in the list
 — since this first node then references the next node , and the next node , and so on ,
 we only need a single stored property to hang onto that first node .
 This node is going to be of type `LinkedListNode` , with the generic type specified .
 But we don't want to write `LinkedListNode` every single time , so ,
 let’s define a `typealias` :
 `typealias Node = LinkedListNode<Element>`
 We need to specify or substitute a type for the generic type parameter .
 But because we don't have one in here yet ,
 `class LinkedList<Element> { ... }`
 we are going to substitute `<Element>` .
 `Element` isn't a specific type either , but that is okay , because this satisfies the compiler .
 When we eventually specify a more concrete type in place of `Element` ,
 this will cascade down to key for each node .
 `typealias Node = LinkedListNode<Element>`
 We don't want to expose the actual node to the user of the list .
 So we store it in a private stored property :
 `private var head: Node?`
 Think of it this way .
 You just simply access keys and values in a Dictionary , or items in the Array ,
 you don't actually know how the underlying data is stored structurally .
 So here
 ``private var head: Node?``
 we have the top level node ,
 and we made it optional
 so that we can have an empty list if we want — just like an empty Array .
 Since this is private , how do we interact with it ?
 Well , first we define a computed property to refer to the head of the node :
 `var first: Node? { return head }`
 Since this is a computed property that simply returns a value ,
 we can guarantee that the node cannot be mutated outside directly .
 This computed property is an optional as well .
 And in the case of `nil`
 our list is empty .
 `NOTE` :
 You could define an additional computed property `isEmpty`
 that returns a boolean value .
 That would save the user from having to perform `nil` checks every time .
 
 Okay , what about the last node in the list ?
 — The _tail_ of the list , so to speak .
 There are two ways we can do this :
 ( 1 ) Just like we are maintaining a _permanent reference_ to the _head_ ,
 we can maintain a _permanent reference_ to the _tail_
 through a stored property .
 This is the easiest way .
 ( 2 ) The second way is to add another computed property
 that traverses the entire list to the end
 and returns the last one .
 Since the `next` stored property having a value of `nil` means
 there isn't a `next` node , we keep traversing until we hit `nil`
 and that means we have got the final node .
 This method can get computationally expensive for long lists . So , in reality ,
 we wouldn't do it this way . We are going to go that route
 because then our subsequent operations
 will be easier to define for the sake of this example .
 We define `last` as a computed property
 that — again — returns an optional `Node` :
 
 `var last: Node? {`
     
     if var _node = head {
         
         while _node.next != nil { _node = _node.next! }
         
         return _node
     } else {
         
         return nil
     }
 `}`
 
 First we'll check that there actually is a node assigned to `head` :
 `if var _node = head { ... }`
 `NOTE` `: You might not have seen this before
 — `if var` — but it is basically `if let` . Except ,
 we are assigning this unwrapped `head` value to a _variable_
 so that we can mutate it if we want .
 
 If we don't have anything assigned to head
 — when this `if var` comes up with `nil` —
 then obviously , we don't have a tail either
 so , in that case , we return `nil` in the `else` statement .
 Inside the `if` statement we are going to use a `while` loop
 to keep traversing the list by inspecting the `next` property :
 `while _node.next != nil { _node = _node.next! }`
 If it is not `nil` ,
 that means there is a subsequent node
 and we'll assign that node back to the `_node` variable .
 `_node = _node.next!`
 So ,
 `_node` right now is the head .
 So ,
 while the `next` property is not `nil`
 that means that there is a `next` node .
 So ,
 grab that `next` one ,
 `_node.next!`
 and assign it back to the node property — the node variable .
 `_node = _node.next!`
 When this loop finishes ,
 the node assigned to the variable
 is the last one . So down here
 — when this goes through and finishes —
 `while _node.next != nil { _node = _node.next! }`
 it’ll hit the last node that is `nil` ,
 and then exit the loop .
 And that means
 `_node` at that point ,
 is the very last node .
 So we can say `return _node` ,
 
 `if var _node = head {`
 
    `while _node.next != nil { _node = _node.next! }`
 
    `return _node`
 `} else {`
 
    `return nil`
 `}`
 
 Okay , let's see what our list looks like so far .
 To create an instance of a generic type ,
 we specify a more concrete type in place of our type parameter
 — just like we did with the function . So we'll say ,
 */
let list = LinkedList<String>()
/**
 For the generic type parameter ,
 we specify a more concrete type of String .
 Now we have a linked list that can contain Strings .
 This linked list doesn't do anything though ,
 and while this isn't the point of the course ,
 let's go ahead ,
 and add a few operations to the data structure ,
 so you can get an idea of how it works in the next video .
 */
