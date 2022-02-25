USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer
NAMESPACE GetValuesFromIndex

//Comment in to test the private GetValueFromIndex method
// {TestFixture}
// CLASS Test_Deserializer_GetValuesFromIndex
//     VAR protected
//         deserializer : Deserializer;

//         buffer : ARRAY[0..999] OF CHAR;
//         key: STRING;
//         value: STRING;
//         testIndex1: INT;
//         testIndex2: INT;
//     END_VAR

//     {Test}
//     Method Public Test_GetValueFromIndex_GetValue        
//         VAR
//             len: DINT;
//         END_VAR

//         len:= Strings.ToArray(str := '1234', arr := buffer);
//         deserializer.SetBuffer(REF(buffer));

//         testIndex1:= 0; testIndex2 := 3;
//         value:= deserializer.GetValueFromIndex(testIndex1, testIndex2);

//         Equal('1234', value);
        
//     END_Method

//     {Test}
//     Method Public Test_GetValueFromIndex_GetValue_withSpaces     
//         VAR
//             len: DINT;
//         END_VAR

//         len:= Strings.ToArray(str := '    1234    ', arr := buffer);
//         deserializer.SetBuffer(REF(buffer));

//         testIndex1:= 0; testIndex2 := 10;
//         value:= deserializer.GetValueFromIndex(testIndex1, testIndex2);

//         Equal('1234', value);
        
//     END_Method

//     {Test}
//     Method Public Test_GetValueFromIndex_GetValue_withQuotationMarks      
//         VAR
//             len: DINT;
//         END_VAR

//         len:= Strings.ToArray(str := ' "1234"      ', arr := buffer);
//         deserializer.SetBuffer(REF(buffer));

//         testIndex1:= 0; testIndex2 := 10;
//         value:= deserializer.GetValueFromIndex(testIndex1, testIndex2);

//         Equal('1234', value);
        
//     END_Method

// END_CLASS

END_NAMESPACE
END_NAMESPACE