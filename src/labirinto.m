-- ESERCIZIO LABIRINTO


-- COSTANTI

Const
  MIN_DEG: 0;   -- minimo angolo espresso in gradi
  MAX_DEG: 360; -- massimo angolo espresso in gradi
  W: 10;        -- larghezza della griglia, espressa in numero di celle
  H: 5;         -- altezza della griglia, espressa in numero di celle
  INITIAL_X: 0; -- valore iniziale della coordinata x
  INITIAL_Y: 0; -- valore iniziale della coordinata y
  INITIAL_A: 0; -- valore iniziale dell'angolo


-- TIPI

Type
  deg_t: MIN_DEG..MAX_DEG;
  w_t: 0..W;
  h_t: 0..H;


-- VARIABILI

Var
  x: w_t;   -- coordinata x
  y: h_t;   -- coordinata y
  a: deg_t; -- angolo


-- PROCEDURE

Procedure Avanza();
Begin
	Switch a 
		Case 0:   -- angolo 0° -> avanza verso destra
      x := x + 1;
    Case 90:  -- angolo 90° -> avanza verso l'alto
      y := y + 1;
    Case 180: -- angolo 180° -> avanza verso sinistra
      x := x - 1;
    Case 270: -- angolo 270° -> avanza verso il basso
      y := y - 1; 
	Endswitch;
End;

Procedure Ruota();
Begin
  a := (a + 90) % MAX_DEG;  -- ruota di 90° in senso antiorario.
End;


-- REGOLE

Rule "Avanza"
  (a = 0 & x < W) | (a = 90 & y < H) | (a = 180 & x > 0) | (a = 270 & y > 0)
==>
Begin
  Avanza();
End;

Rule "Ruota"
  true
==>
Begin
  Ruota();
End;


-- STATO INIZIALE

Startstate  -- stato iniziale
  Begin
	  x := INITIAL_X;
    y := INITIAL_Y;
    a := INITIAL_A;
  End;


-- INVARIANTI 

Invariant "x coord in range"  -- invariante: la coordinata x deve rimanere entro i bordi
	x >= 0 & x <= W;

Invariant "y coord in range"  -- invariante: la coordinata y deve rimanere entro i bordi
  y >= 0 & y <= H;

Invariant "a in range"  -- l'angolo deve sempre essere ortogonale
  a >= 0 & a <= MAX_DEG;
