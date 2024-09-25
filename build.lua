#!/usr/bin/env lua

-- get xanmod pkgbuild
os.execute("git clone https://aur.archlinux.org/linux-xanmod.git ; mv linux-xanmod/* . ; rm -rf linux-xanmod")

-- read PKGBUILD
local r_file = io.open("PKGBUILD", "r")
if r_file ~= nil then
	Pkgbuild = r_file:read("*all")
	r_file:close()
else
	print("PKGBUILD not found")
	os.exit(1)
end

-- get cjktty patch
local	cjktty_address = "v" .. Pkgbuild:match("_branch=([%w%.]+)") .. "/cjktty-" .. Pkgbuild:match("_major=(%d+%.%d+)") .. ".patch"

-- manually enter version
if #arg < 1 then
	os.execute("aria2c --enable-rpc=false -d . https://raw.githubusercontent.com/bigshans/cjktty-patches/master/" .. cjktty_address)
	cjktty_file_name = "cjktty-" .. Pkgbuild:match("_major=(%d+%.%d+)") .. ".patch"
else if arg[1]:match("^--cjkversion=") then
	local cjkversion = arg[1]:match("^--cjkversion=([%d%.]+)$")
	os.execute("aria2c --enable-rpc=false -d . https://raw.githubusercontent.com/bigshans/cjktty-patches/master/v".. cjkversion:gsub("%.%d+", ".x") .. "/cjktty-" .. cjkversion .. ".patch")
	cjktty_file_name = "cjktty-" .. cjkversion .. ".patch"
else
	print("invalid arg")
	os.exit(1)
end
end

os.execute("aria2c --enable-rpc=false -d . https://raw.githubusercontent.com/bigshans/cjktty-patches/master/cjktty-add-cjk32x32-font-data.patch")

-- add cjktty patch to PKGBUILD
local insert_text = string.format([[
patch -Np1 -i ../../%s
patch -Np1 -i ../../cjktty-add-cjk32x32-font-data.patch	
]], cjktty_file_name)

New_pkgbuild = Pkgbuild:gsub("(patch %-Np1 %-i %.%./patch%-%${pkgver}%-xanmod%${xanmod}%${_revision})", insert_text .. "%1")

local w_file = io.open("PKGBUILD", "w")
if w_file ~= nil then
	w_file:write(New_pkgbuild)
	w_file:close()
else
	os.exit(1)
end

-- execute
os.execute("env _microarchitecture=13 use_numa=y use_tracers=y _config=config_x86-64-v3 _compress_modules=y makepkg")
