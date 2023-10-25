USING AxUnit.Assert;

NAMESPACE Simatic.Ax.Json

    {TestFixture}
    CLASS MyTestFixture
        VAR
            o : GetBufferIndizesSyncron;
            inputBuffer : ARRAY[0..99] OF CHAR;
            start, end : INT;
            done, error : BOOL;
        END_VAR
        {Test}
        METHOD PUBLIC Find_start_end_at_0_and_10
            VAR_TEMP
                _plcopen : IPlcOpen;
            END_VAR
            inputBuffer[0] := '{';
            inputBuffer[10] := '}';
            _plcopen := o.Find(buffer := REF(inputBuffer));
            Equal(expected := 0, actual := o.StartIndex());
            Equal(expected := 10, actual := o.EndIndex());
            Equal(expected := TRUE, actual := _plcopen.Done());
            Equal(expected := FALSE, actual := _plcopen.Error());          
        END_METHOD

        {Test}
        METHOD PUBLIC No_Start_character_Available
            VAR_TEMP
                _plcopen : IPlcOpen;
            END_VAR
            inputBuffer[0] := ' ';
            inputBuffer[10] := '}';
            _plcopen := o.Find(buffer := REF(inputBuffer));
            Equal(expected := 0, actual := o.StartIndex());
            Equal(expected := 0, actual := o.EndIndex());
            Equal(expected := FALSE, actual := _plcopen.Done());
            Equal(expected := TRUE, actual := _plcopen.Error());
        END_METHOD

        {Test}
        METHOD PUBLIC No_Start_and_no_end_character_Available
            VAR_TEMP
                _plcopen : IPlcOpen;
            END_VAR
            inputBuffer[0] := ' ';
            inputBuffer[10] := ' ';
            _plcopen := o.Find(buffer := REF(inputBuffer));
            Equal(expected := 0, actual := o.StartIndex());
            Equal(expected := 0, actual := o.EndIndex());
            Equal(expected := FALSE, actual := _plcopen.Done());
            Equal(expected := TRUE, actual := _plcopen.Error());
        END_METHOD

        {Test}
        METHOD PUBLIC End_before_start
            VAR_TEMP
                _plcopen : IPlcOpen;
            END_VAR
            inputBuffer[0] := '}';
            inputBuffer[0] := '{';
            _plcopen := o.Find(buffer := REF(inputBuffer));
            Equal(expected := 0, actual := o.StartIndex());
            Equal(expected := 0, actual := o.EndIndex());
            Equal(expected := FALSE, actual := _plcopen.Done());
            Equal(expected := TRUE, actual := _plcopen.Error());
            // second start after error
            inputBuffer[0] := '{';
            inputBuffer[10] := '}';
            _plcopen := o.Find(buffer := REF(inputBuffer));
            Equal(expected := 0, actual := o.StartIndex());
            Equal(expected := 10, actual := o.EndIndex());
            Equal(expected := TRUE, actual := _plcopen.Done());
            Equal(expected := FALSE, actual := _plcopen.Error());
        END_METHOD
    END_CLASS

END_NAMESPACE
