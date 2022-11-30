# JSON Library

## Description

This Library will provides the possibility to serialize and deserialize JSON Files.

## Install this package

Enter:

```cli
apax add @simatic-ax/json
```

> to install this package you need to login into the GitHub registry. You'll find more information [here](https://github.com/simatic-ax/.github/blob/main/docs/personalaccesstoken.md)

## Namespace

```sh
Simatic.Ax.Json;
```

## Deserializing

Use the _Deserializer_ class to deserialize JSON documents and parse values from the document.

### Restrictions

In the current version we have several restrictions regarding the handling of JSON files.

1. The JSON File must be in the form of a ARRAY [] OF CHAR. Read more in the _Workflow_ part.

2. A valid JSON file ist expected, since there is no validation.

3. ### Forbidden characters in keys and values

    |||
    |-|-|
    |,| comma|
    |"| quotation marks|
    |:| colon|
    |[ ] | square brackets|
    |{ } | brackets|
    |||

4. The following Datatypes can be parsed:
    |||
    |-|-|
    | STRING |
    | SINT |
    | INT |
    | DINT |
    | LINT |
    | USINT |
    | UINT |
    | UDINT |
    | ULINT |
    |||

## Workflow

### Pre-requirements

1. You need to use the library _Simatic.Ax.Conversion_ and _Simatic.Ax.Json_;
2. The deserializer currently expects an _ARRAY[0..999] OF CHAR_ as a buffer. If your JSON File is a STRING you can use the _Simatic.Ax.Conversion_ as shown in the example below.
3. Finally you must set the buffer for the deserializer with the _SetBuffer_ method. The buffer is expected as a reference.

### Get values

Use the _TryParse_ method to get values that match your provided STRING key . If you want to get values of nested elements you must instead provide a ARRAY [X] OF STRING, with a key for each nested layer.

The datatype _TryParse_ will return depends on the datatype of the value you provide.

If the parsing was succesfull, _TryParse_ returns TRUE, if either the key could not be found or the datatype could not be parsed it returns FALSE.
In the case of an unsucesfull parsing, the output value will be '' in case of STRING and 0 in case of any number.

```iec-st
USING Simatic.Ax.Json;
USING Simatic.Ax.Conversion;

### Code Example

[...]
VAR PUBLIC
    //pre requirements
    deserializer : Deserializer;
    buffer : ARRAY[0..999] OF CHAR;
    JSON_File: STRING := '{ "key 1" : 123, 'key 1' : {'nestedkey 1' : "456", 'nestedkey 2': {'nestedInNested': 789}}}'; //example of your JSON file
    
    //optional conversion information
    arrayLength:= DINT;

    //deserializing
    parsingWasSuccessfull: BOOL;

    key1: STRING := 'key 1'; //example for a single key
    value1: INT;

    keyArray1: ARRAY [0..1] OF STRING:= ['key 2', 'nestedkey 1']; //example for getting values of a nested element
    value2: STRING; //change the datatype to parse different datatypes, e.g. INT

    keyArray2: ARRAY [0..1] OF STRING:= ['key 2', 'nestedkey 2', 'nestedInNested'];
    value3: DINT;

END_VAR

arrayLength := Strings.ToArray(str := JSON_File, arr := buffer); //Step 2: converts your JSON file string to the required _Array [0.999] OF CHAR_ format
deserializer.SetBuffer(REF(buffer));

// parsingWasSuccessfull is true, value1 is 123
parsingWasSuccessfull:= TryParse(key1, value1);

// parsingWasSuccessfull is true, value2 is 456
parsingWasSuccessfull:= TryParse(keyArray1, value2);

// parsingWasSuccessfull is true, value3 is 789
parsingWasSuccessfull:= TryParse(keyArray2, value3);

// parsingWasSuccessfull is false, value1 is 0
parsingWasSuccessfull:= TryParse('not a key', value3);

[...]
```

### Methods

|||
|-|-|
|SetBuffer(REF_TO ARRAY[0..999] OF CHAR);| Provides the JSON file to the deserializer|
|TryParse(input: key (STRING), output: value) : BOOL| Returns false when parsing not succesfull and provides the value. The method is overloaded and accepts different data types. |
|TryParse(input: key(ARRAY OF STRING), output: value) : BOOL| Returns false when parsing not succesfull and provides the value. The method is overloaded and accepts different data types. The key array is used to access values in nested elements. |
|||

### Duplicate keys

The JSON Format allows a user to have duplicate keys in his json document, e.g.

```JSON
{
"key" : "my value",
"key" : 1234 
}
```

However, the norm does not define, how duplicate keys should be processed. In case of a duplicate key, this library will alwys try to parse the first key and ignore the second one.

## Serializing

## [JsonDocument](docs/JsonDocument.md)

## [JsonObject](docs/JsonObject.md)

## Examples

### Example ho to use the JSON library

This example shows in how to create, serialize, parse and reset a JSON document.

```iec-st
USING Simatic.Ax.Conversion;
USING Simatic.Ax.Json;

CONFIGURATION MyConfiguration
    TASK Main (INTERVAL := T#100ms, PRIORITY := 1);
    PROGRAM P1 WITH Main: MyProgram;
    VAR_GLOBAL
        SerializedDocument : STRING;
        ParsedValue : DINT;
    END_VAR
END_CONFIGURATION

PROGRAM MyProgram
    VAR_EXTERNAL
        SerializedDocument : STRING;
        ParsedValue : DINT;
    END_VAR
    VAR
        doc : JsonDocument;
        docBuffer : ARRAY[0..200] OF CHAR;
        myBoolean : JsonBoolean := (Value := TRUE, Key := 'myBoolean');
        myInt : JsonInt := (Value := 1234, Key := 'myInt');
        myDint : JsonDInt := (Value := DINT#12345678, Key := 'myDint');
        myObject : JsonObject := (Key := 'myObject');
        deserializer : Deserializer;
        keyFound : BOOL;
        dintValue : DINT;
        keyArray : ARRAY[0..1] OF STRING := ['myObject', 'myDint'];
        step : Steps;
    END_VAR
    VAR_TEMP
    END_VAR
    CASE step OF
        Steps#CreateDocument2:
            // Create nested JSON document which looks like:
            // {"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}
            myObject.AddElement(myInt);
            myObject.AddElement(myDint);
            doc.AddElement(myBoolean);
            doc.AddElement(myObject);
            step := Steps#SerializeDocument2;
        Steps#SerializeDocument2:
            // Serialize the document {"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}
            doc.buffer := REF(docBuffer);
            doc.Serialize(doc.buffer);
            SerializedDocument := Arrays.ToString(arr := doc.buffer);
            step := Steps#ParseDocument2;
            ;
        Steps#ParseDocument2:
            // Parse Document for the value of the nested key `myObject.myDint` and expect `12345678`
            // Get Values from a nested element
            deserializer.SetBuffer(REF(doc.buffer));
            keyFound := deserializer.TryParse(keyArray, dintValue);
            ParsedValue := dintValue;
            step := Steps#ResetJSonDocument2;
            ;
        Steps#ResetJSonDocument2:
            // ResetJSonDocument 2nd configuration
            doc.Reset();
            step := Steps#CreateDocument2;
            ;
    END_CASE;
END_PROGRAM

TYPE
    Steps : (CreateDocument2, SerializeDocument2, ParseDocument2, ResetJSonDocument2) := CreateDocument2;
END_TYPE
```

### Application Example

A complete application example, you can find here:

[JSON Application Example](https://github.com/simatic-ax/ae-json-library)

## Contribution

Thanks for your interest in contributing. Anybody is free to report bugs, unclear documentation, and other problems regarding this repository in the Issues section or, even better, is free to propose any changes to this repository using Merge Requests.

### Markdownlint-cli

This workspace will be checked by the [markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli) (there is also documented ho to install the tool) tool in the CI workflow automatically.  
To avoid, that the CI workflow fails because of the markdown linter, you can check all markdown files locally by running the markdownlint with:

```sh
markdownlint **/*.md --fix
```

## License and Legal information

Please read the [Legal information](LICENSE.md)
