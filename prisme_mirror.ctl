;angle du prisme
(define-param theta 48)
;frequence relative de l'onde
(define-param lambda0 1)

;caluls divers...
(define-param w0 (/ 3.14159 lambda0))
(define-param th_1 (* theta 0.01745))
(define-param th_2 (- 1.5708 (* th_1 2)))

;definition de la boite de calcul
(set! geometry-lattice (make lattice (size 16 16 no-size)))

;definition des composants optiques
(set! geometry (list
	;premier bloc: parallélépipède de Si
	(make block (center 2 2) (size 10 10 infinity)
		(e1 (cos th_2)  (sin th_2) 0) (e2 0 -1 0) (e3 0 0 1)
		(material (make dielectric (epsilon 11.63)))
	)
	;deuxième bloc on retire de la matiere au prisme
	(make block (center 2 7) (size 14.87 10 infinity)
		(e1 (cos th_1)  (- (sin th_1)) 0) (e2 0 -1 0) (e3 0 0 1)
		(material (make dielectric (epsilon 1)))
	)
))

;definition du pulse customisé wesh wesh
(define (pulse t)
	(* (exp (- (sqr (* (- t 2) (/ w0 2))))) (cos (* t w0)))
)

;definition d'un faisceau gaussien
(define (gauss p)
	(exp (- (sqr (/ (vector3-y p) 3 ))))
)

;declaration des sources
(set! sources (list
	(make source
		(src (make custom-src (src-func pulse)))		
		(component Ez)
                (center -7 2)
		(size 0 16 0)
		(amp-func gauss)
	)
	(make source
		(src (make custom-src (src-func pulse)))
		(component Ey)
                (center -7 2)
		(size 0 16 0)
		(amp-func gauss)
	)
))

;PML de bord de boite
(set! pml-layers (list (make pml (thickness 1.0))))

;definition de la resolution
(set! resolution 30)

;lancement du calcul
(run-until 48
	(at-beginning output-epsilon)
;	(at-every 1 (output-png Ez "-Zc dkbluered -A $EPS -a gray:0.3"))
;	(at-every 1 (output-png Hz "-Zc dkbluered -A $EPS -a gray:0.3"))
	(to-appended "TE" (at-every 1 output-efield-z))
	(to-appended "TM" (at-every 1 output-hfield-z))
)
