--
--  File Name:         TbSpi_SendGet0.vhd
--  Design Unit Name:  SendGet0
--  OSVVM Release:     TODO
--
--  Description:
--      SPI Mode 0 Test: Controller sends data. Peripheral receives data
--      and checks against expected value.
--

architecture SendGet0 of TestCtrl is

    signal TestDone   : integer_barrier := 1;
    signal TestActive : boolean         := TRUE;
    signal TbID     : AlertLogIDType;

begin

    ------------------------------------------------------------
    -- Bench Environment Init
    ------------------------------------------------------------
    ControlProc : process
    begin
        -- Initialization of test
        SetTestName("TbSpi_SendGet0");
        SetLogEnable(PASSED, TRUE);
        TbID <= GetAlertLogID("TB");

        -- Wait for testbench initialization
        wait for 0 ns; wait for 0 ns;
        TranscriptOpen(OSVVM_RESULTS_DIR & "TbSpi_SendGet0.txt");
        SetTranscriptMirror(TRUE) ;

        -- Wait for Design Reset
        wait until n_Reset = '1';
        ClearAlerts;

        -- Wait for test to finish
        WaitForBarrier(TestDone, 50 ms);
        AlertIf(now >= 50 ms, "Test finished due to timeout");
        AlertIf(GetAffirmCount < 1, "Test is not Self-Checking");

        TranscriptClose;

        EndOfTestReports;
        std.env.stop;
        wait;
    end process ControlProc;

    ------------------------------------------------------------
    -- SpiControllerTest: Simple
    ------------------------------------------------------------
    SpiControllerTest : process
        variable SpiControllerID  : AlertLogIDType;
        variable TransactionCount : integer := 0;

    begin
        -- Enable logging for SPI Controller and Peripheral
        GetAlertLogID(SpiControllerRec, SpiControllerID);
        SetLogEnable(SpiControllerID, INFO, TRUE);
        WaitForClock(SpiControllerRec, 2);

        -- Test Begins

        --Send sequence 1
        Send(SpiControllerRec, X"50");
        Send(SpiControllerRec, X"51");
        Send(SpiControllerRec, X"52");
        Send(SpiControllerRec, X"53");
        Send(SpiControllerRec, X"54");
        GetTransactionCount(SpiControllerRec, TransactionCount);
        AffirmIfEqual(SpiControllerID, TransactionCount,
                      5,
                      "Transaction Count");

        --Send sequence 2
        Send(SpiControllerRec, X"60");
        Send(SpiControllerRec, X"61");
        Send(SpiControllerRec, X"62");
        Send(SpiControllerRec, X"63");
        Send(SpiControllerRec, X"64");

        --Send sequence 3
        Send(SpiControllerRec, X"70");
        Send(SpiControllerRec, X"71");
        Send(SpiControllerRec, X"72");
        Send(SpiControllerRec, X"73");
        Send(SpiControllerRec, X"74");

        --Send sequence 4
        Send(SpiControllerRec, X"80");
        Send(SpiControllerRec, X"81");
        Send(SpiControllerRec, X"82");
        Send(SpiControllerRec, X"83");
        Send(SpiControllerRec, X"84");

        GetTransactionCount(SpiControllerRec, TransactionCount);
        AffirmIfEqual(SpiControllerID, TransactionCount,
                      20,
                      "Transaction Count");

        -- Test ends
        TestActive <= FALSE;
        WaitForBarrier(TestDone);
        wait;
    end process SpiControllerTest;

    ------------------------------------------------------------
    -- SpiControllerTest: Simple
    ------------------------------------------------------------
    SpiPeripheralTest : process
        variable SpiPeripheralId    : AlertLogIDType;
        variable Received, Expected : std_logic_vector (7 downto 0);
        variable TransactionCount   : integer := 0;
        variable SpiModeOrLoopNum : integer := 0;

    begin

    GetAlertLogID(SpiPeripheralRec,  SpiPeripheralId);
    SetLogEnable(SpiPeripheralId, INFO, TRUE);
    WaitForClock(SpiPeripheralRec, 2);

    -- Test Begins

    -- Receive sequence 1
    for i in 1 to 5 loop
        case i is
        when 1 =>  Expected := (X"50");
        when 2 =>  Expected := (X"51");
        when 3 =>  Expected := (X"52");
        when 4 =>  Expected := (X"53");
        when 5 =>  Expected := (X"54");
        end case ;
        Get(SpiPeripheralRec, Received);
        AffirmIfEqual(SpiPeripheralID, Received, Expected);
    end loop;

    -- Receive sequence 2
    for i in 1 to 5 loop
        case i is
        when 1 =>  Expected := (X"60");
        when 2 =>  Expected := (X"61");
        when 3 =>  Expected := (X"62");
        when 4 =>  Expected := (X"63");
        when 5 =>  Expected := (X"64");
        end case ;
    Get(SpiPeripheralRec, Received);
    AffirmIfEqual(SpiPeripheralID, Received, Expected);
    end loop;

    -- Receive sequence 3
    for i in 1 to 5 loop
        case i is
        when 1 =>  Expected := (X"70");
        when 2 =>  Expected := (X"71");
        when 3 =>  Expected := (X"72");
        when 4 =>  Expected := (X"73");
        when 5 =>  Expected := (X"74");
        end case ;
    Get(SpiPeripheralRec, Received);
    AffirmIfEqual(SpiPeripheralID, Received, Expected);
    end loop;

    -- Receive sequence 4
    for i in 1 to 5 loop
        case i is
        when 1 =>  Expected := (X"80");
        when 2 =>  Expected := (X"81");
        when 3 =>  Expected := (X"82");
        when 4 =>  Expected := (X"83");
        when 5 =>  Expected := (X"84");
        end case ;
    Get(SpiPeripheralRec, Received);
    AffirmIfEqual(SpiPeripheralID, Received, Expected);
    end loop;

    -- Receive sequence 5
    for i in 1 to 5 loop
        case i is
        when 1 =>  Expected := (X"80");
        when 2 =>  Expected := (X"81");
        when 3 =>  Expected := (X"82");
        when 4 =>  Expected := (X"83");
        when 5 =>  Expected := (X"84");
        end case ;
    end loop;

    -- Test Done
    WaitForBarrier(TestDone);
    wait;
    end process SpiPeripheralTest;
end SendGet0;

configuration TbSpi_SendGet0 of TbSpi is
    for TestHarness
        for TestCtrl_1 : TestCtrl
            use entity work.TestCtrl(SendGet0);
        end for;
    end for;
end TbSpi_SendGet0;