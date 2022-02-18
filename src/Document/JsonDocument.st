USING Deserializer;
USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS JsonDocument
        VAR PUBLIC
            buffer : ARRAY[0..999] OF CHAR;
        END_VAR
        VAR PROTECTED
            _firstObject : IJsonElementMuteable;
            _lastObject : IJsonElementMuteable;
            _rootElement : IJsonElement;
            _lentgh : DINT;
            _bufLowerBound : DINT;
            _bufIndex : DINT;
        END_VAR

        METHOD PUBLIC ToString : STRING
            VAR_TEMP
                _str : STRING;
                _to : IJsonElementMuteable;
                _elem : IJsonElement;
            END_VAR
        
            _str := Concat(_str, '{');
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
            VAR_IN_OUT
                buf : ARRAY[*] OF CHAR;
            END_VAR
            VAR_TEMP
                _to : IJsonElementMuteable;
                _elem : IJsonElement;
            END_VAR
            _bufLowerBound := LOWER_BOUND(buf, 1);
            _bufIndex := _bufLowerBound;
            THIS.AddChar(c := '{');            
            
            _elem ?= _firstObject;
            _to ?= _elem;
            WHILE _elem <> NULL DO
                _elem.Serialize(doc := REF(THIS));
                _to := _to.GetNext();
                _elem ?= _to;
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

        //TODO: Zeitsparen später: Methode nur aufrufen wenn die Länge vom key so lange ist wie der index-span
        METHOD PUBLIC KeyIsInIndexSpan : BOOL
            VAR_INPUT
                key : REF_TO STRING;
                startIndex: INT;
                endIndex: INT;
            end_var
            VAR_TEMP
                keyIndex: INT := 1;
                loopIndex: INT;
            END_VAR

            FOR loopIndex := startIndex TO endIndex DO
                IF NOT (buffer[loopIndex] = key^[keyIndex])  THEN
                    KeyIsInIndexSpan := FALSE;
                    RETURN;
                END_IF;

                keyIndex := keyIndex + 1;
            END_FOR;

            KeyIsInIndexSpan := TRUE;

        END_METHOD

        METHOD PUBLIC GetValue : BOOL
            VAR_INPUT
                key : REF_TO STRING;
            end_var
            VAR_IN_OUT
                //deserializedObejctArray : ARRAY[*] of DeserializedObject; -> in späterer Methode verwenden, die alle keys ausgibt
            END_VAR
            VAR_TEMP
                keyFound: BOOL := FALSE;

                index: int;
                foundQuotationMarks : int := 0; //noch keine Marks am Anfang gefunden
                inKeySpace : bool := TRUE; //erster Eintrag muss immer ein key sein
                keyStartIndex: int;
                keyEndIndex: int;
            end_var
            VAR_OUTPUT
                value: STRING;
            end_var

            FOR index := 0 TO 999 DO //TODO: Change to upper_lowerbounds when buffer is array*
                
                //das erste " markiert beginn von key. das zweite " ist das ende von key (außer es ist ein \davor ->später prüfen).
                //Anschließend kommt irgendwann ein , und das nächste , schließt den value ab. Außer im value ist ein , .... -> später prüfen.

                //-> später allgemeiner machen für value!
                IF (buffer[index] = '"') THEN
                    foundQuotationMarks := foundQuotationMarks + 1;
                    
                    //we are in a key range!
                    IF (inKeySpace = TRUE) THEN
                        IF (foundQuotationMarks = 1) THEN
                            keyStartIndex := index + 1;
                        END_IF;
    
                        IF (foundQuotationMarks = 2) THEN
                            keyEndIndex := index - 1;
                            keyFound := THIS.KeyIsInIndexSpan(key, keyStartIndex, keyEndIndex);
                        END_IF;
                    END_IF;
                   
                END_IF;





                //value space ist mit : von keyspace getrennt, danach erst ein , ! "Key1": "Element1","Key2": 1234
                //Achtung! , ist erlaubt wenn es teil eines string value oder keys ist! Das später korrigieren und testen! Dazu den " counter nehmen.
                IF (buffer[index] = ':') THEN // -> : ist auch als Teil eines keys oder value möglich, später erweitern!
                    inKeySpace := FALSE;
                END_IF;

                IF (buffer[index] = ',') THEN // -> , ist auch als Teil eines keys oder value möglich, später erweitern!
                    inKeySpace := TRUE;
                    foundQuotationMarks := 0;
                END_IF;

                IF keyFound = TRUE THEN
                    GetValue:= keyFound;
                    RETURN;
                END_IF;
            END_FOR;

            GetValue := keyFound;

        END_METHOD

        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keys : ARRAY[*] OF STRING;  //  --> ARRAY[*] OF STRING key[0] := 'key', key[1] := 'nestedkey'
            END_VAR

            VAR_OUTPUT
                value : DINT;
            END_VAR
            
            VAR_TEMP
                ub : DINT;
                lb : DINT;
                i : DINT;
            END_VAR

            ub := UPPER_BOUND(keys, 1);
            lb := LOWER_BOUND(keys, 1);

            FOR i := lb TO ub DO
                ;
            END_FOR;

            TryParse := FALSE;
            TryParse := TRUE;
        END_METHOD

    END_CLASS
END_NAMESPACE