USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS ABSTRACT AbstractJsonElement IMPLEMENTS IJsonElementMuteable, IJsonElement
        VAR PUBLIC
            key : STRING  := 'NoKeySet';                    
        END_VAR

        VAR PROTECTED
                _next : IJsonElementMuteable;
        END_VAR

        METHOD PUBLIC ABSTRACT ToString : STRING
        END_METHOD

        METHOD PUBLIC Serialize : BOOL
            VAR_INPUT
                t : ARRAY [*] OF BYTE;
            END_VAR
            ;
        END_METHOD

        METHOD PROTECTED ToStringHelper : STRING
            VAR_INPUT
                valueAsString : STRING;
            END_VAR
            VAR_TEMP
                _str : STRING;
            END_VAR
            _str := Concat('"', key, '"', ': "');
            _str := Concat(_str, valueAsString, '"');
            ToStringHelper := _str;
        END_METHOD

        METHOD PUBLIC HasNext : BOOL
            HasNext := _next <> NULL;
        END_METHOD

        METHOD PUBLIC GetNext : IJsonElementMuteable
            GetNext := _next;
        END_METHOD

        METHOD PUBLIC AddElement
            VAR_INPUT
                elem : IJsonElementMuteable;
            END_VAR
            _next := elem;
        END_METHOD

    END_CLASS
END_NAMESPACE