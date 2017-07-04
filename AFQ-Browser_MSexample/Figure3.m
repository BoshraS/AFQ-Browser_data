load AFQ-Browser_MSexample.mat
% Script for figure 1
tracts = [3 9 13 19];
fgnames = AFQ_get(afq, 'fgnames');
ms = AFQ_get(afq, 'metadata','MultipleSclerosis');
nodes = 6:95;
colors = [1 0 0; 0 0 1];
sub = 21;
close all
properties = {'md' 'rd' 'fa'}
%% MD plot
for p = 1:length(properties)
    for ii = tracts
        data = AFQ_get(afq, fgnames{ii}, properties{p});
        % Plot individual subjects and SDs
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
            if jj==1
            zs = minmax((data(sub,nodes)-m)./sd);
            fprintf('patient max %.2f min %.2f zscore prop %s tract %s', zs(1),zs(2),properties{p},fgnames{ii})
            end
        end
        % Plot patients as light lines
        plot(repmat(nodes,[sum(ms==1),1])',data(ms==1,nodes)','-', 'color', [.5 .5 1],'linewidth',.5)
        % Highlight one patient as a bold line
        plot(nodes, data(sub,nodes),'-', 'color', colors(2,:),'linewidth',2)
        % Format axis and save figure
        hold off
        xlabel('Distance Along Fiber Bundle','fontsize',14)
        set(gca,'fontsize',12)
        print(sprintf('MSpatient-Tract%d-%s.pdf',ii,properties{p}),'-dpdf')
        close
        
        % Plot group comparison and SEs
        figure; hold
        for jj = 1:2
            d = data(ms==jj-1,nodes);
            m = nanmean(d);
            sd = nanstd(d);
            n = sum(ms==0);
            se = sd./sqrt(n);
            % SD
            patch([nodes fliplr(nodes)], [m+se fliplr(m-se)],colors(jj,:), ...
                'edgealpha', 0, 'facealpha', .3);
            % Plot
            plot(nodes, m, '-', 'color', colors(jj,:), 'linewidth',3);
            %axis([5 95 .55 .75])
        end
        % Format axis and save figure
        hold off
        xlabel('Distance Along Fiber Bundle','fontsize',14)
        set(gca,'fontsize',12)
        print(sprintf('GroupComp-MSpatient-Tract%d-%s.pdf',ii,properties{p}),'-dpdf')
        close
    end
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

