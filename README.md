# JSON Library

## Description
This package contains classes to create and parse JSONs as array of CHAR

## About this package
### Install this package

```cli
apax add @simatic-ax/json
```

> to install this package you need to login into the GitHub registry. You'll find more information [here](https://github.com/simatic-ax/.github/blob/main/doc/personalaccesstoken.md) 

### Namespace
```
Simatic.Ax.Json;
```
## JsonDocument

### Definition
Contains the root element of the JSON string

### Methods

|||
|-|-|
|ToString() : STRING;| Returns the JSON string of this element|
|GetRootElement() : IJsonElement| Returns root element of the JSON object|
|AddElement(elem : IJsonElement)| Add a new element to the JSON document|
|Serialize(REF_TO JsonDocument) : BOOL|Creates the JSON string in an ` Array[0..999] of CHAR`
|||

## JsonElements
- [JsonObject](#jsonobject)
- [JsonNumber](#jsonnumber)
- [JsonBoolean](#jsonnumber)

## JsonObject

### Definition

Inheritance: JsonObject-->AbstractJsonElement

### Public members
|||
|-|-|
|key : STRING  := 'NoKeySet';| Key of this element
### Methods
|||
|-|-|
|ToString() : STRING;| Returns the JSON string of this element|
|GetRootElement() : IJsonElement| Returns root element of the JSON object|
|AddElement(elem : IJsonElement)| Add a new element of type `IJsonElement` to the JSON object|
|Serialize(REF_TO JsonDocument) : BOOL|Creates the JSON string in an ` Array[0..999] of CHAR`
|||
---
## JSonNumber
### Available classes

Inheritance: AbstractJsonElement-->JsonNumber-->ConcreteType

|ConcreteType   | Public Member `value` | Public Member `key` |
|-|-|-|
|JsonBool       | value : BOOL          | key : STRING
|JsonDInt       | value : DINT          | key : STRING
|JsonInt        | value : INT           | key : STRING
|JsonLInt       | value : LINT          | key : STRING
|JsonSInt       | value : SINT          | key : STRING
|JsonUSInt      | value : USINT         | key : STRING


### Methods

|||
|-|-|
|ToString() : STRING;| Returns the JSON string of this element
|Serialize(REF_TO JsonDocument) : BOOL|Creates the JSON string in an ` Array[0..999] of CHAR`

## Example
```iec-st
USING Simatic.Ax.Json;
USING AxUnit.Assert;

NAMESPACE Simatic.Ax
    CLASS JsonExample
        VAR PUBLIC
            
        END_VAR
        VAR PROTECTED
            doc : JsonDocument;
            e1 : JsonDoubleInt := (key := 'Element1', value := 1);
            e2 : JsonDoubleInt := (key := 'Element2', value := 2);
            e3 : JsonDoubleInt := (key := 'Element3', value := 3);
            o1 : JsonObject := (key := 'NestedObject');
            
        END_VAR
        
        METHOD PUBLIC Init;
            // Example String:
            // {"Element1": 1, {"Element2": 2, "Element3": 3}}            
            doc.AddElement(e1);
            doc.AddElement(o1);
            o1.AddElement(e2);
            o1.AddElement(e3);
        END_METHOD

        METHOD PUBLIC ToString : STRING
            ToString := doc.ToString();
        END_METHOD
    END_CLASS    
END_NAMESPACE
```

## Contribution

Thanks for your interest in contributing. Anybody is free to report bugs, unclear documentation, and other problems regarding this repository in the Issues section or, even better, is free to propose any changes to this repository using Merge Requests.

## License and Legal information

Please read the [Legal information](LICENSE.md)

