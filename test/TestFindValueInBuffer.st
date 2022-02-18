USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer

{TestFixture}
CLASS Test_FindValueInBuffer
    VAR protected
        doc : JsonDocument;

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
        value:= doc.GetValueFromIndex(REF(testIndex1), REF(testIndex2));

        Equal('1234', value);
        
    END_Method

    {Test}
    Method Public Test_GetValueFromIndex_GetValue_withSpaces     
        VAR
            len: DINT;
        END_VAR

        len:= Strings.ToArray(str := '    1234    ', arr := doc.buffer);

        testIndex1:= 0; testIndex2 := 10;
        value:= doc.GetValueFromIndex(REF(testIndex1), REF(testIndex2));

        Equal('1234', value);
        
    END_Method

    {Test}
    Method Public Test_GetValueFromIndex_GetValue_withQuotationMarks      
        VAR
            len: DINT;
        END_VAR

        len:= Strings.ToArray(str := ' "1234"      ', arr := doc.buffer);

        testIndex1:= 0; testIndex2 := 10;
        value:= doc.GetValueFromIndex(REF(testIndex1), REF(testIndex2));

        Equal('1234', value);
        
    END_Method

END_CLASS

END_NAMESPACE