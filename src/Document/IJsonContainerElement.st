NAMESPACE Simatic.Ax.Json
    INTERFACE IJsonContainerElement
        METHOD AddElement : IJsonContainerElement
            VAR_INPUT
                elem : IJsonElement;
            END_VAR
        END_METHOD
    END_INTERFACE
END_NAMESPACE