
local testing = false

local function ask_for_project_path(root, name)
    local project = root..'/'..name
    if testing then return project end
    vim.notify('Create template in `'..project..'`? (y/n)', vim.log.levels.WARN)
    if 'y' == vim.fn.nr2char(vim.fn.getchar()) then return project end
    return nil
end

local project = nil
local function write_file(path, contents)
    local f = assert(io.open(assert(project)..'/'..path, 'w+'))
    f:write(contents)
    f:close()
end

local function vim_header(name)
    return string.format('vim.g.my_project="%s"\nvim.cmd("cd! %%:h")\n', name)
end


local cpp_clang = function(root, name)
    project = ask_for_project_path(root, name)
    if not project then return end
    vim.fn.mkdir(project)

    write_file('_vim.lua', vim_header(name)..'vim.o.makeprg="clang *.cpp"')
    write_file('main.cpp', '#include <iostream>\n\nint main()\n{\n    std::cout << "hello '..name..'" << std::endl;\n}\n')

end

local cpp_cmake_ninja_clang = function(root, name)
    project = ask_for_project_path(root, name)
    if not project then return end

    vim.fn.mkdir(project)

    write_file('_vim.lua', vim_header(name)..'vim.o.makeprg="cmake --build _build"')

    write_file('CMakeLists.txt', string.format([[
cmake_minimum_required(VERSION 3.30)
project(%s VERSION 0.1)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_custom_target(copy-compile-commands ALL ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/compile_commands.json ${CMAKE_CURRENT_LIST_DIR})

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(%s
    src/main.cpp
)
]], name, name))


    vim.fn.mkdir(project..'/_build')

    write_file('_build/_generate.cmd', [[
cd %~dp0
cmake -G "Ninja" -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang %~dp0\..
]])

    write_file('_build/_build.cmd', 'cmake --build _build')

    write_file('_build/_debug.cmd', 'start /i "" "devenv.exe" /debugexe '..name..'.exe')

    vim.fn.mkdir(project..'/src')
    write_file('src/main.cpp', '#include <iostream>\n\nint main()\n{\n\tstd::cout << "hello '..name..'" << std::endl;\n}\n')

end

testing = false

if testing then
    vim.fn.delete('c:\\dev\\template_cmake_cpp', 'rf')
    cpp_cmake_ninja_clang('c:\\dev', 'template_cmake_cpp')
    vim.fn.delete('c:\\dev\\template_cpp', 'rf')
    cpp_clang('c:\\dev', 'template_cpp')
end

return {cmake_project = cpp_cmake_ninja_clang, cpp_sandbox = cpp_clang}
