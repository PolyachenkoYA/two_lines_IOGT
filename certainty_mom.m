clear; close all;

%% ================== params ==============
x0 = 0;
y0 = 2;
k1 = 0.25;
k2 = 0.4;
x1 = 0.4;
x2 = 30;
y1 = 0.4;
y2 = 40;

%% =================== input ============
p0 = 0.8;
a1 = 0.17;
scl = 0.34;

%% =============== program ===============
a0 = fsolve(@(a)(accur(a, x0, y0, k1, k2, x1, x2, y1, y2) - p0), 0.2);
p1 = accur(a1, x0, y0, k1, k2, x1, x2, y1, y2);

a_draw = 0.01:0.001:0.5;
N = length(a_draw);
acc = zeros(N, 1);
for i = 1:N
    acc(i) = accur(a_draw(i), x0, y0, k1, k2, x1, x2, y1, y2);
    disp(['done ' num2str(i/N * 100) ' %']);
end

getFig(['$\sigma_{rel} / \Delta$; $\Delta = ' num2str(scl) '$'], '$p$', '$p(\sigma)$');
plot(a_draw / scl, acc, 'DisplayName', 'data');

plot([0, a0] / scl, [1, 1] * p0, '--', 'DisplayName', ['$p_0 = $' num2str(p0)], 'Color', getMyColor(3));
plot([1, 1] * a0 / scl, [0, p0], '--', 'DisplayName', ['$\sigma(p_0) = $' num2str(a0)], 'Color', getMyColor(3));

plot([1, 1] * a1 / scl, [0, p1], '--', 'DisplayName', ['$\sigma_1 = $' num2str(a1)], 'Color', getMyColor(2));
plot([0, a1] / scl, [1, 1] * p1, '--', 'DisplayName', ['$p(\sigma_1) = $' num2str(p1)], 'Color', getMyColor(2));


function ret = g(y, m, s2)
    ret = exp(-(y - m).^2 / 2 ./ s2);
end
function ret = r(a, x, y, x0, y0, k)
    m = y0 + k * (x - x0);
    ret = g(y, m, (a .* m).^2);
end
function ret = z_int(x, a, x0, y0, k, y1, y2)
    y = y0 + k .* (x - x0);
    ret = a * sqrt(pi / 2) .* y .* (erf((y - y1) ./ (a .* y * sqrt(2))) - erf((y - y2) ./ (a .* y * sqrt(2))));
end
function ret = z(a, x0, y0, k, x1, x2, y1, y2)
     ret = integral(@(x)z_int(x, a, x0, y0, k, y1, y2), x1, x2);
end
function ret = accur(a, x0, y0, k1, k2, x1, x2, y1, y2)
    min_k = min(k1, k2);
    max_k = max(k1, k2);
    i1 = integral2(@(x,y)(r(a, x, y, x0, y0, min_k)), ...
                   x1, x2, @(x)(y0 + (k1 + k2) / 2 .* (x - x0)), y2) / ... 
                   z(a, x0, y0, min_k, x1, x2, y1, y2);
    i2 = integral2(@(x,y)(r(a, x, y, x0, y0, max_k)), ...
                   x1, x2, y1, @(x)(y0 + (k1 + k2) / 2 .* (x - x0))) / ...
                   z(a, x0, y0, max_k, x1, x2, y1, y2);
    ret = 1 - i1 - i2;
end
        
        