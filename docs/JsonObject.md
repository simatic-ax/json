# JsonObject

### Definition

Inheritance: AbstractJsonElement-->JsonObject

### Public members
|||
|-|-|
|value : DINT;| Value of this element
|key : STRING  := 'NoKeySet';| Key of this element

### Methods
|||
|-|-|
|ToString() : STRING;| Returns the JSON string of this element|
|GetRootElement() : IJsonElement| Returns root element of the JSON object|
|AddElement(elem : IJsonElement)| Add a new element to the JSON object|
|||
---