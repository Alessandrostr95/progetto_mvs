# 09/02
- Se l'agente invia 3 messaggi e non c'è nessuno, murphi deve dare errore.
- L'agente ha una visione locale.
- Un agente prudente manda un certo messaggio, se dopo un certo tempo non riceve risposta, ne manda un secondo al massimo ma può entrare in uno stato "lasciamo perdere".
    - Murphi considera il messaggio "non erroneo" se B non c'è.
- Agente prudente: manda un messaggio, aspetta un certo tempo e se non succede niente si mette nello stato "lasciamo perdere". Se l'altro nel frattempo risponde, non succede niente, perché in questa condizione tutte le regole sono disabilitate.
    - B non conosce il tempo in cui A attende

# 31/03
- I batteri tra un messaggio e l'altro devono far passare un tempo $T$.
    - Politica opportunistica: mando un messaggio e spero che mi dica bene.
- 