USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Json;


NAMESPACE Deserializer
NAMESPACE GetValues

{TestFixture}
CLASS Test_Deserializer_GetValues_Arrays
    VAR protected
        deserializer : Deserializer;

        buffer : ARRAY[0..999] OF CHAR;
        key: STRING;
        value: STRING;
    END_VAR

    {Test}
    Method Public Test_FindValue_in_JSON_SimpleArray
        VAR
            JSON_Entry: STRING := '{ "arraykey": [123, 456]}';

            len:DINT;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key := 'arraykey';
        keyFound := deserializer.TryParse( key, value);
        Equal('[123, 456]', value);
    END_Method

    {Test}
    Method Public Test_FindValue_in_JSON_ComplexArray
        VAR
            JSON_Entry: STRING := '{ "key1": 1234,"arraykey": [123, 456], "key2": 456}';

            len:DINT;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key := 'arraykey';
        keyFound := deserializer.TryParse( key, value);
        Equal('[123, 456]', value);
    END_Method

    {Test}
    Method Public Test_FindValue_in_JSON_NestedArray
        VAR
            JSON_Entry: STRING := '{ "key1": 1234,"arraykey": [{"nestedkey1": 1234, "nestedkey2": 456}, {"nestedkey3": 1234, "nestedkey4": 456}], "key2": 456}';

            len:DINT;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key := 'arraykey';
        keyFound := deserializer.TryParse( key, value);
        Equal('[{"nestedkey1": 1234, "nestedkey2": 456}, {"nestedkey3": 1234, "nestedkey4": 456}]', value);
    END_Method

END_CLASS

END_NAMESPACE
END_NAMESPACE