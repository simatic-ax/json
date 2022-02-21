USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer

{TestFixture}
CLASS Test_FindValueInBuffer
    VAR protected
        doc : Deserializer;

        key: STRING;
        value: STRING;
        testIndex1: INT;
        testIndex2: INT;
    END_VAR

    {Test}
    Method Public Test_GetValueFromIndex_GetValue        
        VAR
            len: DINT;
        END_VAR

        len:= Strings.ToArray(str := '1234', arr := doc.buffer);

        testIndex1:= 0; testIndex2 := 3;
        value:= doc.GetValueFromIndex(testIndex1, testIndex2);

        Equal('1234', value);
        
    END_Method

    {Test}
    Method Public Test_GetValueFromIndex_GetValue_withSpaces     
        VAR
            len: DINT;
        END_VAR

        len:= Strings.ToArray(str := '    1234    ', arr := doc.buffer);

        testIndex1:= 0; testIndex2 := 10;
        value:= doc.GetValueFromIndex(testIndex1, testIndex2);

        Equal('1234', value);
        
    END_Method

    {Test}
    Method Public Test_GetValueFromIndex_GetValue_withQuotationMarks      
        VAR
            len: DINT;
        END_VAR

        len:= Strings.ToArray(str := ' "1234"      ', arr := doc.buffer);

        testIndex1:= 0; testIndex2 := 10;
        value:= doc.GetValueFromIndex(testIndex1, testIndex2);

        Equal('1234', value);
        
    END_Method

    {Test}
    Method Public Test_FindValue_in_JSON_SimpleEntries
        VAR
            JSON_Entry: STRING := '{"key": "Element1", "Hello": "something", "Nothing": 456, "Key 2":  1234  , }';

            len:DINT;
            keyStart : int;
            keyEnd : int;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := doc.buffer);

        key := 'key';
        keyFound := doc.GetValue(REF(key), value);
        Equal(8, LengthOf(value));
        Equal('Element1', value);

        key := 'Key 2';
        keyFound := doc.GetValue(REF(key), value);
        Equal(4, LengthOf(value));
        Equal('1234', value);

        key := 'not a key';
        keyFound := doc.GetValue(REF(key), value);
        Equal('', value);
    END_Method

END_CLASS

END_NAMESPACE