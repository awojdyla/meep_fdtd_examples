(define-param tkns 0.5)

(define-param rac (/ 1.0 (sqrt 2.0) ))

(set! geometry-lattice (make lattice (size 16 16 no-size)))
(set! geometry (list
	(make block (center 0 0) (size 8 8 infinity)
		(e1 1 0 0)(e2 0 1 0)(e3 0 0 1)
		(material (make dielectric (epsilon 2.1)))
	)
	(make block (center 0 0) (size infinity tkns infinity)
		(e1 rac rac 0)(e2 (- rac) rac 0)(e3 0 0 1)
		(material (make dielectric (epsilon 1)))
	)
))

(define (gaussy p)
	(exp (- (sqr (/ (vector3-y p) 2 ))))
)
(define (gaussx p)
	(exp (- (sqr (/ (vector3-x p) 2 ))))
)

(set! sources (list
	(make source
		(src (make gaussian-src (frequency 1)(fwidth 1)))
		(component Ey)
                (center -7 0)
		(size 0 16 0)
		(amp-func gaussy)
	)
	(make source
		(src (make gaussian-src (frequency 1)(fwidth 1)))
		(component Ex)
                (center 0 -7)
		(size 16 0 0)
		(amp-func gaussx)
	)
))

(set! pml-layers (list (make pml (thickness 1.0))))

(set! resolution 32)

(run-until 24
	(at-beginning output-epsilon)
	(at-every 1 (output-png Hz "-Zc dkbluered -A $EPS -a gray:0.3"))
)
