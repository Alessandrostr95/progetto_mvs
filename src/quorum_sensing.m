-- Progetto "Quorum Sensing" By Cirillo & Straziota


-- COSTANTI

Const
  E: 3;                 -- Energia dei batteri
  DT: 4;                -- intervallo di tempo nel quale i batteri inviano i messaggi
  ST: 9;                -- Synchronization time
  C: 500;               -- Concentrazione necessaria per l attivazione del batterio
  T_MAX: 10;            -- Massimo tempo di simulazione
  NODO_ASSORBENTE: 3;   -- Il nodo 3 è un nodo assorbente
  L: 10;                 -- Tempo parametrizzato in cui A è disposto ad aspettare

-- TIPI

Type
  time_t: 0..T_MAX;
  concentration_t: 0..1000;
  ind_t: 1..4;
  cells_arr_t: Array[ ind_t ] Of concentration_t;
  state_t: enum{active, pending, sensing, gone, dead};
  life_t: 0..E;
  synchronization_time_t: 0..ST;

-- VARIABILI

Var
  t: time_t;          -- current simulation time
  cells_a_b: cells_arr_t; -- Array di concentrazione nelle rispettive celle per il messaggio da A a B
  cells_b_a: cells_arr_t; -- Array di concentrazione nelle rispettive celle per il messaggio da B a A
  state_a: state_t;   -- Stato in cui si trova A
  state_b: state_t;   -- Stato in cui si trova B
  life_a: life_t;     -- Vita del batterio A
  life_b: life_t;     -- Vita del batterio B
  ind: ind_t;
  synchronization_time_a: synchronization_time_t; -- Countdown per la sincronizzazione di A
  synchronization_time_b: synchronization_time_t; -- Countdown per la sincronizzazione di B

-- PROCEDURE

-- Invia il messaggio "in andata". c: indice della cella 
Procedure InviaMessaggio( Var c : ind_t );
Begin
  Switch c 
		Case 1:   -- Cella in alto a sinistra
      If state_a = pending & life_a > 0 & synchronization_time_a % DT = 0 then
        life_a := life_a - 1;
        cells_a_b[2] := cells_a_b[1]/2;
        cells_a_b[3] := cells_a_b[1]/2;
      Elsif life_a =0 then
        state_a := dead;
      Endif;
    Case 2:  -- Cella in alto a destra
      cells_a_b[4] := cells_a_b[2];
      cells_a_b[2] := 0;
	Endswitch;
End;

-- Invia il messaggio "di ritorno". c: indice della cella 
Procedure InvioMessaggioDiRitorno( Var c : ind_t );
Begin
  Switch c 
		Case 4:   -- Cella in basso a destra
      If state_b = pending & life_b > 0 & synchronization_time_b % DT = 0 then
        life_b := life_b - 1;
        cells_b_a[2] := cells_b_a[4]/2;
        cells_b_a[3] := cells_b_a[4]/2;
      Elsif life_b = 0 then
        state_b := dead;
      Endif;
    Case 2:  -- Cella in alto a destra
      cells_b_a[1] := cells_b_a[2];
      cells_b_a[2] := 0;
	Endswitch;
End;

-- Nel momento in cui almeno uno dei due è in pending, inizia il rispettivo countdown per il tempo di sincronizzazione

Procedure TickSynchronizationTime();
Begin
  If state_a = pending then
    synchronization_time_a := synchronization_time_a + 1;
  Endif;
  If state_b = pending then
    synchronization_time_b := synchronization_time_b + 1;
  Endif;
End;

-- REGOLE

-- Per ogni cella, regola dell'invio dell'informazione
Ruleset c : ind_t Do
  Rule "InviaMessaggio"
  --  state_a = pending & life_a > 0
    cells_a_b[c] > 0 & c != NODO_ASSORBENTE
  ==>
  Begin
    ind := c;
    InviaMessaggio(ind);
    t := t + 1; -- aumento del tempo di simulazione
    TickSynchronizationTime();
  End;
End;

-- B inivia il sensing
Rule "StartSensing"
  cells_a_b[4] >= C & state_b = active
==>
Begin
  state_b := pending;
  t := t + 1;
  TickSynchronizationTime();
End;

-- Per ogni cella, regola del messaggio di ritorno
Ruleset c : ind_t Do
  Rule "InvioMessaggioDiRitorno"
  --  state_a = pending & life_a > 0
    cells_b_a[c] > 0 & c != NODO_ASSORBENTE & state_b = pending
  ==>
  Begin
    ind := c;
    InvioMessaggioDiRitorno(ind);
    t := t + 1; -- aumento del tempo di simulazione
    TickSynchronizationTime();
  End;
End;

-- A raggiunge il sensing
Rule "SensingAchieved_A"
  state_a = pending & cells_b_a[1] >= C
==>
Begin
    state_a := sensing;
    t := t + 1;
    TickSynchronizationTime();
End;

-- B raggiunge il sensing
Rule "SensingAchieved_B"
  state_b = pending & synchronization_time_b = 0
==>
Begin
    state_b := sensing; 
    t := t + 1;
    TickSynchronizationTime();
End;

-- A se ne va se è in pending ed ha aspettato un certo tempo L
Rule "Gone"
  state_a = pending & synchronization_time_a = L
==>
  Begin
    state_a := gone;
    t := t + 1;
    TickSynchronizationTime();
End;


-- STATO INIZIALE

Startstate  -- stato iniziale
  Begin
    t := 0;
    life_a := E;
    life_b := E;
	  state_a := pending;
    state_b := active;
    For i: ind_t do
      cells_a_b[i] := 0;
      cells_b_a[i] := 0;
    End;
    cells_a_b[1] := 1000;
    cells_b_a[4] := 1000;
    synchronization_time_a := 0;
    synchronization_time_b := 0;
  End;


-- INVARIANTI 

Invariant "all alive"  -- invariante: le vite dei batteri devono essere sempre maggiori di 0
	state_a != dead & state_b != dead;

Invariant "sensing achieved" -- il sensing non è stato raggiunto
  state_a != sensing & state_b != sensing;

Invariant "time not expired" -- il tempo della simulazione è ≤ di T_MAX
  t <= T_MAX;

Invariant "nobody gone" -- Nessuno se n'è andato
  state_a != gone & state_b != gone;