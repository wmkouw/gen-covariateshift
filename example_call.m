close all;
clearvars;

%%% 1-dimensional

% Define target marginal data distribution pT(x)
pT_X = @(x) normpdf(x, 0, .5);

% Call sampler
[Xn, Xp, Zn, Zp] = sample_covshift1D(pT_X, 'ub', sqrt(det(2*pi*2)));

% Visualize output
figure(1);

bins = linspace(-5, 5, 31);

subplot(1,2,1)
hold on
histogram(Xn, bins, 'EdgeColor', 'r', 'Normalization', 'Probability');
histogram(Xp, bins, 'EdgeColor', 'b', 'Normalization', 'Probability');
xlabel('x')
ylabel('p_S(x|y)')
title('Source domain')

subplot(1,2,2)
hold on
histogram(Zn, bins, 'EdgeColor', 'r');
histogram(Zp, bins, 'EdgeColor', 'b');
xlabel('x')
ylabel('p_T(x|y)')
title('Target domain')

set(gcf, 'Color', 'w', 'Position', [100 100 1000 600])

%%% 2-dimensional

% Define target marginal data distribution pT(x1, x2)
pT_X = @(x1, x2) mvnpdf([x1, x2], [0, -1], .25*eye(2));

% Call sampler
[Xn, Xp, Zn, Zp] = sample_covshift2D(pT_X, 'ub', sqrt(det(2*pi*0.25*eye(2))));

% Visualize output using scatterplots
figure(2);

r1 = [min([Xn(:,1); Xp(:,1); Zn(:,1); Zp(:,1)]), max([Xn(:,1); Xp(:,1); Zn(:,1); Zp(:,1)])];
r2 = [min([Xn(:,2); Xp(:,2); Zn(:,2); Zp(:,2)]), max([Xn(:,2); Xp(:,2); Zn(:,2); Zp(:,2)])];

subplot(1,2,1);
hold on
scatter(Xn(:,1), Xn(:,2), 10, 'r');
scatter(Xp(:,1), Xp(:,2), 10, 'b');
xlabel('x_1');
ylabel('x_2');
title('Source domain')
set(gca, 'XLim', r1, 'YLim', r2);

subplot(1,2,2);
hold on
scatter(Zn(:,1), Zn(:,2), 10, 'r');
scatter(Zp(:,1), Zp(:,2), 10, 'b');
xlabel('x_1');
ylabel('x_2');
title('Target domain')
set(gca, 'XLim', r1, 'YLim', r2);

set(gcf, 'Color', 'w', 'Position', [200 200 1000 600])