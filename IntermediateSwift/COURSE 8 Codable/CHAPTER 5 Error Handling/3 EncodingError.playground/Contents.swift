import Foundation


/**
 `3 EncodingError`
 INTRO — In this video , let’s wrap up by taking a look at
 errors thrown during an encoding operation .
 */
/**
 In the last video ,
 we looked at `DecodingError` ,
 and how the type is used .
 `EncodingError` is even simpler .
 So , if you go to _Help > Developer Documentation_ ,
 and pull up the docs for `EncodingError` ,
 you will see that there is just one case defined , `invalidValue` ,
 
 `case invalidValue(Any, EncodingError.Context)`
 `// An indication that an encoder or its containers could not encode the given value.`
 
 `struct EncodingError.Context`
 `// The context in which the error occurred.`
 
 The error is thrown
 when the `encoder` cannot encode a given value .
 This enum member carries two associated values ,
 (`1`) the first being the value we tried to encode of type `Any` ,
 so you might have to cast it .
 (`2`) And the second is a `Context` object .
 And this time it is of type `EncodingError.Context` .
 But it is essentially identical to the `Context` type nested in `DecodingError` ,
 so we don't really need to go into it . You know exactly what it does .
 
 
 
 And that is all I have for you .
 Hopefully that should leave you with all the information you need
 to use `Codable` effectively in your code .
 To wrap things up ,
 I have included a document after this
 that touches on some additional topics that are good to know ,
 but advanced enough
 that you probably won't need to incorporate it into your code any time soon .
 By advanced , I don't mean technically advanced .
 More like , it is an edge case .
 You won't really run into often , but it is good to know .  
 Anyway , as always , have fun coding .
 */
