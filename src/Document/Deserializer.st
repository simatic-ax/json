USING Deserializer;
USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS Deserializer
        VAR PUBLIC
            buffer : ARRAY[0..999] OF CHAR;
        END_VAR

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

        METHOD PUBLIC GetValueFromIndex : STRING
            VAR_INPUT
               startIndex: INT;
               endIndex: INT; 
            END_VAR
            VAR_TEMP
                index: INT;
                realStartIndex: INT;
                realEndIndex: INT;
                
                incrementBackwards: INT := -1;
            END_VAR

            FOR index := startIndex TO endIndex DO
                IF NOT ((buffer[index] = ' ') OR ((buffer[index] = '"'))) THEN
                    realStartIndex := index;
                    EXIT;
                END_IF;
            END_FOR;


            FOR index := endIndex TO realStartIndex BY incrementBackwards DO
                IF NOT ((buffer[index] = ' ') OR ((buffer[index] = '"'))) THEN
                    realEndIndex := index;
                    EXIT;
                END_IF;
            
            END_FOR;

            GetValueFromIndex := Conversion.Arrays.ToString(buffer, realStartIndex, realEndIndex);
        END_METHOD


        //TODO: Auftrennen und schöner machen.
        METHOD PUBLIC GetValue : BOOL
            VAR_INPUT
                key : REF_TO STRING;
            END_VAR
            VAR_IN_OUT
                //deserializedObejctArray : ARRAY[*] of DeserializedObject; -> in späterer Methode verwenden, die alle keys ausgibt
            END_VAR
            VAR_TEMP
                keyFound: BOOL := FALSE;
                valueFound: BOOL := FALSE;

                index: INT;
                foundQuotationMarks : INT := 0; //noch keine Marks am Anfang gefunden
                inKeySpace : BOOL := TRUE; //erster Eintrag muss immer ein key sein
                keyStartIndex: INT;
                keyEndIndex: INT;
                valueStartIndex: INT;
                valueEndIndex: INT;

                keyLength: INT;

            END_VAR
            VAR_OUTPUT
                value: STRING;
            END_VAR

            keyLength := LengthOf(key^);

            FOR index := 0 TO 999 DO //TODO: Change to upper_lowerbounds when buffer is array*
                
                //das erste " markiert beginn von key. das zweite " ist das ende von key (außer es ist ein \davor ->später prüfen).
                //Anschließend kommt irgendwann ein , und das nächste , schließt den value ab. Außer im value ist ein , .... -> später prüfen.

                //-> später allgemeiner machen für value!
                IF (keyFound = FALSE AND buffer[index] = '"') THEN
                    foundQuotationMarks := foundQuotationMarks + 1;
                    
                    //we are in a key range!
                    IF (inKeySpace = TRUE) THEN
                        IF (foundQuotationMarks = 1) THEN
                            keyStartIndex := index + 1;
                        END_IF;
    
                        IF (foundQuotationMarks = 2) THEN
                            keyEndIndex := index - 1;

                            IF (keyLength = (keyEndIndex - keyStartIndex + 1)) THEN
                                keyFound := THIS.KeyIsInIndexSpan(key, keyStartIndex, keyEndIndex);
                            END_IF;

                        END_IF;
                    END_IF;
                   
                END_IF;

                //value space ist mit : von keyspace getrennt, danach erst ein , ! "Key1": "Element1","Key2": 1234
                //Achtung! , ist erlaubt wenn es teil eines string value oder keys ist! Das später korrigieren und testen! Dazu den " counter nehmen.
                IF (buffer[index] = ':') THEN // -> : ist auch als Teil eines keys oder value möglich, später erweitern!
                    inKeySpace := FALSE;
                    valueStartIndex := index + 1;
                END_IF;

                IF (buffer[index] = ',') THEN // -> , ist auch als Teil eines keys oder value möglich, später erweitern!
                    inKeySpace := TRUE;
                    foundQuotationMarks := 0;
                    valueEndIndex := index - 1;
                    valueFound := TRUE;
                END_IF;



                IF (keyFound = TRUE AND valueFound = TRUE) THEN
                    value:= THIS.GetValueFromIndex(valueStartIndex, valueEndIndex);
                    GetValue:= keyFound;
                    RETURN;
                END_IF;

                valueFound := FALSE;// must be reset, otherwise the last found key is attached!
            END_FOR;

            value := '';
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