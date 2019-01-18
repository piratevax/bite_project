# RDV 14/01/19

* git
* répartition

## Schéma fonctionnel

À faire

* lien fonction packages
* lien interface

## CDC

### format

imposer en-tête :
* id
* baseMean
* l2fc
* pval
* pval-adj

### Interface

* choix espèce : menu déroulant (BioMart) OK (Sophia, 18/01/19)

## État des lieux

### Input

* header : inutile OK (Sophia, 18/01/19)
* Sources : OK (Sophia, 18/01/19)
	* inutile
	* besoin de transparence pour user
* ajout menu déroulant espèce OK (Sophia, 18/01/19)

## Onglets

* développer les noms OK (Sophia, 18/01/19)
* ajout onglet domaines OK (Sophia, 18/01/19)

### WDI

* algo HS
* curseur p-val/FC OK (Sophia, 18/01/19)
* méthode ajustement du seuil (ne pas seuiller sur p-val) OK (Sophia, 18/01/19)
* figure interactive (pas prioritaire)
* tableau ajusté (pas prioritaire)

### GOE

* liste bdd interrogée par le package (pertinence ?) OK (Sophia, 18/01/19)
* GO term level -> GO term Ontology OK (Sophia, 18/01/19)
* EA :
	* suppr MEA OK (Sophia, 18/01/19)
	* implémentation :
		* implémentation ClusterProfiler (méthodes)
		* SEA (fonctions, code global)
		* récupération nom des domaines

### Pathway

* tableau liste pathway
* sélection nom -> apparition du graph
* affichage par défaut
* Complexité supplémentaire pour les domaines ? (r. pour 18/01)
	* une protéine peut avoir plusieurs domaines



# RDV 18/01/19

obj : Focntionnement de ClusterProfiler pour l'annotation des domaines et comment on va le coder

SEA :
* DEG

GSEA/SEA : dans ClusterProfiler

Domaines SEA
* sous listes DEG
* biomart pour récupérer les domaines
* tableau domaines par db
* test SEA
	* récupére background (tous les domaines dans espèces)

