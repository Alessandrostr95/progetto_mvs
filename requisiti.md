# Progetto MVS Cirillo & Straziota
## Analisi dei requisiti
- Abbiamo delle entità che si vogliono sincronizzare, per semplicità, 2:
- Vogliono prendere una decisione comune:
    - Entrambi passano allo stato 1
    - Rimangono entrambi nello stato 0.
- La decisione deve essere presa in maniera sincrona, quindi non si vuole che le entità si trovino in stati differenti in un tempo qualsiasi $t$.
- Per sincronizzarsi possono scambiarsi dei messaggi.
- Scambio i messaggi con una certa probabilità sugli archi incidenti.
    - La probabilità viene modellata come una quantità fisica (per esempio flusso o frazione di messaggio).
- I (frazioni di) messaggi vengono inviati in broadcast uniformemente sugli archi uscenti.
- Per semplicità assumiamo che il messaggio non possa mai tornare indietro sullo stesso arco -> gli archi sono diretti (DAG??).
- Mandare i messaggi richiede uno sforzo di energie -> ogni nodo può quindi inviare un numero finito di messaggi ($k$ fissato??).

- Conserviamo l'idea della griglia M*N, ma distribuiamo su di essa anche K
quadrati assorbenti che bloccano/assorbono la propagazione del segnale
chimico che ci arriva sopra.

- I batteri ovviamente restano due, piazzati direi a due angoli opposti
della griglia.

- I batteri hanno un'energia $E$ che decrementa di $\frac{E}{S}$ (COSì ESPONENZIALMENTE??) ad ogni segnale chimico
emesso. L'energia va quindi investita al meglio.

- Il batterio _A_ invia il segnale per primo, e se _B_ lo percepisce risponde
con il suo. Quando _A_ riceve il segnale di B il sensing si è concluso con
successo. Tuttavia, possiamo considerare successo anche il caso in cui sia _A_
che _B_ "vivono" per un tempo sufficientemente lungo senza creare biofilm,
quindi non si "ammazzano" cercando solo il quorum sensing.

- L'emissione dei segnali avviene a intervalli $T$ sia per A che per B (oppure
T1 per A e T2 per B, a seconda del loro stato), dove T non deve essere
troppo piccolo per evitare di bruciarsi tutto in un secondo.

- Il sensing richiede una certa concentrazione C, quindi sia B (che sente il
segnale di A) che A stesso (che sente la risposta di B) dovrebbero attivarsi
solo se la concentrazione del segnale è sufficientemente elevata. Questo
vuol dire, ad esempio, che in base al modello di diffusione del segnale
potrebbe essere necessario che A invii più volte il suo prima che B decida
di prenderlo in considerazione.

- Infine, c'è una certa probabilità P che A, dopo aver emesso un segnale, se
ne vada dal quadrato di gioco. In questo caso B dovrà stare molto attento a
non attivarsi subito e spendere tutta la propria energia in risposte, perchè
andrebbe persa.

## Setup della simulazione
- _M,N_: parametri della griglia
- _K_: # di quadrati assorbenti
- _E_: energia dei batteri
- _S_: Coefficiente di decrescita di energia E.
- _P_: Probabilità che A se ne vada.
- _T_: Intervallo di tempo nel quale _A_ e _B_ emettono i messaggi.
- _C_: Threshould di attivazione del sensing.