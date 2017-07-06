% Render fibers with tableu 20
cd ~/git/AFQ-Browser_data/AFQ-Browser_example
load AFQ-Browser_example.mat
fg = fgRead('exampleFibers.mat')
rgb = tableu20;
fgnames = AFQ_get(afq,'fgnames')
for ii = 1:20
   lh = AFQ_RenderFibers(fg(ii),'numfibers',500,'color',rgb(ii,:)./255);
   if sum(ii==[1 3 5 7 11 13 15 17 19])>0
       view(270,0)
   elseif sum(ii==[2 4 6 8 12 14 16 18 20])>0
       view(90,0)
   else
       view(180,90)
   end
   camlight(lh,'right');
   axis off
   print(sprintf('%s.png',fgnames{ii}),'-dpng','-r300')
end
