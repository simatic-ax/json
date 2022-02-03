NAMESPACE Simatic.Ax.Json
    INTERFACE IJsonElementMuteable
        METHOD HasNext : BOOL
        END_METHOD

        METHOD GetNext : IJsonElementMuteable
        END_METHOD

        METHOD AddElement
            VAR_INPUT
                elem : IJsonElementMuteable;
            END_VAR
        END_METHOD
    END_INTERFACE
END_NAMESPACE