(define-param tkns 1.0)
(define-param theta 18)
(define-param f0 0.288)

(define-param x1 (cos (* (- 90 theta) 0.01745)))

(set! geometry-lattice (make lattice (size 16 16 no-size)))
(set! geometry (list
	(make block (center 0 0) (size 8 16 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 12)))
	)
	(make block (center 0 0) (size infinity tkns infinity)
		(e1 x1 1 0)(e2 1 (- x1) 0)(e3 0 0 1)
		(material (make dielectric (epsilon 1)))
	)
))

(define (pulse t)
	(* (exp (- (sqr (/ (- t 6) 2)))) (cos (* t (* f0 6.283))))
)

(define (gauss p)
	(exp (- (sqr (/ (vector3-y p) 3 ))))
)

(set! sources (list
	(make source
		(src (make custom-src 
			(src-func pulse)))
		(component Ey)
                (center -7 0)
		(size 0 16 4)
		(amp-func gauss)
	)
))

(set! pml-layers (list (make pml (thickness 1.0))))

(set! resolution 32)

(run-until 48
	(at-beginning output-epsilon)
	(at-every 1 (output-png Hz "-Zc dkbluered -A $EPS -a gray:0.3"))
)
