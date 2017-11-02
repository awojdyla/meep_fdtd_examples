(define-param tkns 1.0)
(define-param theta 18)
(define-param f0 1)

(define-param x1 (/ 1 (sin (* theta 0.01745))))

(set! geometry-lattice (make lattice (size 16 16 no-size)))
(set! geometry (list
	(make block (center 0 8) (size 24 24 infinity)
		(e1 1 x1 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 12)))
	)
	(make block (center 2.5 -4) (size 4 9 infinity)
		(e1 1 0 0)(e2 1 x1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 12)))
	)
	(make block (center 7 -4) (size 8 9 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 1)))
	)
))

(define (gauss p)
	(exp (- (sqr (/ (vector3-y p) 1.5 ))))
)

(set! sources (list
	(make source
		(src (make gaussian-src (frequency f0) (fwidth (/ f0 2))))
		(component Ey)
                (center -7 3)
		(size 0 16 4)
		(amp-func gauss)
		(src (make gaussian-src (frequency f0) (fwidth (/ f0 2))))
	)
	(make source
		(src (make gaussian-src (frequency f0) (fwidth (/ f0 2))))
		(component Ey)
                (center -7 -5)
		(size 0 16 4)
		(amp-func gauss)
		(src (make gaussian-src (frequency f0) (fwidth f0 )))
	)
))

(set! pml-layers (list (make pml (thickness 1.0))))

(set! resolution 32)

(run-until 48
	(at-beginning output-epsilon)
	(at-every 0.1 (output-png Hz "-Zc dkbluered -A $EPS -a gray:0.3"))
)
