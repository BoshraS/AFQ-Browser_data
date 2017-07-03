load AFQ-Browser_MSexample.mat
% Script for figure 1
tracts = [3 9 19];
fgnames = AFQ_get(afq, 'fgnames');
ms = AFQ_get(afq, 'metadata','MultipleSclerosis');
nodes = 6:95;
colors = [1 0 0; 0 0 1];
sub = 21;
close all

%% MD plot
for ii = tracts
    data = AFQ_get(afq, fgnames{ii}, 'md');
    figure; hold
    for jj = 1:2
    d = data(ms==jj-1,nodes);
    m = nanmean(d);
    sd = nanstd(d);
    n = sum(ms==0);
    se = sd./sqrt(n);
    % SD
    patch([nodes fliplr(nodes)], [m+sd fliplr(m-sd)],colors(jj,:), ...
        'edgealpha', 0, 'facealpha', .3);
    % Plot
    plot(nodes, m, '-', 'color', colors(jj,:), 'linewidth',3);
    %axis([5 95 .55 .75])
    end
    % Plot patient
    plot(data(sub,nodes),'-', 'color', colors(2,:),'linewidth',1)
    
    hold off
    ylabel('Mean Diffusivity (\mum^2/ms)','fontsize',14)
    xlabel('Distance Along Fiber Bundle','fontsize',14)
    set(gca,'fontsize',12)
    print(sprintf('Figure1_MD-%d.pdf',ii),'-dpdf')
end

%% FA plot
for ii = tracts
    data = AFQ_get(afq, fgnames{ii}, 'fa');
    figure(ii); hold
    for jj = 1:3
        g = age>agebin(jj) & age<=agebin(jj+1);
        d = data(g,nodes);
        m = nanmean(d);
        sd = nanstd(d);
        n = sum(g);
        se = sd./sqrt(n);
        % errorbars
        patch([nodes fliplr(nodes)], [m+se fliplr(m-se)],colors(jj,:), ...
            'edgealpha', 0, 'facealpha', .3);
        % Plot
        plot(nodes, m, '-', 'color', colors(jj,:), 'linewidth',3);
    end
    axis([6 95 .35 .695])
    hold off
    ylabel('Fractional Anisotropy','fontsize',14)
    xlabel('Distance Along Fiber Bundle','fontsize',14)
    set(gca,'fontsize',12)
    print(sprintf('Figure1_FA-%d.pdf',ii),'-dpdf')
end


%% Render fibers
fg = fgRead('exampleFibers.mat')
im = niftiRead('t1_class_2DTI.nii.gz');
im.data = im.data==4;
msh = AFQ_meshCreate(im,'boxfilter',5)

AFQ_RenderFibers(fg(3),'color',[.7 .7 .7],'numfibers',500,'radius',.5)
fg3 = dtiResampleFiberGroup(fg(3),100,'N');
for ii = 1:length(fg3.fibers)
    fg3.fibers{ii} = fg3.fibers{ii}(:,45:75);
end
AFQ_RenderFibers(fg3,'color',[1 .5 0],'numfibers',500,'newfig',0)
AFQ_RenderFibers(fg(19),'color',[0 .5 1],'numfibers',500,'newfig',0)
AFQ_RenderFibers(fg(5),'color',[0 .5 0],'numfibers',500,'newfig',0)
patch(msh.tr)
shading interp
axis image
axis off
print('Rendering.png','-dpng')

