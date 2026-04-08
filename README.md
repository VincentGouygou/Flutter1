une app a la facebook en mini :
 	- subscrb/login/deco
 	- crud friends[] 
 	- post photos to share
 	- crud account
 	- 

une app avec 
	- une liste de langues ayant chacune sont vocabulaire
	- une bandeau de pub au milieu qui disparait au clic ( BannerAd... )
	- une invite ( modal ?) rgpdCookies + 
	- un test cookies pour savoir si l'user est déjà connecté. 
		. dans ce cas,
			. cookies (map?) >> _userInfos[] (  vérification DB ? )
			. dicoLang>> si fr ou en ( !!! toutes les variables textes doivent etre state() selon _userLang !! >> function )
			. 
			
		. sinon 
		   . les initialisations des variables avec du neutre (dicoLang) 
		   . et invite de connexion.
		   
	- adaptation theme de couleurs, check  si _userInfo.isDarkMode ( dans Namata.. IA )
	- 
	
	
	-une appbar en haut avec : 
		. au milieu le nom du user si connected sinon un bouton 'login' addlistonclic () 
		( ? affichage soit en icon si manque de place, soit sizemax pour les noms des users) 		 
		  
		. l'heure en format adapté a l'orientation et a la taille de l'écran a gauche ( fontsize-- ,rm sec ... )
	
	- un body en single page qui charge les pages :
		. accueil  (isCo> si isConnected ... : ... )
   isCo> . photos (galerie et click pour toggle agrandir/restaurer)
   isCo> . amis ( bttmbar icone pour basculer listeNoms/galerie )
	   . nous contacter
	   . rgpd politics		   
	
	-un bottombar avec : 
		. des raccourcis pages  
		. un burger centrale pour développer un menu empilé verticalememt ( login/account, photos, friends... )
		. une roue parametres de l'app ( compte (crud) , effets visuels +/-, darkmode on/off,  )
		
