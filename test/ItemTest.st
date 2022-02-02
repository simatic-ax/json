USING AxUnit.Assert;
USING System.Strings;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonElementsDint
        
        VAR PROTECTED
            e : Properties.DoubleInt := (value := 999, key := 'test');
        END_VAR

        {Test}
        METHOD PUBLIC Test_Tostring_with_999_expect_test_999
            Equal(expected := e.ToString(), actual := '"test": "999"');            
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Tostring_with_Minus_999_expect_test_Minus_999
            Equal(expected := e.ToString(), actual := '"test": "999"');  
        END_METHOD

    END_CLASS
END_NAMESPACE