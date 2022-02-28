USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS JsonDocument
        VAR PUBLIC
            buffer : ARRAY[0..999] OF CHAR;
        END_VAR
        
        VAR PROTECTED
            _firstElement : IJsonElementMuteable;
            _lastElement : IJsonElementMuteable;
            _rootElement : IJsonElement;
            _lentgh : DINT;
            _bufLowerBound : DINT;
            _bufIndex : DINT;
        END_VAR

        METHOD PUBLIC ToString : STRING
            VAR_TEMP
                _str : STRING;
                _to : IJsonElementMuteable;
            END_VAR
        
            _str := Concat(_str, '{');
            _to := _firstElement;
            WHILE _to <> NULL DO
                _str := Concat(_str, _to.ToString());
                _to := _to.GetNext();
                IF (_to <> NULL) THEN
                    _str := Concat(_str, ', ');
                END_IF;
            END_WHILE;
            _str := Concat(_str, '}');
            ToString := _str;
        END_METHOD

        METHOD PUBLIC Serialize : BOOL
            VAR_IN_OUT
                buf : ARRAY[*] OF CHAR;
            END_VAR
            VAR_TEMP
                _to : IJsonElementMuteable;
            END_VAR

            // Clear buffer (not hard before serializing)
            THIS.ClearBuffer();

            _bufLowerBound := LOWER_BOUND(buf, 1);
            _bufIndex := _bufLowerBound;
            THIS.AddChar(c := '{');            
            
            _to := _firstElement;
            WHILE _to <> NULL DO
                _to.Serialize(doc := REF(THIS));
                _to := _to.GetNext();
                IF (_to <> NULL) THEN
                    THIS.AddString(s := ', ');                     
                END_IF;
            END_WHILE;
            THIS.AddChar(c := '}'); 
            Serialize := TRUE;
        END_METHOD

        METHOD PUBLIC AddChar : BOOL
            VAR_INPUT
                c : CHAR;
            END_VAR
            buffer[_bufIndex] := c;
            _bufIndex := _bufIndex + 1;
            _lentgh := _lentgh + 1;
            AddChar := TRUE;
        END_METHOD

        METHOD PUBLIC AddString : BOOL
            VAR_INPUT
                s : STRING;
            END_VAR
            VAR_TEMP
                i : INT;
            END_VAR
            FOR i := 1 TO LengthOf(s) DO
                buffer[_bufIndex] := s[i];
                _bufIndex := _bufIndex + 1;
                _lentgh := _lentgh + 1;
            END_FOR;
            AddString := TRUE;
        END_METHOD
    
        METHOD PUBLIC GetLength : DINT
            GetLength := _lentgh;
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
                _lastElem : IJsonElement;
            END_VAR
            _elemMuted ?= elem;
            IF (_firstElement = NULL) THEN
                _firstElement := _elemMuted;
                _lastElement := _elemMuted;
                _rootElement := elem;
            ELSE
                _elemMuted ?= elem;
                _lastElem ?= _lastElement;
                _lastElem.AddElement(elem);
                _lastElement := _elemMuted;
            END_IF;
            ;
        END_METHOD

        METHOD PUBLIC ClearBuffer
            VAR_INPUT
                hard : BOOL := FALSE;
            END_VAR
            VAR_TEMP
                i : DINT;
            END_VAR

            IF (hard) THEN
                FOR i := _bufLowerBound TO _bufIndex DO
                    buffer[i] := TO_CHAR(BYTE#16#00);
                END_FOR;
            END_IF;
            _bufLowerBound := 0;
            _bufIndex := 0;
            _lentgh := 0;
        END_METHOD

    END_CLASS
END_NAMESPACE