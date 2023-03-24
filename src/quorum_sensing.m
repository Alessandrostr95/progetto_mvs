-- Progetto "Quorum Sensing" By Cirillo & Straziota


-- COSTANTI

Const
  E: 3;         -- Energia dei batteri
  T: 1;         -- intervallo di tempo nel quale i batteri inviano i messaggi
  ST: 3;        -- Synchronization time
  C: 500;       -- Concentrazione necessaria per l attivazione del batterio
  T_MAX: 10;    -- Massimo tempo di sincronizzazione
  NODO_ASSORBENTE: 3;   -- Il nodo 3 è un nodo assorbente

-- TIPI

Type
  time_t: 0..T_MAX;
  concentration_t: 0..1000;
  ind_t: 1..4;
  cells_arr_t: Array[ ind_t ] Of concentration_t;
  state_t: enum{active, pending, sensing, gone, dead};
  life_t: 0..E;

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

-- PROCEDURE

Procedure InviaMessaggio( Var c : ind_t );
Begin
  Switch c 
		Case 1:   -- Cella in alto a sinistra
      If state_a = pending & life_a > 0 then
        life_a := life_a - 1;
        cells_a_b[2] := cells_a_b[1]/2;
        cells_a_b[3] := cells_a_b[1]/2;
      Else
        state_a := dead;
      Endif;
    Case 2:  -- Cella in alto a destra
      cells_a_b[4] := cells_a_b[2];
	Endswitch;
End;

Procedure InvioMessaggioDiRitorno( Var c : ind_t );
Begin
  Switch c 
		Case 1:   -- Cella in alto a sinistra
      If state_b = pending & life_b > 0 then
        life_b := life_b - 1;
        cells_b_a[2] := cells_b_a[4]/2;
        cells_b_a[3] := cells_b_a[4]/2;
      Else
        state_b := dead;
      Endif;
    Case 2:  -- Cella in alto a destra
      cells_b_a[1] := cells_b_a[2];
	Endswitch;
End;

-- REGOLE

Ruleset c : ind_t Do
  Rule "InviaMessaggio"
  --  state_a = pending & life_a > 0
    cells_a_b[c] > 0 & c != NODO_ASSORBENTE
  ==>
  Begin
    ind := c;
    InviaMessaggio(ind);
  End;
End;

Rule "StartSensing"
  cells_b_a[4] > C & state_b = active
==>
Begin
  state_b := pending;
End;

Ruleset c : ind_t Do
  Rule "InvioMessaggioDiRitorno"
  --  state_a = pending & life_a > 0
    cells_b_a[c] > 0 & c != NODO_ASSORBENTE & state_b = pending
  ==>
  Begin
    ind := c;
    InvioMessaggioDiRitorno(ind);
  End;
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
  End;


-- INVARIANTI 

Invariant "lifes greater than 0"  -- invariante: le vite dei batteri devono essere sempre maggiori di 0
	life_a > 0 & life_b > 0;