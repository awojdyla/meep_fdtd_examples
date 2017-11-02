(define-param tkns 2.0)
(define-param theta 18)
(define-param w0 5.0)

(define-param x1 (cos (* (- 90 theta) 0.01745)))

(set! geometry-lattice (make lattice (size 32 32 no-size)))
(set! geometry (list
	(make block (center 0 0) (size 16 32 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 12)))
	)
	(make block (center 0 8) (size 16 tkns infinity)
		(e1 x1 1 0)(e2 1 0 0)(e3 0 0 1)
		(material (make dielectric (epsilon 1)))
	)
	(make block (center -2.4 -8) (size tkns 16.5 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 1)))
	)
))

(define (pulse t)
	(* (exp (- (sqr (/ (- t 6) 2)))) (cos (* t w0)))
)

(define (gauss p)
	(exp (- (sqr (/ (vector3-y p) 3 ))))
)

(set! sources (list
	(make source
		(src (make custom-src 
			(src-func pulse)))
		(component Ey)
                (center -15 8)
		(size 0 16 4)
		(amp-func gauss)
	)
	(make source
		(src (make custom-src 
			(src-func pulse)))
		(component Ey)
                (center -15 -8)
		(size 0 16 4)
		(amp-func gauss)
	)
))

(set! pml-layers (list (make pml (thickness 1.0))))

(set! resolution 48)

(run-until 80
	(at-beginning output-epsilon)
	(at-every 1 (output-png Hz "-Zc dkbluered -A $EPS -a gray:0.3"))
)

