(define-param f0 2.0)
(define-param df 2.0)
(define-param fc 3)
(define-param waist 1.33)

(set! geometry-lattice (make lattice (size 32 24 no-size)))
(set! geometry (list
	(make block (center 0 -8) (size 8 8 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 2.25)
			(E-polarizations (make polarizability
 				 	 (omega fc) (gamma 0) (sigma 2)))
	)))
	(make block (center 0 0) (size 8 8 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 2.25)))
	)
	(make block (center 0 8) (size 8 8 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 2.25)
			(E-polarizations (make polarizability
 				 	 (omega (- (* f0 2) fc)) (gamma 0) (sigma 2)))
	)))
))

(define (gauss p)
	(exp (- (sqr (/ (vector3-y p) waist ))))
)

(set! sources (list
	(make source
		(src (make gaussian-src (frequency f0) (fwidth df) (start-time 0)))
		(component Ez)
                (center -15 -8)
		(size 0 16 0)
		(amp-func gauss)
	)
	(make source
		(src (make gaussian-src (frequency f0) (fwidth df) (start-time 0)))
		(component Ez)
                (center -15 0)
		(size 0 16 0)
		(amp-func gauss)
	)
	(make source
		(src (make gaussian-src (frequency f0) (fwidth df) (start-time 0)))
		(component Ez)
                (center -15 8)
		(size 0 16 0)
		(amp-func gauss)
	)
))

(set! pml-layers (list (make pml (thickness 1.0))))

(set! resolution 32)

(run-until 48
	(at-beginning output-epsilon)
	(to-appended "Ez" (at-every 1 output-efield-z))
)
