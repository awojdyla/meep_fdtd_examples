(define-param f0 1.0)
(define-param df 1.0)
(define-param waist 2.5)

(define-param fc 1.5)
(define-param indice 1.5)
(define-param sig 2)
(define-param gam 0)

(define-param epsi (sqr indice))

(set! geometry-lattice (make lattice (size 20 24 no-size)))
(set! geometry (list
	(make block (center -2 8) (size 8 8 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 5.5)
			(E-polarizations (make polarizability
 				 	 (omega 1.5) (gamma gam) (sigma 0.5)))
	)))
	(make block (center -2 0) (size 8 8 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 7)))
	)
	(make block (center -2 -8) (size 8 8 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 5.5)
			(E-polarizations (make polarizability
 				 	 (omega 0.5) (gamma gam) (sigma 2)))
	)))
))

(define (gauss p)
	(exp (- (sqr (/ (vector3-y p) waist ))))
)

(set! sources (list
	(make source
		(src (make gaussian-src (frequency f0) (fwidth df) (start-time 0)))
		(component Ez)
                (center -9 -8)
		(size 0 16 0)
		(amp-func gauss)
	)
	(make source
		(src (make gaussian-src (frequency f0) (fwidth df) (start-time 0)))
		(component Ez)
                (center -9 0)
		(size 0 16 0)
		(amp-func gauss)
	)
	(make source
		(src (make gaussian-src (frequency f0) (fwidth df) (start-time 0)))
		(component Ez)
                (center -9 8)
		(size 0 16 0)
		(amp-func gauss)
	)
))

(set! pml-layers (list (make pml (thickness 1.0))))

(set! resolution 16)

(run-until 48
	(at-beginning output-epsilon)
	(at-every 1 (output-png Ez "-Zc dkbluered -A $EPS -a gray:0.3"))
)
