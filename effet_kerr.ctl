(define-param waist 2.0)
(define-param khi3 2.0)


(set! geometry-lattice (make lattice (size 24 8 no-size)))

(set! geometry (list
	(make block (center -2 0) (size 12 7 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 3) (chi3 khi3)))
	)
))

(define (gauss p)
	(exp (- (sqr (/ (vector3-y p) waist ))))
)

(set! sources (list
	(make source
		(src (make gaussian-src (frequency 1) (fwidth 1) (start-time 0)))
		(component Ez)
                (center -11 0)
		(size 0 8 0)
		(amp-func gauss)
	)
))

(set! pml-layers (list (make pml (thickness 1.0))))

(set! resolution 64)

(run-until 36  
	(at-beginning output-epsilon)
	(at-every 1 (output-png Ez "-Zc dkbluered -A $EPS -a gray:0.3"))
)
