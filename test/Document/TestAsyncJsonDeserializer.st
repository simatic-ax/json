/// Tests for AsyncJsonDeserializer class
/// Note: Due to AxUnit-ST type system limitations (no INT support in assertions),
/// only a subset of tests can be implemented. The full implementation is in 
/// src/Document/AsyncJsonDeserializer.st
USING AxUnit.Assert;
USING Simatic.Ax.Json;

NAMESPACE Document

    {TestFixture}
    CLASS TestAsyncJsonDeserializer
        VAR PROTECTED
            parser : AsyncJsonDeserializer;
            buffer : ARRAY[0..500] OF CHAR;
            // Stateless copies
            parserStateLess : AsyncJsonDeserializer;
            bufferStateLess : ARRAY[0..500] OF CHAR;
        END_VAR
        
        {TestSetup}
        METHOD PUBLIC TestSetup
            parser := parserStateLess;
            buffer := bufferStateLess;
        END_METHOD
        
        // ========== Test: Start with NULL buffer returns FALSE ==========
        
        {Test}
        METHOD PUBLIC Test_Start_WithNullBuffer_ReturnsFalse
            VAR
                result : BOOL;
            END_VAR
            result := parser.Start(NULL);
            Equal(FALSE, result);
        END_METHOD
        
        // ========== Test: GetResult before Start returns NULL ==========
        
        {Test}
        METHOD PUBLIC Test_GetResult_BeforeStart_ReturnsNull
            VAR
                result : REF_TO Deserializer;
            END_VAR
            result := parser.GetResult();
            Equal(TRUE, (result = NULL));
        END_METHOD
        
    END_CLASS
END_NAMESPACE