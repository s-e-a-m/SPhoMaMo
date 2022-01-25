// Midside
import("stdfaust.lib");

p = hslider("Mid Polar Pattern", 0.5, 0, 1, .001) : si.smoo;
d = hslider("Source Angle", 0, -180, 180, .1) : si.smoo;

d2r(a) = a*ma.PI/180;

mid_side(p, r) = _ <: mid(p, r), side(r)
with {
    mid(p, r) = _ <: (p*omni + (1-p)*fig_8(r))
    with {
        fig_8(r) = _*cos(r);
        omni = _;
    };

    side(r) = _*sin(r);
};

sdmx = _, _ <: +/2, -/2; // matrice somma e sottrazione normalizzata; MS -> LR (M+S=L, M-S=R) o anche LR -> MS (L+R=M, L-R=S)

sweep(m,t) = m : %(int(*(t):max(1)))~+(1'); // funzione di sweep "corretta" (parte da 0)

sw_mm(min_, max_, f) = sweep(ma.SR/f, 1)*(f/ma.SR)*(max_-min_) + min_; // funzione di sweep da min_ a max_ con frequenza f

process = os.osc(1000) <: mid_side(p, d2r(-d)); // : sdmx; // -d perchè convenzionalmente gli angoli sono + a sx e - a dx, al contrario di quanto esce da d.
//process = os.osc(1000) <: mid_side(p, d2r(sw(-180, 180, 1))); // : sdmx; // sweep sull'angolo di provenienza del segnale