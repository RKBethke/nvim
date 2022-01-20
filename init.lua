local ok, err = pcall(require, "core")

if not ok then
    error("Error: " .. err)
end
