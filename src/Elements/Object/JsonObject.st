USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS JsonObject EXTENDS AbstractJsonElement
        
        VAR PROTECTED
            _lastElement : IJsonElementMuteable;
            _firstElement : IJsonElementMuteable;
        END_VAR

        METHOD PUBLIC OVERRIDE ToString : STRING
            VAR_TEMP
                _str : STRING;
                _to : IJsonElementMuteable;
                _elem : IJsonElement;
            END_VAR

            ;
            IF (_firstElement <> NULL) THEN
                _str := Concat(_str, '"', Key, '": ');
            END_IF;
        
            _str := Concat(_str, '{');
            // insert properties
            _to := _firstElement;
            WHILE _to <> NULL DO
                _elem ?= _to;
                _str := Concat(_str, _elem.ToString());
                _to := _to.GetNext();
                IF (_to <> NULL) THEN
                    _str := Concat(_str, ', ');
                END_IF;
            END_WHILE;
            _str := Concat(_str, '}');
            ToString := _str;
        END_METHOD

        METHOD PUBLIC OVERRIDE Serialize : BOOL
            VAR_INPUT
                doc : REF_TO JsonDocument;
            END_VAR
            VAR_TEMP
                _str : STRING;
                _to : IJsonElementMuteable;
                _elem : IJsonElement;
            END_VAR
            
            Serialize := FALSE;

            IF (_firstElement <> NULL) THEN
                
                _str := Concat(_str, '"', Key, '": ');
                doc^.AddString(_str);
            END_IF;
        
            doc^.AddChar('{');
            
            // insert properties
            _to := _firstElement;
            WHILE _to <> NULL DO
                _elem ?= _to;
                _elem.Serialize(doc);
                _to := _to.GetNext();
                IF (_to <> NULL) THEN
                    doc^.AddString(', ');
                END_IF;
            END_WHILE;
            doc^.AddChar('}');
            Serialize := TRUE;
        END_METHOD
        
        METHOD PUBLIC OVERRIDE AddElement
            VAR_INPUT
                elem : IJsonElementMuteable;
            END_VAR

            IF (_firstElement = NULL) THEN
                _firstElement := elem;
                _lastElement := elem;
            ELSE
                _lastElement.AddElement(elem);
                _lastElement ?= elem;
            END_IF;
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE