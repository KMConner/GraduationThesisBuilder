local function ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
 end

function Image(img)
    if ends_with(img.src, ".svg") then
        local new_name = img.src:sub(0, -5) .. ".pdf"
        local svg_path = os.getenv("PWD") .. "/" .. img.src
        local pdf_path = os.getenv("PWD") .. "/" .. new_name

        local result = os.execute("inkscape --without-gui --export-pdf=" .. pdf_path .. " " .. svg_path)
        if not result then
            error("Failed to convert svg file(s).")
        end
        img.src = new_name
        return img
    end
end
