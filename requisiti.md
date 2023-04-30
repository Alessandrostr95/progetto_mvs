# Progetto MVS Cirillo & Straziota

## Introduzione

![biofilm](img/2-biofilm.jpeg)

Alcuni batteri possiedono sistemi di regolazione trascrizionale dipendenti dalla percezione della densità di cellule della stessa specie presenti nella popolazione.
Questo tipo di controllo è stato definito **quorum sensing** (QS).
Il QS fa parte dei sistemi di controllo globale: complessi sistemi di regolazione coinvolti nei meccanismi di patogenicità e virulenza che permettono a un organismo di rispondere efficientemente ai segnali dell'ambiente come quello rappresentato, nel caso specifico, dalla presenza di altri microrganismi della stessa specie.
I batteri rilevano la presenza di altri batteri nel loro intorno tramite la ricezione di **messaggi** sottoforma di **molecole segnale**, conosciute anche come **autoinduttori**.

La molecola segnale si diffonde all'esterno della cellula originaria, e può così entrare nel citoplasma di altre cellule adiacenti.
Se la concentrazione di molecole segnale all'interno di cellule della popolazione batterica è alta (cioè, supera una certa soglia detta **quorum**), questa molecola si legherà all'attivatore trascrizionale, che a sua volta attiverà o reprimerà una serie di geni, determinando l'attivazione o lo spegnimento di vie metaboliche o processi cellulari specifici.

<!-- Queste molecole si accumulano al di fuori delle cellule microbiche e, superata una certa soglia (detta quorum), possono innescare una serie di eventi che si succedono con effetto “a cascata”. -->

Raggiunto il quorum, le molecole di **acil-omoserina-lattone (AHL)** accumulate penetrano all'interno della cellula batterica dove possono interagire con proteine citoplasmatiche capaci di legare il DNA, inducendo una variazione dell'espressione genica.

![Figura 1 – Overview del funzionamento del quorum sensing batterico](img/1-quorum-sensing.jpeg)

Si pensa che la conoscenza dei meccanismi del quorum sensing possa aiutare i microbiologi a migliorare l'azione degli antibiotici contro batteri patogeni e a ridurre l'insorgenza di mutazioni.

## Introduzione 2
Il quorum sensing è un processo di comunicazione tra batteri che si basa sulla produzione e la rilevazione di segnali molecolari chiamati autoinduttori. Questi segnali vengono prodotti dai batteri e diffondono nell'ambiente circostante. Quando la concentrazione di autoinduttori raggiunge una certa soglia, detta "**quorum**", i batteri sono in grado di rilevare la presenza degli altri membri della loro stessa specie e di coordinare il loro comportamento in modo da agire come una collettività.

Il **quorum sensing** permette ai batteri di regolare l'espressione di specifici geni in risposta a segnali ambientali, come la densità della popolazione batterica o la presenza di nutrienti. Questo processo è stato osservato in molte specie batteriche e gioca un ruolo importante in diverse funzioni biologiche, come la formazione di biofilm, la virulenza e la produzione di composti metabolici.

Ad esempio, nel caso della formazione di biofilm, il quorum sensing permette ai batteri di coordinare la produzione di una matrice extracellulare che li tiene insieme, formando una struttura protettiva che li aiuta a resistere alle condizioni avverse dell'ambiente circostante, come l'azione degli agenti antimicrobici.

In sintesi, il **quorum sensing** è un importante processo di comunicazione tra batteri che permette loro di coordinare il loro comportamento in risposta alle condizioni ambientali, migliorando la loro capacità di adattamento e la loro sopravvivenza.

## Definizione del modello
Abbiamo modellizato il quorum sensing come un sistema **multiagente**, in cui ogni agente rappresenta un batterio e le interazioni tra gli agenti sono modellate come messaggi scambiati tra essi.

Nel nostro caso abbiamo considerato due agenti, `A` e `B`, che vogliono **sincronizzarsi**.
Per sincronizzarsi, gli agenti devono prendere una decisione comune, che può essere presa in maniera sincrona o asincrona.
Nel nostro caso, gli agenti devono prendere una decisione comune in un dato **tempo finito**.

Il sistema è modellato come un **grafo a griglia bidimensionale** (nel nostro caso una griglia 2x2).
Ogni agente è rappresentato da un nodo del grafo, e gli archi rappresentano le interazioni tra gli agenti.
Gli agenti possono scambiarsi dei messaggi, che vengono inviati in broadcast uniformemente sugli archi uscenti.
Perciò quando un agente invia un messaggio, la 
**concentrazione** del messaggio verrà distribuita uniformemente su tutti i suoi archi incidenti.

![](./img/img1.png)

Nel contesto reale, inviare un messaggio richiede un certo impiego di energia da parte dei batteri.
Essi infatti non possono inviare messaggi in maniera illimitata, ma devono in qualche dosare la quantità di messaggi inviati (per non rischiare di morire).
Per questo motivo, abbiamo introdotto un parametro `E` (`Energy`) che rappresenta la quantità massima di messaggi che un agente può inviare.

È ragionevole pensare che ogni agente non invii tutti i suoi messaggi ripetutamente, ma che invece **attenda** un certo tempo tra un messaggio e l'altro nel caso in cui non riceva risposta.
Questo tempo di attesa è rappresentato dal parametro `DT` (`Delta Time`).

Ogni agente ha un **stato** interno.
Inizialmente gli agenti si trovano in uno stato `active`, in cui sono in grado di scambiarsi messaggi tra loro.
La simulazione inizia quando l'agente `A` cerca di sincronizzarsi con l'agente `B`, passando quindi allo stato `pending`.
Nello stato `pending`, l'agente `A` invia messaggi in **broadcast** agli agenti vicini.

Nel momento in cui `A` inizia a inviare messaggi, inizia un *countdown* che rappresenta il tempo che l'agente `A` è disposto ad aspettare per ricevere una risposta da parte di `B`.
Tale tempo è rappresentato dal parametro `ST` (`Sync Time`).
Se `A` invia tutti i suoi messaggi **prima** della fine del *countdown*, allora `A` passa allo stato `dead`, che rappresenta una condizione in cui `A` ha esaurito tutte le sue risorse e non è più in grado di inviare messaggi.

Se `A` riceve una risposta da parte di `B` prima che il *countdown* termini, allora `A` passa allo stato finale `sensing`, che rappresenta una condizione in cui il quorum è stato raggiunto e quindi `A` decide di creare il **biofilm**.
Se invece `A` non riceve una risposta da parte di `B` prima che il *countdown* termini, allora `A` passa ad uno stato di **abbandono** `gone`, che rappresenta una condizione in cui il quorum non è stato raggiunto e quindi `A` decide di non creare il biofilm.

In un contesto reale, potrebbe capitare che un batterio abbandoni in un qualsiasi momento.
Abbiamo modellizzato questo comportamento introducendo un parametro `L` (`Leaving`) che rappresenta l'istante in cui l'agente `A` decide di abbandonare, passando quindi allo stato `gone`.

L'agente `B` invece, non può abbandonare, ma può solo decidere di sincronizzarsi con `A` oppure no.
L'agente `B` decide di sincronizzarsi con `A` se riceve sufficiente **concentrazione** di messaggi da parte di `A`.
Questo comportamento è modellizzato dal parametro `C` (`Concentration`), che rappresenta la concentrazione **minima** di messaggi che `B` deve ricevere da `A` per iniziare la sincronizzazione.

Quando `B` riceve sufficiente concentrazione allora passa dallo stato `active` allo stato `pending`, in cui inizia a inviare **messaggi di risposta** in broadcast.
Anche `B` è soggetto a:

- un *countdown*, parametrizzato da `ST`.
- un tempo di attesa tra un messaggio e l'altro, parametrizzato da `DT`.
- un numero massimo di messaggi inviabili, parametrizzato da `E`.
- se `B` invia tutti i suoi messaggi prima della fine del *countdown*, allora `B` passa allo stato `dead`.

Alla fine del *countdown*, `B` passa dallo stato `pending` allo stato `sensing`.

Il tempo viene scandito discretamente da un **clock** `t`.
La simulazione ha un tempo massimo di esecuzione, parametrizzato da `T_MAX` (`Time Max`).
Se alla fine della simulazione `A` e `B` si trovano entrambi nello stato `sensing`, allora la simulazione è considerata **terminata con successo**.
Un'altra condizione di **successo** è quando `A` si trova nello stato `gone` e `B` si trova nello stato `active` (ovvero nessuno ha initato la sincronizzazione).
In tutti gli altri casi, la simulazione è considerata **fallita**.

Ricapitolando, i parametri che modellano il sistema sono:

- `E` (`Energy`): quantità massima di messaggi inviabili da un agente.
- `DT` (`Delta Time`): tempo di attesa tra un messaggio e l'altro.
- `ST` (`Sync Time`): tempo massimo di attesa per ricevere una risposta.
- `L` (`Leaving`): istante in cui `A` decide di abbandonare.
- `C` (`Concentration`): concentrazione minima di messaggi da ricevere per iniziare la sincronizzazione.
- `T_MAX` (`Time Max`): tempo massimo di esecuzione della simulazione.

### Inoltrare messaggi
La concentrazione dei messaggi in realtà modellizza la **probabilità** che un messaggio venga inviato.
Si sta quindi modellizzando la probabilità come una **quantità fisica**.

Quindi anziché eseguire una simulazione **stocastica**, in cui ogni volta che un agente invia un messaggio viene estratto il *destinatario* in maniera uniforme, distribuiamo porzioni messaggio in maniera uniforme tra i vicini del mittente.

Questo approccio ci permette di eseguire una simulazione in maniera deterministica **deterministica**.

Infatti la concentrazione di messaggio che riceverà il nodo `B` sarà esattamente pari alla **probabilità** che `B` riceva un messaggio da `A` nel modello stocastico.

Consideriamo come esempio il seguente grafo:

![](./img/img2.png)

Supponiamo che `A` invii un solo messaggio.
Siano gli eventi:

- $\mathcal{E}_1$: `A` invia il messaggio a `X`.
- $\mathcal{E}_2$: `X` invia il messaggio a `B`.
- $\mathcal{E}_3$: `B` riceve il messaggio.

Perciò la probabilità che il messaggio arrivi a `B` se ogni nodo lo invia con probabilità uniforme è:

$$P(\mathcal{E}_3) = P(\mathcal{E}_1 \cap \mathcal{E}_2) = P(\mathcal{E}_1) \cdot P(\mathcal{E}_2) = \frac12 \cdot \frac12 = \frac14$$

Consideriamo ora il modello deterministico.
Il nodo `A` inviera $1/2$ di concentrazione a `X` e $1/2$ di concentrazione a `Y`.
Dopodiché, `X` invierà $(1/2) \cdot (1/2) = 1/4$ di concentrazione a `B` e $(1/2) \cdot (1/2) = 1/4$ di concentrazione a `W`.
In totale `B` avrà ricevuto $1/4$ di concentrazione, ovvero proprio $P(\mathcal{E}_3)$.

![](./img/img3.png)


### Condizioni Avverse
In un contesto reale, potrebbe capitare che un messaggio venga perso durante la trasmissione oppure che semplicemente non venga inoltrato.

Per modellizzare questo comportamento, abbiamo introdotto la possibilità di definire dei **nodi avversi** o **nodi assrbenti**.

Un nodo assorbente è un nodo che non inoltra mai la concentrazione che riceve.

### Dettagli modello
Le condizioni e assunzioni che abbiamo fatto per il modello sono le seguenti:

- Assumiamo che i messaggi non vengano rinviati sullo stesso arco da cui sono stati ricevuti.
- Il grafo è una **grigli bidiensionale** 2x2.
- Solo gli agenti `A` e `B` sono soggetti alle dinamiche descritte predentemente. Gli altri due nodi sono "*passivi*", si limitano a ricevere messaggi e a inviarli (eventualmente).
- L'agente `A` è posto nel nodo in alto a sinistra, mentre `B` è posto nel nodo in basso a destra.
- Esiste un solo *nodo assorbente*, posto in basso a sinistra.

![Modello](./img/img4.png)

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