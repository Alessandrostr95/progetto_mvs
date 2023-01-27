Const
  MIN_DEG: 0;
  MAX_DEG: 360;
  W: 10;
  H: 5;
  INITIAL_X: 0;
  INITIAL_Y: 0;
  INITIAL_A: 0;

Type
  deg_t: MIN_DEG..MAX_DEG;
  w_t: 0..W;
  h_t: 0..H;

Var
  x: w_t;
  y: h_t;
  a: deg_t;

Procedure Avanza();
Begin
	Switch a 
		Case 0:
      x := x + 1;
    Case 90:
      y := y + 1;
    Case 180:
      x := x - 1;
    Case 270:
      y := y - 1; 
	Endswitch;
End;

Procedure Ruota();
Begin
  a := (a + 90) % MAX_DEG;
End;


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

Startstate
  Begin
	  x := INITIAL_X;
    y := INITIAL_Y;
    a := INITIAL_A;
  End;

Invariant "x coord in range"
	x >= 0 & x <= W;

Invariant "y coord in range"
  y >= 0 & y <= H;

Invariant "a in range"
  a >= 0 & a <= MAX_DEG;
