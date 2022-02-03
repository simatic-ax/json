USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS JsonDocument
        VAR PROTECTED
            _firstObject : IJsonElementMuteable;
            _lastObject : IJsonElementMuteable;
            _rootElement : IJsonElement;
        END_VAR

        METHOD PUBLIC ToString : STRING
            VAR_TEMP
                _str : STRING;
                _to : IJsonElementMuteable;
                _elem : IJsonElement;
            END_VAR
        
            _str := Concat(_str, '{');
            // insert properties
            //_to := _firstObject;
            _elem ?= _firstObject;
            _to ?= _elem;
            WHILE _elem <> NULL DO
                _str := Concat(_str, _elem.ToString());
                _to := _to.GetNext();
                _elem ?= _to;
                IF (_to <> NULL) THEN
                    _str := Concat(_str, ', ');
                END_IF;
            END_WHILE;
            _str := Concat(_str, '}');
            ToString := _str;
        END_METHOD

        METHOD PUBLIC Serialize : BOOL
            VAR_INPUT
                t : ARRAY [*] OF BYTE;
            END_VAR

            ;
        END_METHOD
    
        METHOD PUBLIC GetRootElement : IJsonElement
            GetRootElement := _rootElement;
        END_METHOD
    
        METHOD PUBLIC AddElement
            VAR_INPUT
                elem : IJsonElement;
            END_VAR
            VAR_TEMP
                _elemMuted : IJsonElementMuteable;
            END_VAR
            _elemMuted ?= elem;
            IF (_firstObject = NULL) THEN
                _firstObject := _elemMuted;
                _lastObject := _elemMuted;
                _rootElement := elem;
            ELSE
                _elemMuted ?= elem;
                _lastObject.AddElement(_elemMuted);
                _lastObject := _elemMuted;
            END_IF;
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE