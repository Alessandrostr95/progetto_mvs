# Progetto MVS Cirillo & Straziota
## Introduzione
![biofilm](img/2-biofilm.jpeg)
Alcuni batteri possiedono sistemi di regolazione trascrizionale dipendenti dalla percezione della densità di cellule della stessa specie presenti nella popolazione; questo tipo di controllo è stato definito **quorum sensing** (QS). Il QS fa parte dei sistemi di controllo globale: complessi sistemi di regolazione coinvolti nei meccanismi di patogenicità e virulenza che permettono a un organismo di rispondere efficientemente ai segnali dell’ambiente, come quello rappresentato, nel caso specifico, dalla presenza di altri microrganismi della stessa specie. I batteri rilevano la presenza di altri batteri nel loro intorno producendo e rispondendo con molecole segnale conosciute come **autoinduttori**.

La molecola segnale è un induttore che diffonde all'esterno della cellula originaria, e può così entrare nel citoplasma di altre cellule adiacenti. Se la concentrazione di molecola segnale all'interno di cellule della popolazione batterica è alta (cioè, supera una certa soglia detta **quorum**), questa molecola si legherà all'attivatore trascrizionale, che a sua volta attiverà o reprimerà una serie di geni, determinando l'attivazione o lo spegnimento di vie metaboliche o processi cellulari specifici.

<!-- Queste molecole si accumulano al di fuori delle cellule microbiche e, superata una certa soglia (detta quorum), possono innescare una serie di eventi che si succedono con effetto “a cascata”. -->

Raggiunto il quorum, le molecole di **acil-omoserina-lattone (AHL)** accumulate penetrano all’interno della cellula batterica dove possono interagire con proteine citoplasmatiche capaci di legare il DNA, inducendo una variazione dell’espressione genica.
![Figura 1 – Overview del funzionamento del quorum sensing batterico](img/1-quorum-sensing.jpeg)
Si pensa che la conoscenza dei meccanismi del quorum sensing possa aiutare i microbiologi a migliorare l'azione degli antibiotici contro batteri patogeni e a ridurre l'insorgenza di mutanti.
## Definizione del modello
- Abbiamo delle entità che si vogliono sincronizzare, per semplicità, ci restringiamo al caso di 2:
- Vogliono prendere una decisione comune:
    - Entrambi passano allo stato 1 (sensing).
    - Rimangono entrambi nello stato 0 (incertezza).
    - Stato 2 - "non c'è nessuno" -> abbandono.
- La decisione deve essere presa in maniera sincrona, quindi non si vuole che le entità si trovino in stati differenti in un tempo qualsiasi $t$.
    - C'è un tempo entro il quale questo deve accadere (range di sincronizzazione).
- Per sincronizzarsi possono scambiarsi dei messaggi.
    - _A_ verso _B_ e _B_ verso _A_.
- Ci restringiamo ad un "mondo piccolo" di 4 nodi.
    - Solo un'iniziale dispersione.
- I messaggi vengono scambiati con una certa probabilità sugli archi incidenti.
    - La probabilità viene modellata come una quantità fisica (per esempio flusso o frazione di messaggio).
- I (frazioni di) messaggi vengono inviati in broadcast uniformemente sugli archi uscenti.
- Per semplicità assumiamo che il messaggio non possa mai tornare indietro sullo stesso arco -> gli archi sono diretti.
- Mandare i messaggi richiede uno sforzo di energie -> ogni nodo può quindi inviare un numero finito di messaggi.

<!-- - Conserviamo l'idea della griglia M*N, ma distribuiamo su di essa anche K
quadrati assorbenti che bloccano/assorbono la propagazione del segnale
chimico che ci arriva sopra. -->

- I due batteri che vogliono sincronizzarsi, sono posti ai due angoli opposti
della griglia.
    - Batterio _A_ in posizione 1x1 e batterio _B_ in posizione 2x2

<!-- - I batteri hanno un'energia $E$ che decrementa di $\frac{E}{S}$ (COSì ESPONENZIALMENTE??) ad ogni segnale chimico
emesso. L'energia va quindi investita al meglio. -->
- La quantità di vita è definita come il numero di messaggi che può mandare 
    - Nella simulazione assumeremo $=3$

- Il batterio _A_ invia il segnale per primo, e se _B_ lo percepisce risponde
con il suo. Quando _A_ riceve il segnale di B il sensing si è concluso con
successo. Tuttavia, possiamo considerare successo anche il caso in cui sia _A_
che _B_ "vivono" per un tempo sufficientemente lungo senza creare biofilm,
quindi non si "ammazzano" cercando solo il quorum sensing.

- L'emissione dei segnali avviene a intervalli $T$ sia per A che per B, dove $T$ non deve essere troppo piccolo per evitare di consumare tutta l'energia in un secondo.

- Il sensing richiede una certa concentrazione $C$, quindi sia _B_ (che sente il
segnale di _A_) che _A_ stesso (che sente la risposta di B) dovrebbero attivarsi
solo se la concentrazione del segnale è sufficientemente elevata. Questo
vuol dire, ad esempio, che in base al modello di diffusione del segnale
potrebbe essere necessario che A invii più volte il suo prima che B decida
di prenderlo in considerazione.
    - Semplificazione con $C≥\frac{1}{2}$, ingannevolo o no. 
    <!-- - Agente ottimista e agente pessimista. -->
<!-- - Gli agenti NON se ne vanno dal quadrato. -->

<!-- Requisiti dell'incontro 9 febbraio -->

- Se l'agente invia troppi messaggi e non c'è nessuno, esaurisce quindi la sua vita, la simulazione deve terminare con un messaggio di errore.
- L'agente ha una visione locale dell'ambiente.
- Agente prudente: manda un messaggio, aspetta un certo tempo e se non succede niente si può mettere nello stato "lasciamo perdere". Se l'altro nel frattempo risponde, non succede niente, perché in questa condizione tutte le regole sono disabilitate.
    - La simulazione considera il messaggio "non erroneo" se B non c'è.
    - B non conosce il tempo in cui A attende

<!-- Requisiti dell'incontro 31 marzo -->
<!-- - I batteri tra un messaggio e l'altro devono far passare un tempo $T$.
    - Politica opportunistica: mando un messaggio e spero che mi dica bene. -->

### Criteri di successo/insuccesso
La simulazione può terminare se almeno una delle seguenti condizioni si verifica:
- Uno dei batteri esaurisce la sua vita a disposizione
- Il tempo di simulazione raggiunge un certo tempo $T_{MAX}$ prestabilito.
- Uno dei due batteri ha lasciato la simulazione.
- Il sensing viene raggiunto

Di cui solamente l'ultima condizione è considerata <u>successo</u>.
<!-- - Lo stato erroneo è il successo.
- Nel caso non c'è nessuno, il piano giusto è stare buono.
    - Stato anomalo. -->

## Implementazione

### Setup della simulazione
- `E`: energia dei batteri
    - O numero di messaggi che possono inviare. Nel nostro caso `3`.
- `DT`: Intervallo di tempo nel quale _A_ e _B_ emettono i messaggi.
- `ST`: Synchronization time: tempo in cui, una volta che _A_ o _B_ si trova nello stato `pending` si deve raggiungere il sensing.
- `C`: concentrazione necessaria all'"attivazione" del batterio che riceve un messaggio.
- `M,N`: parametri della griglia
    - Nel nostro caso la griglia sarà una 2x2.
- `NODO_ASSORBENTE`: posizione del nodo assorbente nella griglia
    - Nella simulazione il nodo assorbente sarà il 3, ovvero quello il posizione 2x1.

### Possibili cammini di esecuzione