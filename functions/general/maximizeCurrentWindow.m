
function maximizeCurrentWindow()
    jFrame = get(handle(gcf),'JavaFrame');
    jFrame.setMaximized(true);
end
