(define-param theta 73.7)
(define-param tkns 1)

(define-param x1 (* tkns (cos (* theta 0.01745))))
(define-param x2 (* (- tkns) (sin (* theta 0.01745))))

(set! geometry-lattice (make lattice (size 96 32 no-size)))
(set! geometry (list
	(make block (center 0 2) (size tkns infinity infinity)
		(e1 x1 x2 0)(e2 (- x2) x1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 11.7)))
	)
	(make block (center 0 0) (size tkns infinity infinity)
		(e1 x1 x2 0)(e2 (- x2) x1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 11.7)))
	)
	(make block (center 0 -2) (size tkns infinity infinity)
		(e1 x1 x2 0)(e2 (- x2) x1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 11.7)))
	)
	(make block (center 0 -4) (size tkns infinity infinity)
		(e1 x1 x2 0)(e2 (- x2) x1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 11.7)))
	)
))

(define (pulse t)
	(* (exp (- (sqr (/ (- t 5) 0.5)))) (cos t))
)

(define (gauss p)
	(exp (- (sqr (/ (vector3-y p) 5 ))))
)

(set! sources (list
	(make source
		(src (make custom-src 
			(src-func pulse)))
		(component Ez)
                (center -47 0)
		(size 0 16 0)
		(amp-func gauss)
	)
	(make source
		(src (make custom-src 
			(src-func pulse)))
		(component Ey)
                (center -47 0)
		(size 0 16 4)
		(amp-func gauss)
	)
))

(set! pml-layers (list (make pml (thickness 1.0))))

(set! resolution 32)

(run-until 128
	(at-beginning output-epsilon)
	(to-appended "TE" (at-every 1 output-efield-z))
	(to-appended "TM" (at-every 1 output-hfield-z))
)

