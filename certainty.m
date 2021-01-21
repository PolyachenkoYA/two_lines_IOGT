clear; close all;

x0 = 0.1;
y0 = 2;
x1 = x0;
x2 = 30;
y1 = 1;
y2 = 40;
k1 = 0.25;
k2 = 0.4;
dk1 = 0.0025;
dk2 = 0.004;
dx0 = 0.001;
dy0 = 0.001;
s1 = 0.1;
s2 = 0.1;

%p(0.1, x1, x2, y1, y2, s1, s2, x0, y0, k1, k2, dx0, dy0, dk1, dk2)

function ret = g(y, y0, s2)
    if(any(size(y)~=size(y0)) || any(size(y)~=size(s2)))
        disp('sizes');
    end
    ret = exp(-(y - y0) .^ 2 / 2 ./ s2) ./ sqrt(2 * pi * s2);
end

function ret = r(x, y, x0, y0, k, dx0, dy0, dk)
    ret = g(y, y0 + k .* (x - x0), k.^2 .* x.^2 + dy0.^2 + k.^2 .* dx0.^2 + x0.^2 .* dk.^2);
end
function ret = r1(x, y, x0, y0, k1, dx0, dy0, dk1)
    ret = r(x, y, x0, y0, k1, dx0, dy0, dk1);
end
function ret = r2(x, y, x0, y0, k2, dx0, dy0, dk2)
    ret = r(x, y, x0, y0, k2, dx0, dy0, dk2);
end
function ret = re(a, y_e, y)
    ret = g(y, y_e, (a .* y).^2);
end

function ret = h(x, y, s1, s2, x0, y0, k1, k2)
    ret = g(y, y0 + k1 .* (x - x0), (s1 .* y).^2) + g(y, y0 + k2 .* (x - x0), (s2 .* y).^2);
end

function ret = z(x1, x2, y1, y2, s1, s2, x0, y0, k1, k2)
    ret = integral2(@(x,y)h(x, y, s1, s2, x0, y0, k1, k2), x1, x2, y1, y2);
end

function ret = a1(a, x, y, x0, y0, k1, dx0, dy0, dk1, y1, y2)
    ret = integral(@(yy)(r1(x, yy, x0, y0, k1, dx0, dy0, dk1) * re(a, y, yy)), y1, y2);
end
function ret = a2(a, x, y, x0, y0, k2, dx0, dy0, dk2, y1, y2)
    ret = integral(@(yy)(r2(x, yy, x0, y0, k2, dx0, dy0, dk2) * re(a, y, yy)), y1, y2);
end

function ret = w(a, x, y, y1, y2, x0, y0, k1, k2, dx0, dy0, dk1, dk2)
    b1 = a1(a, x, y, x0, y0, k1, dx0, dy0, dk1, y1, y2);
    b2 = a2(a, x, y, x0, y0, k2, dx0, dy0, dk2, y1, y2);
    ret = abs(b1 - b2) ./ (b1 + b2);
end

function ret = p(a, x1, x2, y1, y2, s1, s2, x0, y0, k1, k2, dx0, dy0, dk1, dk2)
    ret = integral2(@(x,y)(h(x, y, s1, s2, x0, y0, k1, k2) .* ...
                           w(a, x, y, y1, y2, x0, y0, k1, k2, dx0, dy0, dk1, dk2)),...
                    x1, x2, y1, y2) / z(x1, x2, y1, y2, s1, s2, x0, y0, k1, k2);
end
     
     