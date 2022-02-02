USING AxUnit.Assert;
USING System.Strings;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonObject
        
        VAR PROTECTED
            e : Properties.DoubleInt := (value := 999, key := 'test');
            o : JsonObject;
        END_VAR

        {Test}
        METHOD PUBLIC Test_Empty_object_ToString_Expect_empty_object
            
            Equal(expected := o.ToString(), actual := '{}');            
        END_METHOD
    END_CLASS
END_NAMESPACE