Orders

Pentru introducerea comenzilor intr-un restaurant, o firma s-a gandit la un sistem client-server.
Serverul expune prin http (localhost:3000) un API REST peste resursele MenuItem si OrderItem.
Un MenuItem este reprezentat prin: code - numar intreg, name - sir de caractere.
Un OrderItem reprezinta informatii despre un element comandat la o anume masa: code - codul elementului
din meniu, quantity - numar intreg, table - masa de la care s-a comandat, free - boolean.
Dezvoltati o aplicatie mobila (client) dupa cum urmeaza.

1. Aplicatia client este un Proof of Concept, astfel este setata (hardcoded) masa 1 (table = 1).
Aplicatia prezinta starea conectivitatii device-ului (online sau offline).

2. Pentru a comanda un element din meniu, utilizatorul introduce cateva
caractere din numele elementului. Dupa 2 secunde de la ultimul caracter introdus aplicatia
afiseaza primele 5 elemente de meniu care au in nume secventa de caractere introdusa.

3. Daca device-ul este online, elementele din meniu de la (2) sunt aduse de pe server, via http
GET /MenuItem?q=c, unde c este secventa de caractere introdusa de utilizator.

4. Daca device-ul este offline, elementele din meniu de la (2) sunt dintre cautarile facute de utilizator
anterior, cand era online. Adica, aplicatia face cache in memorie la toate elementele returnate anterior
la (3).

5. Utilizatorul selecteaza un element, introduce cantitatea si declanseaza un buton 'Order'
pentru a adauga un OrderItem in lista de elementelor comandata. Aceasta lista este prezentata
in interfata cu utilizatorul.

6. Daca device-ul este online, aplicatia client va trimite elementul comandat la (5) prin http POST /OrderItem,
incluzand in corpul cererii { table, code, quantity, free: false }.

7. Daca device-ul este offline sau operatia de la (6) esueaza, aplicatia va indica in lista faptul ca elementul
comandat nu a fost trimis pe server. In mod automat, cand device-ul devine online aplicatia va reincerca
transmiterea elementelor comandate si netrimise inca pe server.

8. Aplicatia persista local elementele comandate, astfel daca utilizatorul inchide aplicatia,
elementele comandate vor fi afisate la repornirea aplicatiei.

9. Serverul emite notificari prin ws pe localhost:3000. O notificare contine un element din meniu oferit free
de restaurant. La primirea unei notificari, aplicatia client va afisa timp de 3 secunde un 'special offer',
precizand elementul din meniu oferit si va permite utilizatorului sa faca click pe acea oferta pentru a inregistra
{ table, code, quantity: 1, free: true }
