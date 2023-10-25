USING AxUnit.Assert;

NAMESPACE Simatic.Ax.Json

    {TestFixture}
    CLASS TestFindCharacterInArray
        VAR
            o : FindCharacterInArray;
            inputBuffer : ARRAY[0..99] OF CHAR;
            index : DINT;
            done, error : BOOL;
            cmd : IPlcOpen;
        END_VAR


        {Test (ExpectedIndex := 0)}
        {Test (ExpectedIndex := 1)}
        {Test (ExpectedIndex := 10)}
        {Test (ExpectedIndex := 99)}
        METHOD PUBLIC Find_start_Char_At_First_Position_Search_Forward
            VAR_INPUT
                ExpectedIndex : DINT;
            END_VAR
            inputBuffer[ExpectedIndex] := '{';
            cmd := o.Find(buffer := REF(inputBuffer), c := '{', mode := FindeMode#MODE_FORWARD);
            IF NOT cmd.Busy() THEN
                IF cmd.Done() THEN
                    index := o.GetIndex();
                    ; // command successfully done
                ELSIF cmd.Error() THEN
                    ; // error occured
                ELSIF cmd.Aborted() THEN
                    ; // command was aborted
                END_IF;
            ELSE
                ; // wait until it is not busy any more
            END_IF;
            Equal(expected := ExpectedIndex, actual := index);
            Equal(expected := FALSE, actual := error);
            Equal(expected := FALSE, actual := cmd.Error());
            done := cmd.Done();
            Equal(expected := TRUE, actual := done);
            Equal(expected := TRUE, actual := cmd.Done());
        END_METHOD

        {Test (ExpectedIndex := 0)}
        {Test (ExpectedIndex := 1)}
        {Test (ExpectedIndex := 10)}
        {Test (ExpectedIndex := 99)}
        METHOD PUBLIC Find_start_Char_At_First_Position_Search_Reverse
            VAR_INPUT
                ExpectedIndex : DINT;
            END_VAR
            inputBuffer[ExpectedIndex] := '{';
            cmd := o.Find(buffer := REF(inputBuffer), c := '{', mode := FindeMode#MODE_REVERSE);
            IF NOT cmd.Busy() THEN
                IF cmd.Done() THEN
                    index := o.GetIndex();
                    done := TRUE;
                    ; // command successfully done
                ELSIF cmd.Error() THEN
                    ; // error occured
                ELSIF cmd.Aborted() THEN
                    ; // command was aborted
                END_IF;
            ELSE
                ; // wait until it is not busy any more
            END_IF;
            Equal(expected := ExpectedIndex, actual := index);
            Equal(expected := FALSE, actual := error);
            Equal(expected := FALSE, actual := cmd.Error());
            Equal(expected := TRUE, actual := done);
            Equal(expected := TRUE, actual := cmd.Done());
        END_METHOD

        {Test}
        METHOD PUBLIC Error_Character_Not_Found
            cmd := o.Find(buffer := REF(inputBuffer), c := '{', mode := FindeMode#MODE_FORWARD);
            IF NOT cmd.Busy() THEN
                IF cmd.Done() THEN
                    index := o.GetIndex();
                    done := TRUE;
                    ; // command successfully done
                ELSIF cmd.Error() THEN
                    error := TRUE;
                    ; // error occured
                END_IF;
            ELSE
                ; // wait until it is not busy any more
            END_IF;
            Equal(expected := 0, actual := index);
            Equal(expected := TRUE, actual := error);
            Equal(expected := TRUE, actual := cmd.Error());
            Equal(expected := FALSE, actual := cmd.Done());
            ;
        END_METHOD
    END_CLASS

END_NAMESPACE
