USING System.Strings;
USING Simatic.Ax.Json;

NAMESPACE Simatic.Ax.Json
    CLASS ABSTRACT AbstractJsonElement IMPLEMENTS IJsonElementMuteable, IJsonElement
        VAR PUBLIC
            Key : STRING  := 'NoKeySet';                    
        END_VAR

        VAR PROTECTED
                _next : IJsonElementMuteable;
        END_VAR

        METHOD PUBLIC ABSTRACT ToString : STRING
        END_METHOD

        METHOD PUBLIC ABSTRACT Serialize : BOOL
            VAR_INPUT
                doc : REF_TO JsonDocument;
            END_VAR
        END_METHOD

        METHOD PROTECTED ToStringHelper : STRING
            VAR_INPUT
                valueAsString : STRING;
            END_VAR
            VAR_TEMP
                _str : STRING;
            END_VAR
            _str := Concat('"', Key, '"', ': "');
            _str := Concat(_str, valueAsString, '"');
            ToStringHelper := _str;
        END_METHOD

        METHOD PUBLIC SerializeHelper : DINT
            VAR_INPUT
                doc : REF_TO JsonDocument;
                valueAsString : STRING;
            END_VAR
            VAR_TEMP
                _i : DINT;
            END_VAR
            doc^.AddString(valueAsString);
        END_METHOD

        METHOD PUBLIC HasNext : BOOL
            HasNext := _next <> NULL;
        END_METHOD

        METHOD PUBLIC GetNext : IJsonElementMuteable
            GetNext := _next;
        END_METHOD

        METHOD PUBLIC Reset
            _next := NULL;
        END_METHOD


        METHOD PUBLIC Insert
            VAR_INPUT
                elem : IJsonElement;
            END_VAR
            _next ?= elem;
        END_METHOD

    END_CLASS
END_NAMESPACE