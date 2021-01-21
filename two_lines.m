clear;
close all;

d_y_rel = 0.2;
max_cert = 10;
x0 = 0;
y0 = 2;
x1 = 30;
k1 = 0.25;
k2 = 0.4;
d_k1 = 0.0025;
d_k2 = 0.004;
d_b1 = 0.1;
d_b2 = 0.1;
Nx = 250;
Ny = 250;

x_draw = linspace(x0, x1, Nx);
b1 = y0 - k1 * x0;
b2 = y0 - k2 * x0;
linfit1 = [k1, b1];
d_linfit1 = [d_k1, d_b1];
linfit2 = [k2, b2];
d_linfit2 = [d_k2, d_b2];
[y1, confidence1] = lin_anal(linfit1, d_linfit1, x_draw);
[y2, confidence2] = lin_anal(linfit2, d_linfit2, x_draw);
ymin = min([y1(:) - confidence1(:); y2(:) - confidence2(:)]);
ymax = max([y1(:) + confidence1(:); y2(:) + confidence2(:)]);
y_draw = linspace(ymin, ymax, Ny);

[x_grid, y_grid] = meshgrid(x_draw, y_draw);
y1_grid = polyval(linfit1, x_grid);
y2_grid = polyval(linfit2, x_grid);
[~, d_y1_grid] = meshgrid(x_draw, confidence1);
[~, d_y2_grid] = meshgrid(x_draw, confidence2);
% absolute errors
%[p1, p2] = get_prob(y_grid, ones(size(y_grid)) * d_y, y1_grid, d_y1_grid, y2_grid, d_y2_grid);
% relative errors
[p1, p2] = get_prob(y_grid, y_grid * d_y_rel, y1_grid, d_y1_grid, y2_grid, d_y2_grid);


fig = getFig('$x$', '$y$');
draw_line(fig.ax, y1, confidence1, x_draw, getMyColor(1), '$th_1$');
draw_line(fig.ax, y2, confidence2, x_draw, getMyColor(2), '$th_2$');

fig_p = getFig('$x$', '$y$', '', '', '', '', '$p$');
p1_surf = surf(fig_p.ax, x_grid, y_grid, p1, 'DisplayName', '$p_1$', ...
    'EdgeColor', 'interp', 'FaceColor', 'interp', 'FaceAlpha', 0.5);
p2_surf = surf(fig_p.ax, x_grid, y_grid, p2, 'DisplayName', '$p_2$', ...
    'EdgeColor', 'interp', 'FaceColor', 'interp', 'FaceAlpha', 0.5);

fig_cert = getFig('$x$', '$y$', ['certainty = $|\log(p_1/p_2)|; dy = ' num2str(d_y_rel) '$'], '', '', 'log', '$c$');
surf(fig_cert.ax, x_grid, y_grid, exp(min(abs(log(p1./p2)), log(max_cert))), ...
    'EdgeColor', 'interp', 'FaceColor', 'interp');

% fig_p1 = getFig('x', 'y', '$p_1(x,y)$', '', '', '', '$p_1$');
% surf(x_grid, y_grid, p1, 'EdgeColor', 'interp', 'FaceColor', 'interp');
% 
% fig_p2 = getFig('x', 'y', '$p_2(x,y)$', '', '', '', '$p_2$');
% surf(x_grid, y_grid, p2, 'EdgeColor', 'interp', 'FaceColor', 'interp');

function [p1, p2] = get_prob(y, d_y, y1, d_y1, y2, d_y2)
    p1 = normpdf(y - y1, 0, sqrt(d_y.^2 + d_y1.^2));
    p2 = normpdf(y - y2, 0, sqrt(d_y.^2 + d_y2.^2));
    p1 = p1 ./ (p1 + p2);
    p2 = 1 - p1;
end

function [y, confidence] = lin_anal(linfit, d_linfit, x_draw)
    confidence = sqrt(d_linfit(2)^2 + (x_draw * d_linfit(1)).^2);
    y = polyval(linfit, x_draw);
end

function draw_line(ax, y, confidence, x_draw, clr, tit)
    plot(ax, x_draw, y, 'DisplayName', tit, 'Color', clr);
    plot(ax, x_draw, y + confidence, '--', 'HandleVisibility', 'off', 'Color', clr);
    plot(ax, x_draw, y - confidence, '--', 'HandleVisibility', 'off', 'Color', clr);
end