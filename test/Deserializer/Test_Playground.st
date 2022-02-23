USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer

{TestFixture}
CLASS Playground
    VAR protected
        deserializer : Deserializer;
        keyArray: ARRAY [0..1] OF STRING := ['key1', 'nestedkey1'];
        buffer : ARRAY[0..999] OF CHAR;
        value: STRING;
    END_VAR

    {Test}
    Method Public Test_FindValue_in_nestedElementWithPlayground
        VAR
            JSON_Entry: STRING := '{ "key1": {"nestedkey1": 123}}';
            len:DINT;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer)); //TODO: ausbauen und ersetzen durch buffer in methode

        
        keyFound := deserializer.GetValue_WithKeyArray( REF(keyArray), value);
        Equal('123', value);

        
    END_Method

    {Test}
    Method Public Test_FindValue_in_nestedElementWithPlayground_Complex
        VAR
            JSON_Entry: STRING := '{ "aKey": "hallo", "anotherKey": 1234, "key1": {"nestedkey1": 123, "nestedkey2": "hallo", "nestedkey3": {"nestedInNestedkey1": 1234 }}}';
            len:DINT;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer)); //TODO: ausbauen und ersetzen durch buffer in methode

        
        keyFound := deserializer.GetValue_WithKeyArray( REF(keyArray), value);
        Equal('123', value);

        
    END_Method

END_CLASS

END_NAMESPACE