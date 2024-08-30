function printFig(fig, filename, type, margin)
    arguments
        fig;
        filename = '0.png';
        type = 'png';
        margin = true;
    end

    if(strcmp(type, 'svg'))
        % svg
        print(filename, '-dsvg', '-r300', '-vector');

    elseif(strcmp(type, 'eps'))
        % eps
        exportgraphics(fig, filename, 'Resolution', 300, 'Colorspace', 'rgb', 'ContentType', 'vector')

    elseif(strcmp(type, 'png'))
        if(margin)
            % 余白ありpng
            print(filename, '-dpng', '-r300');
        else
            % 余白なしpng
            exportgraphics(fig, filename, 'Resolution', 300, 'Colorspace', 'rgb', 'ContentType', 'image')
        end

    elseif(strcmp(type, 'pdf') && strcmp(margin, true))
        if(margin)
            % 余白ありpdf
            print(filename, '-dpdf', '-vector');
        else
            % 余白なしpdf
            exportgraphics(fig, filename, 'Resolution', 300, 'Colorspace', 'rgb', 'ContentType', 'vector')
        end

    else
        disp("Error!")
    end

end