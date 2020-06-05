# MEEP FDTD examples

Here is a set of SCHEME scripts to perform Finite-Difference Time Domain (FDTD) calculations using [MEEP](http://ab-initio.mit.edu/wiki/index.php?title=Meep). Please use them as examples for your own simulations, or to show some specific optical effects to your students.

There's a few coding tricks use to generate sub-single cycle pulses, which are quite interesting to show carrier-enveloppe phase, and also to generate an extended gaussian source (plane waves tend to leak at the edges and do not make good pictorial examples.)

## Usage
To run these scripts, download them (`git clone https://github.com/awojdyla/meep_fdtd_examples` in you terminal), and run them in the terminal after having installed [MEEP](https://meep.readthedocs.io/en/latest/Installation/#installation-on-linux) (Linux, or if you're courageous Mac. The [Windows 10 Linux subsystem](https://docs.microsoft.com/en-us/windows/wsl/install-win10) should work too.)

Type for example:

```meep prisme.ctl```

At the end of the simulation, the data should be sotred in big hdf5 file. You can change the time step and the simulation duration by modifying the last lines of the scripts:

```
(run-until 128
	(at-beginning output-epsilon)
	(to-appended "TE" (at-every 1 output-efield-z))
	(to-appended "TM" (at-every 1 output-hfield-z))
)
```
You can export the data from the hdf5 file to png using `h5topng` (install it beforehand and read the manual.) Alternatively, you canthe following instructions to your script:

```
(run-until 36 
	(at-beginning output-epsilon)
	(at-every 0.2(output-png Ez "-Zc dkbluered -A $EPS -a gray:0.3"))
)
```

These scripts were written for the original meep environment, but it's 2020 and you should probably use a python environment to run these simulations in a much more friendly manner. The code is fairly transparent and porting it should be no problem (I'll probably do it one day, or if you want to help me...)


## Example
This repo is at its heart a collection of simulations trying to depict common optical phenomenon, in order to get a sense of what's going on. Here's a few examples
### Total internal reflection
The first example is the case of total internal reflection, which occurs when there is an interfence wher a reflection occur at an angle higher than the so-called critical angle. The simulation `prisme.ctl` shows the case of silicon (index 3.4) reflecting at a 48 degree angle. This angle has the special property that the TE-polarized wave and the TM polarized wave undergo a 90 deg differential phase shift, hence generating a broadband ciruclarly polarized wave.

[![](http://img.youtube.com/vi/yVPtOp06pDk/0.jpg)](http://www.youtube.com/watch?v=yVPtOp06pDk "Total Internal reflection")

In that simulation, only the TE component is shown, but since it is a very short puls, it is possible how the phase of the wave changes after reflection (the structure of the pulse goes from the derivative of a gaussian to a mexican hat.)

### Gouy Phase shift
In `lentille.ctl`, I try to show how the phase of the wave shifts by pi/2 after going through a focus event. This effect is known as the [Gouy phase shift](https://en.wikipedia.org/wiki/Gaussian_beam#Gouy_phase):

[![](http://img.youtube.com/vi/RT1r4xvenCY/0.jpg)](http://www.youtube.com/watch?v=RT1r4xvenCY "Gouy phase shift")

This effect is distinct from the precedent in that it is not polarization-dependant.

### Diffraction limit
Similar to the previous simulatio, with a larger wavepacket this time, we try to show that the diffraction limit, which limits how tight a beam can be focused, is caused by the wave properties of light.

[![](http://img.youtube.com/vi/uTd_HeIvJ_w/0.jpg)](http://www.youtube.com/watch?v=uTd_HeIvJ_w "Diffraction limit")

You can run this simulation with half the wavelength and witness how the minimal size shrinks by a factor two. You can also increase the radius of curvature, eventually chaning the numerical aperture of the system, and witness a similar effect.

### Frustrated total reflection
Frustrated total internal reflection occurs when a surface is within a wavelength of another and somehow partially cancels the total internal reflection. This effect is also known as optical tunelling and bears simularity with quantum tunelling (where the finite potential barrier is the finite refractive index of the material.)

`effet_tunnel.ctl`

[![](http://img.youtube.com/vi/fOqF6t6A4O4/0.jpg)](http://www.youtube.com/watch?v=fOqF6t6A4O4 "Frustrated total Internal reflection")

It's also interesting to notice that the tunnelled beam exits the second 45 deg prisms with an additional angle (it is not parallel to the interface.) The beam being tunneled also happen to have no phase shift, but somehow a smaller bandwidth, with larger wavelength dominating (high frequency get less "tunnelled.")

### Faster than light experiments
`TFL.ctl` is a case of frustrated total internal reflection where light would in principle appears to move faster than light, because optical tunelling has an undetermined self-time. But it turns out to be just an effect of phase velocity if you think about it. 
There's also whole discussion to be had about the [Goos-Hanchen effect](https://en.wikipedia.org/wiki/Goos%E2%80%93H%C3%A4nchen_effect).

## Credits
Some of these results were used in my [PhD thesis manuscript](https://pastel.archives-ouvertes.fr/pastel-00652969) (I had a lot of fun making those!) Sadly it's not in English because the French law mandates that thesis need to be written in French, and back then I didn't feel compelled to translate it. But there are still some fun results, and some graphs should be pretty self-explaining!
