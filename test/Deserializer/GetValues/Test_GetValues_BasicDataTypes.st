USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer
NAMESPACE GetValues

{TestFixture}
CLASS Test_Deserializer_GetValues_BasicDataTypes
    VAR protected
        deserializer : Deserializer;

        buffer : ARRAY[0..999] OF CHAR;
        key: STRING;
        value: STRING;
    END_VAR

    {Test}
    Method Public Test_FindValue_in_JSON_SimpleEntries
        VAR
            JSON_Entry: STRING := '{"key": "Element1", "key 2": "something", "key 3": 456, "Key 4":  1234 }';

            len:DINT;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        key := 'key';
        keyFound := deserializer.TryParse( key, value);
        Equal(8, LengthOf(value));
        Equal('Element1', value);

        key := 'Key 4';
        keyFound := deserializer.TryParse( key, value);
        Equal(4, LengthOf(value));
        Equal('1234', value);

        key := 'not a key';
        keyFound := deserializer.TryParse( key, value);
        Equal('', value);
    END_Method

END_CLASS

END_NAMESPACE
END_NAMESPACE