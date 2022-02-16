USING AxUnit.Assert;
USING System.Strings;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestCompareArrayOfChar
        VAR
            a0_4_abcde : ARRAY[0..4] OF CHAR := ['a', 'b', 'c', 'd', 'e'];
            a0_4_abcdf : ARRAY[0..4] OF CHAR := ['a', 'b', 'c', 'd', 'f'];
            a0_4_12345 : ARRAY[0..4] OF CHAR := ['1', '2', '3', '4', '5'];
            a2_6_abcde : ARRAY[2..6] OF CHAR := ['a', 'b', 'c', 'd', 'e'];
            a2_6_12345 : ARRAY[2..6] OF CHAR := ['1', '2', '3', '4', '5'];
            a0_2_abc : ARRAY[0..2] OF CHAR := ['a', 'b', 'c'];
        END_VAR
        
        {Test}
        METHOD PUBLIC Copare_same_ArrayWithLengt5_Expect_TRUE
            VAR_TEMP
                res : BOOL;
            END_VAR
            res := CompareArray(a0_4_abcde, a0_4_abcde, 5);
            Equal(expected := TRUE, actual := res);

            res := CompareArray(a2_6_abcde, a2_6_abcde, 5);
            Equal(expected := TRUE, actual := res);
        END_METHOD

        {Test}
        METHOD PUBLIC Copare_different_ArrayWithLengt5_Expect_FALSE
            VAR_TEMP
                res : BOOL;
            END_VAR
            res := CompareArray(a0_4_abcde, a2_6_12345, 5);
            Equal(expected := FALSE, actual := res);

            res := CompareArray(a2_6_abcde, a0_4_12345, 5);
            Equal(expected := FALSE, actual := res);

            res := CompareArray(a0_4_abcde, a0_4_abcdf, 5);
            Equal(expected := FALSE, actual := res);

        END_METHOD

        
        {Test}
        METHOD PUBLIC Copare_different_ArrayWithLengt4_Expect_TRUE
            VAR_TEMP
                res : BOOL;
            END_VAR

            res := CompareArray(a0_4_abcde, a0_4_abcdf, 4);
            Equal(expected := TRUE, actual := res);

        END_METHOD

        {Test}
        METHOD PUBLIC Copare_same_ArrayWithLengt4_Expect_TRUE
            VAR_TEMP
                res : BOOL;
            END_VAR
            res := CompareArray(a0_4_abcde, a0_4_abcde, 4);
            Equal(expected := TRUE, actual := res);

            res := CompareArray(a2_6_abcde, a2_6_abcde, 4);
            Equal(expected := TRUE, actual := res);
        END_METHOD

        {Test}
        METHOD PUBLIC Copare_mixed_indices_ArrayWithLengt5_Expect_TRUE
            VAR_TEMP
                res : BOOL;
            END_VAR
            res := CompareArray(a0_4_abcde, a2_6_abcde, 5);
            Equal(expected := TRUE, actual := res);
        END_METHOD

        {Test}
        METHOD PUBLIC Copare_different_ArrayWithLengt4_Expect_FALSE
            VAR_TEMP
                res : BOOL;
            END_VAR
            res := CompareArray(a0_4_abcde, a2_6_12345, 4);
            Equal(expected := FALSE, actual := res);

            res := CompareArray(a2_6_abcde, a0_4_12345, 4);
            Equal(expected := FALSE, actual := res);
        END_METHOD

        {Test}
        METHOD PUBLIC Copare_different_lenght_ArrayWithLengt5_and_3_Expect_TRUE
            VAR_TEMP
                res : BOOL;
            END_VAR
            res := CompareArray(a0_4_abcde, a0_2_abc, 2);
            Equal(expected := TRUE, actual := res);

            res := CompareArray(a0_2_abc, a0_4_abcde, 2);
            Equal(expected := TRUE, actual := res);
            
            res := CompareArray(a0_4_abcde, a0_2_abc, 3);
            Equal(expected := TRUE, actual := res);

            res := CompareArray(a0_2_abc, a0_4_abcde, 3);
            Equal(expected := TRUE, actual := res);

            res := CompareArray(a0_4_abcde, a0_2_abc, 4);
            Equal(expected := FALSE, actual := res);

            res := CompareArray(a0_2_abc, a0_4_abcde, 4);
            Equal(expected := FALSE, actual := res);

            res := CompareArray(a0_4_abcde, a0_2_abc, 5);
            Equal(expected := FALSE, actual := res);

            res := CompareArray(a0_2_abc, a0_4_abcde, 5);
            Equal(expected := FALSE, actual := res);

            res := CompareArray(a0_4_abcde, a0_2_abc, 6);
            Equal(expected := FALSE, actual := res);

            res := CompareArray(a0_2_abc, a0_4_abcde, 6);
            Equal(expected := FALSE, actual := res);

        END_METHOD

    END_CLASS
END_NAMESPACE