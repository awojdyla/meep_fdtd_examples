(set! geometry-lattice (make lattice (size 16 8 no-size)))

(set! geometry (list
	(make block (center 0 0) (size 10 8 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon-diag 2.25 2.6125 2.6125)  (epsilon-offdiag 0 0 -0.3625)))
		;(material (make dielectric (epsilon-diag 2.25 2.5 2.7 )  (epsilon-offdiag 0 0 0.5)))
	)
))
(define (gauss p)
	(exp (- (sqr (/ (vector3-y p) 3 ))))
)

(set! sources (list
	(make source
		(src (make gaussian-src (frequency 1) (fwidth 1)))
		(component Ez)
                (center -7 0)
		(size 0 8 0)
		(amp-func gauss)
	)
))

(set! pml-layers (list (make pml (thickness 1.0))))

(set! resolution 32)

(run-until 32
	(at-beginning output-epsilon)
	(at-every 1 (output-png Ez "-Zc dkbluered -A $EPS -a gray:0.3"))
)
