NAMESPACE Simatic.Ax.Json

    CLASS INTERNAL GetBufferIndizesSyncron EXTENDS Command
         IMPLEMENTS IGetBufferIndizes
        VAR
            _startFound : BOOL;
            _endFound : BOOL;
            _state : INT;
            _finder : FindCharacterInArray;
            _buffer : REF_TO ARRAY[*] OF CHAR;
            _startIndex : INT;
            _endIndex : INT;
        END_VAR
        VAR CONSTANT
            IDLE : INT := 0;
            FIND_START : INT := 1;
            FIND_END : INT := 2;
            EVALUATE : INT := 3;
        END_VAR

        METHOD PUBLIC Find : IPlcOpen
            VAR_INPUT
                Buffer : REF_TO ARRAY[*] OF CHAR;
            END_VAR
            _buffer := Buffer;
            THIS.InitState();
            THIS.Execute();
            Find := THIS;
            
        END_METHOD

        METHOD PUBLIC StartIndex : INT
            StartIndex := _startIndex;
        END_METHOD
        METHOD PUBLIC EndIndex : INT
            EndIndex := _endIndex;
        END_METHOD
        METHOD PROTECTED OVERRIDE Execute
            VAR_TEMP
                index : INT;
                incrementBackwards : INT := -1;
                _lb, _ub : INT;
                _cmd : IPlcOpen;
            END_VAR
            // Idle initialize all variables
            IF _state = IDLE THEN
                _lb := TO_INT(LOWER_BOUND(_buffer^, 1));
                _ub := TO_INT(UPPER_BOUND(_buffer^, 1));
                _state := FIND_START;
                _startFound := FALSE;
                _endFound := FALSE;
            END_IF;
            // Find start '{'
            IF _state = FIND_START THEN
                _cmd := _finder.Find(buffer := _buffer, c := '{', mode := FindeMode#MODE_FORWARD);
                IF (NOT _cmd.Busy()) THEN
                    IF (_cmd.Done()) THEN
                        _state := FIND_END;
                        _startIndex := _finder.GetIndex();
                    END_IF;
                    IF (_cmd.Error()) THEN
                        _startIndex := 0;
                        THIS.SetError();
                        _state := IDLE;
                    END_IF;
                END_IF;
            END_IF;
            IF _state = FIND_END THEN
                // Find end '}' 
                _cmd := _finder.Find(buffer := _buffer, c := '}', mode := FindeMode#MODE_REVERSE);
                IF (NOT _cmd.Busy()) THEN
                    IF (_cmd.Done()) THEN
                        _state := EVALUATE;
                        _endIndex := _finder.GetIndex();
                    END_IF;
                    IF (_cmd.Error()) THEN
                        _endIndex := 0;
                        THIS.SetError();
                        _state := IDLE;
                    END_IF;
                END_IF;
            END_IF;
            IF _state = EVALUATE THEN
                IF (_startIndex > _endIndex) THEN
                    _startIndex := 0;
                    _endIndex := 0;
                    _state := IDLE;
                    THIS.SetError();
                    RETURN;
                ELSE  // Done
                    _state := IDLE;
                    THIS.SetDone();
                    RETURN;
                END_IF;
            END_IF;
        END_METHOD
END_CLASS

END_NAMESPACE
