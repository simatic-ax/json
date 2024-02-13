//TODO --> tests with exit code 255
// USING AxUnit.Assert;
// USING System.Strings;
// USING Simatic.Ax.Conversion;
// USING Simatic.Ax.Json;

// NAMESPACE Document
//     {TestFixture}
//     CLASS TestCleanResetDocument
        
//         VAR PROTECTED
//             e1 : JsonDInt := (Value := 999, Key := 'e1');
//             o1 : JsonObject := (Key := 'O1');
//             o2 : JsonObject := (Key := 'O2');
//             o3 : JsonObject := (Key := 'O3');

//             // {"O1": {"O2": "O3""e1" :}}
//                                 // 01234567890123456789012345678901234567890
//             expString : STRING := '{"O1": {"O2": {"O3": {"e1": 999}}}}';
                        
//             actString : STRING;
//             res : BOOL;
//             doc : JsonDocument;
//             cmpBuff : ARRAY[0..399] OF CHAR;
//             cmpBuffEmpty : ARRAY[0..399] OF CHAR;
//             buffer : ARRAY[0..200] OF CHAR;
//             len : DINT;
//         END_VAR
        
//         {Test}
//         METHOD PUBLIC Test_Build_nested_object_And_expect_correct_JSON
//             VAR_TEMP
//                 _to : IJsonElementMuteable;
//                 _elem : IJsonElement;                    
//             END_VAR

//             o3.AddElement(e1);
//             o2.AddElement(o3);
//             o1.AddElement(o2);
//             doc.AddElement(o1);
//             doc.buffer := REF(buffer);
//             doc.Serialize();

//             len := Strings.ToArray.OfCharCount(str := expString, arr := cmpBuff);
//             res := CompareArray(first := buffer, scnd := cmpBuff, count := TO_INT(len));
//             Equal(expected := TRUE, actual := res);
//             Equal(expected := LengthOf(expString), actual := doc.GetLength());
//         END_METHOD
        
//         {Test}
//         METHOD PUBLIC TestCleanBuffer
//             doc.buffer := REF(buffer);
//             // Fill Buffer
//             THIS.Test_Build_nested_object_And_expect_correct_JSON();
//             Equal(expected := LengthOf(expString), actual := doc.GetLength());
            
//             // Clean buffer and expect 0 characters in buffer (buffer is not deleted)
//             doc.ClearBuffer();
//             Equal(expected := 0, actual := doc.GetLength());

//             // compare result buffer with compare array
//             res := CompareArray(first := buffer, scnd := cmpBuff, count := TO_INT(len));
//             Equal(expected := TRUE, actual := res);
    
//             // Serialize again
           
//             doc.Serialize();
//             len := Strings.ToArray.OfCharCount(str := expString, arr := cmpBuff);
//             res := CompareArray(first := buffer, scnd := cmpBuff, count := TO_INT(len));
//             Equal(expected := TRUE, actual := res);
//             Equal(expected := LengthOf(expString), actual := doc.GetLength());


//         END_METHOD

//         {Test}
//         METHOD PUBLIC TestCleanBufferHard
//             // Fill Buffer
//             THIS.Test_Build_nested_object_And_expect_correct_JSON();
//             Equal(expected := LengthOf(expString), actual := doc.GetLength());
            
//             // Clean buffer and expect 0 characters in buffer (buffer is not deleted)
//             doc.ClearBuffer(hard := TRUE);
//             Equal(expected := 0, actual := doc.GetLength());

//             // compare result buffer with compare array
//             res := CompareArray(first := buffer, scnd := cmpBuffEmpty, count := TO_INT(len));
//             Equal(expected := TRUE, actual := res);
    
//         END_METHOD


    

//     END_CLASS
// END_NAMESPACE