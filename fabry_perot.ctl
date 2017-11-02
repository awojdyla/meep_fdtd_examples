(set! geometry-lattice (make lattice (size 8 16 no-size)))

(set! geometry (list
	(make block (center 0 0) (size 1 infinity infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 25)))
	)
))

(define (gauss p)
	(exp (- (sqr (/ (vector3-y p) 3 ))))
)

(set! sources (list
	(make source
		(src (make gaussian-src (frequency 1) (fwidth 0.01) (start-time 0)))
		(component Ez)
                (center -3 4)
		(size 0 16 0)
		(amp-func gauss)
	)
	(make source
		(src (make gaussian-src (frequency 1.05) (fwidth 0.01) (start-time 0)))
		(component Ez)
                (center -3 -4)
		(size 0 16 0)
		(amp-func gauss)
	)
))

(set! pml-layers (list (make pml (thickness 1.0))))

(set! resolution 64)

(run-until 64
	(at-beginning output-epsilon)
	(to-appended "TE" (at-every 1 output-efield-z))
	(to-appended "TM" (at-every 1 output-hfield-z))
)
