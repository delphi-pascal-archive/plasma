Plasma------
Url     : http://codes-sources.commentcamarche.net/source/11680-plasmaAuteur  : Marneus CalgarDate    : 03/08/2013
Licence :
=========

Ce document intitulé « Plasma » issu de CommentCaMarche
(codes-sources.commentcamarche.net) est mis à disposition sous les termes de
la licence Creative Commons. Vous pouvez copier, modifier des copies de cette
source, dans les conditions fixées par la licence, tant que cette note
apparaît clairement.

Description :
=============

Ce programme est une animation de type Plasma, effet tr&egrave;s connu dans les 
d&eacute;mos du temps du DOS. Voici une version Windows optimis&eacute;e &agrave
; 100%, en plein &eacute;cran, avec affichage des statistiques... J'ai limit&eac
ute; le FrameRate &agrave; 50 FPS car au-del&agrave; l'animation est difficileme
nt supportable, et provoque des maux de t&ecirc;te.
<br /><a name='conclusion'>
</a><h2> Conclusion : </h2>
<br />Vous pouvez appuyez sur la touche : 
<br />

<br />Echap pour quitter 
<br />S pour afficher/masquer les statistiques 
<b
r />
<br />Le code est bas&eacute; sur un exemple trouv&eacute; dans les SWAG, 
une librairie de code pour Turbo Pascal tr&egrave;s interressante, bien que la d
erni&egrave;re mise &agrave; jour date de 1997. J'ai pas mal optimis&eacute; le 
code, de sorte &agrave; ce que l'animation soit fluide m&ecirc;me en 1280x1024..
. Il devrait &ecirc;tre compilable sous Delphi 3, 4, 5 et 6.
<br />
<br />List
e des optimisations : 
<br />
<br />Remplacement des bytes par des integer 
<
br />Utilisation d'un Bitmap Tile 256x2x6x8 pour le calcul 
<br />Utilisation d
'un Bitmap Tile 256x256 &agrave; la profondeur d'&eacute;cran pour l'affichage 

<br />Utilisation du ScanLine 
<br />Utilisation de Threads 
<br />Remplaceme
nt des mod par des and 
<br />Remplacement des * et / par des shr et shl
