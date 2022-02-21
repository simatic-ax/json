USING Deserializer;
USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS Deserializer
        VAR PRIVATE //TODO Public entfernen wenn ref_to array star, derzeit nur noch zum testen drin!
            buffer : ARRAY[0..999] OF CHAR;
        END_VAR

        //Temporäre Hilfsmethode um Buffer zus etzten, bis Ref_to array*
        METHOD PUBLIC SetBuffer
            VAR_INPUT
                _buffer : ARRAY[0..999] OF CHAR;
            end_var

            buffer := _buffer;
        END_METHOD

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

        METHOD PRIVATE GetBufferIndizes
            VAR_OUTPUT
                bufferStart: INT;
                bufferEnd: INT;
            END_VAR
            VAR_TEMP
                index: INT;
                incrementBackwards: INT := -1;
                foundBeginn: BOOL := FALSE;
            END_VAR

            FOR index := 0 TO 999 DO //TODO: Array* upper und lowerbound
                IF (buffer[index] = '{' AND foundBeginn = FALSE) THEN
                    bufferStart := index;
                    foundBeginn := TRUE;
                END_IF;
            END_FOR;

            FOR index := 999 TO 0 BY incrementBackwards DO
                IF (buffer[index] = '}') THEN
                    bufferEnd := index;
                    RETURN;
                END_IF;
            END_FOR;
        END_METHOD


        //TODO: Auftrennen und schöner machen.
        METHOD PUBLIC GetValue : BOOL
            VAR_INPUT
                //document : ARRAY[0..999] OF CHAR; //ref_to array char machen!
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

                inKeyArea : BOOL := TRUE; //erster Eintrag muss immer ein key sein
                inNestedArea: BOOL := FALSE;
                inValueArea: BOOL := FALSE;

                keyStartIndex: INT;
                keyEndIndex: INT;

                valueStartIndex: INT;
                valueEndIndex: INT;

                keyLength: INT;

                bufferStart: INT;
                bufferEnd: INT;

            END_VAR
            VAR_OUTPUT
                value: STRING;
            END_VAR

            THIS.GetBufferIndizes(bufferStart, bufferEnd );

            //buffer := document;
            keyLength := LengthOf(key^);

            FOR index := bufferStart TO bufferEnd DO 
                
                //das erste " markiert beginn von key. das zweite " ist das ende von key (außer es ist ein \davor ->später prüfen).
                //Anschließend kommt irgendwann ein , und das nächste , schließt den value ab. Außer im value ist ein , .... -> später prüfen.

                //--------------------- key area
                //-> später allgemeiner machen für value!
                IF (keyFound = FALSE AND buffer[index] = '"' AND inKeyArea AND NOT inNestedArea AND NOT inValueArea) THEN
                    foundQuotationMarks := foundQuotationMarks + 1;

                    IF (foundQuotationMarks = 1) THEN
                        keyStartIndex := index + 1;
                    END_IF;

                    //TODO: Else if
                    IF (foundQuotationMarks = 2) THEN
                        keyEndIndex := index - 1;
                        inKeyArea := FALSE;
                        foundQuotationMarks := 0;

                        IF (keyLength = (keyEndIndex - keyStartIndex + 1)) THEN
                            keyFound := THIS.KeyIsInIndexSpan(key, keyStartIndex, keyEndIndex);
                        END_IF;
                    END_IF;
                   
                    //CONTINUE?
                   
                END_IF;

                //--------------------- nested Area
                IF (buffer[index] = '{' AND NOT inKeyArea) THEN
                    inKeyArea := FALSE;
                    inValueArea:= FALSE;
                    inNestedArea := TRUE;
                    valueStartIndex := index;
                END_IF;

                IF (buffer[index] = '}' AND NOT inKeyArea AND NOT inValueArea) THEN
                    inNestedArea := FALSE;
                    inValueArea := FALSE;
                    inKeyArea := TRUE;

                    valueEndIndex := index - 1;
                    
                    foundQuotationMarks := 0;
                    valueEndIndex := index;
                    valueFound := TRUE;


                    IF (keyFound = TRUE AND valueFound = TRUE) THEN
                        value:= THIS.GetValueFromIndex(valueStartIndex, valueEndIndex);
                        //This.EmptyBuffer(); //TODO Remove after ref_to_arraystar wird verwendet und buffer innerhalb klasse ausgebaut wird. Alternativ: set Document Methode!
                        GetValue:= keyFound;
                        RETURN;
                    END_IF;
                END_IF;


                //-------------------------------value area
                //value space ist mit : von keyspace getrennt, danach erst ein , ! "Key1": "Element1","Key2": 1234
                //Achtung! , ist erlaubt wenn es teil eines string value oder keys ist! Das später korrigieren und testen! Dazu den " counter nehmen.

                IF (buffer[index] = ':' AND NOT inNestedArea AND NOT inKeyArea) THEN // -> : ist auch als Teil eines keys oder value möglich, später erweitern!
                    inValueArea := TRUE;
                    inNestedArea := FALSE;
                    inKeyArea := FALSE;
                    valueStartIndex := index + 1;
                END_IF;

                IF ((buffer[index] = ',' OR buffer[index] = '}') AND NOT inNestedArea AND NOT inKeyArea) THEN // -> , ist auch als Teil eines keys oder value möglich, später erweitern! } => FileEnd
                    inKeyArea := TRUE;
                    inValueArea := FALSE;
                    inNestedArea := FALSE;

                    valueEndIndex := index - 1;
                    valueFound := TRUE;

                    IF (keyFound = TRUE AND valueFound = TRUE) THEN
                        value:= THIS.GetValueFromIndex(valueStartIndex, valueEndIndex);
                        //This.EmptyBuffer(); //TODO Remove after ref_to_arraystar wird verwendet und buffer innerhalb klasse ausgebaut wird. Alternativ: set Document Methode!
                        GetValue:= keyFound;
                        RETURN;
                    END_IF;
                END_IF;



                // IF (keyFound = TRUE AND valueFound = TRUE) THEN
                //     value:= THIS.GetValueFromIndex(valueStartIndex, valueEndIndex);
                //     //This.EmptyBuffer(); //TODO Remove after ref_to_arraystar wird verwendet und buffer innerhalb klasse ausgebaut wird. Alternativ: set Document Methode!
                //     GetValue:= keyFound;
                //     RETURN;
                // END_IF;

                valueFound := FALSE;// must be reset, otherwise the last found key is attached!
            END_FOR;

            value := '';
            GetValue := keyFound;

        END_METHOD

        METHOD PRIVATE EmptyBuffer
            VAR_TEMP
                Index: INT;
            END_VAR
            
            FOR Index := 0  TO 999 DO
                buffer[Index] := ' ';
            END_FOR;

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