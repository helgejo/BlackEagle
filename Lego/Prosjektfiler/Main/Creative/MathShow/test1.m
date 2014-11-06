%%
x = 0:0.01:9;
y = sin(x);
functAxis=[0 9 min(y) max(y)];
for i = 2:length(x)
    bar([x(i-1) x(i)], [y(i-1) y(i)]);
    axis(functAxis);
    drawnow;
end
bar(x,y);

%%
x = 0:0.01:9;
y = sin(x);
functAxis=[0 9 min(y) max(y)];
subplot(2,1,2)
bar(x,y);
axis(functAxis);
for i = 2:length(x)
    subplot (2,1,1)
    bar([x(i-1) x(i)], [y(i-1) y(i)]);
    axis(functAxis);
    drawnow;
end

%%
x = 0:0.01:9;
y = sin(x);
functAxis=[0 9 min(y) max(y)];

for i = 2:length(x)
    subplot (2,1,1)
    bar([x(i-1) x(i)], [y(i-1) y(i)]);
    axis(functAxis);
    drawnow;
    subplot(2,1,2)
    bar(x(1:i),y(1:i));
    axis(functAxis);
end

%%
%
tic;
for i=0:0.01:1
    t=toc
end

%%
x=[1 3 1];
y=[2 3 4];
fill(x,y,'b');

%%
close gcf
x=-0.1:0.01:3;
y=exp(x.^x);
plot(x,y);