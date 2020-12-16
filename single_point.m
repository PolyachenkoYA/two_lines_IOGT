clear;
close all;

y1 = 2;
y2 = 5;
d_y1 = 0.3;
d_y2 = 0.1;
y = 3;
d_y = 1;

Ny = 1000;

p1 = normpdf(y - y1, 0, sqrt(d_y^2 + d_y1^2));
p2 = normpdf(y - y2, 0, sqrt(d_y^2 + d_y2^2));
z = p1 + p2;
p1 = p1 / z;
p2 = p2 / z;

y_arr = linspace(y1 - d_y1 * 3, y2 + d_y2 * 3, Ny);
p1_arr = normpdf(y_arr, y1, d_y1);
p2_arr = normpdf(y_arr, y2, d_y2);
p_arr = normpdf(y_arr, y, d_y);

getFig('y', 'p');
plot(y_arr, p1_arr, 'DisplayName', '$y_1$');
plot(y_arr, p2_arr, 'DisplayName', '$y_2$');
plot(y_arr, p_arr, 'DisplayName', '$y_{data}$');

getFig('y', 'overlap');
plot(y_arr, p1_arr .* p_arr, 'DisplayName', ['$p_1 = ' num2str(p1) '$']);
plot(y_arr, p2_arr .* p_arr, 'DisplayName', ['$p_2 = ' num2str(p2) '$']);

