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

* choix espèce : menu déroulant (BioMart)

## État des lieux

### Input

* header : inutile
* Sources : 
	* inutile
	* besoin de transparence pour user
* ajout menu déroulant espèce

## Onglets

* développer les noms
* ajout onglet domaines

### WDI

* algo HS
* curseur p-val/FC
* méthode ajustement du seuil (ne pas seuiller sur p-val)
* figure interactive (pas prioritaire)
* tableau ajusté (pas prioritaire)

### GOE

* liste bdd interrogée par le package (pertinence ?)
* GO term lelvel -> G term Ontology
* EA :
	* suppr MEA
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



