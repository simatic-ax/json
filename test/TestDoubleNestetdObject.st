USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestDoubleNestetdObject
        
        VAR PROTECTED
            e1 : JsonDoubleInt := (Value := 999, Key := 'e1');
            o1 : JsonObject := (Key := 'O1');
            o2 : JsonObject := (Key := 'O2');
            o3 : JsonObject := (Key := 'O3');

            // {"O1": {"O2": "O3""e1" :}}
                                // 01234567890123456789012345678901234567890
            expString : STRING := '{"O1": {"O2": {"O3": {"e1": 999}}}}';
            
            
            
            
            
            
            
            
            
            actString : STRING;
            res : BOOL;
            doc : JsonDocument;
            cmpBuff : ARRAY[0..399] OF CHAR;
            len : DINT;
        END_VAR

        {Test}
        METHOD PUBLIC Test_Build_nested_object_And_expect_correct_JSON
            VAR_TEMP
                _to : IJsonElementMuteable;
                _elem : IJsonElement;                    
            END_VAR

            o3.AddElement(e1);
            o2.AddElement(o3);
            o1.AddElement(o2);
            doc.AddElement(o1);
            doc.Serialize(doc.buffer);

            len := Strings.ToArray(str := expString, arr := cmpBuff);
            res := CompareArray(first := doc.buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := res);
        END_METHOD
        

    END_CLASS
END_NAMESPACE