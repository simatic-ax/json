USING AxUnit.Assert;

NAMESPACE Simatic.Ax.Json
    FUNCTION test : Int
        VAR_INPUT
            
        END_VAR
        test := 3;
    END_FUNCTION

    {TestFixture}
    CLASS MyTestFixture
        {Test}
        METHOD PUBLIC function_returns_alwasy_4
            Equal(expected := 4, actual := test());
            ; // AxUnit.Assert.Equal(y, x)
        END_METHOD
    END_CLASS

END_NAMESPACE