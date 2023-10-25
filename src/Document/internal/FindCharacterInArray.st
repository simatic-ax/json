NAMESPACE Simatic.Ax.Json

    CLASS INTERNAL FindCharacterInArray
        EXTENDS Command
        VAR PUBLIC
        END_VAR
        VAR PROTECTED
            _buffer : REF_TO ARRAY[*] OF CHAR;
            _charToFind : CHAR;
            _mode : FindeMode;
            _index : INT;
            _found : BOOL;
        END_VAR

        METHOD INTERNAL Find : IPlcOpen
            VAR_INPUT
                Buffer : REF_TO ARRAY[*] OF CHAR;
                c : CHAR;
                Mode : FindeMode;
            END_VAR
            VAR_OUTPUT
                Index : DINT;
            END_VAR
            _buffer := Buffer;
            _mode := Mode;
            _charToFind := c;
            THIS.InitState();
            THIS.Execute();
            Find := THIS;
            
        END_METHOD

        METHOD PROTECTED OVERRIDE Execute
            VAR_TEMP
                index : INT;
                _lb, _ub : INT;
            END_VAR
            _lb := TO_INT(LOWER_BOUND(_buffer^, 1));
            _ub := TO_INT(UPPER_BOUND(_buffer^, 1));
            CASE _mode OF
                FindeMode#MODE_FORWARD:
                    FOR index := _lb TO _ub DO
                        IF (_buffer^[index] = _charToFind) THEN
                            _index := index;
                            THIS.SetDone();
                            EXIT;
                        END_IF;
                        THIS.SetError();
                    END_FOR;
                    
                FindeMode#MODE_REVERSE:
                    FOR index := _ub TO _lb BY -1 DO
                        IF (_buffer^[index] = _charToFind) THEN
                            _index := index;
                            THIS.SetDone();
                            EXIT;
                        END_IF;
                        THIS.SetError();
                    END_FOR;
                    
            END_CASE;
        END_METHOD

        METHOD PUBLIC GetIndex : INT
            GetIndex := _index;
        END_METHOD
    END_CLASS

    TYPE
        FindeMode : (MODE_FORWARD, MODE_REVERSE);
    END_TYPE

END_NAMESPACE
