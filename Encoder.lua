--[[
    Copyright (C) 2014-  Rochet2 <https://github.com/Rochet2>

    This program is free software you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]

local gsub = gsub or string.gsub
local Encoder = {}

local DEFAULT_ENCODER = '$'

local coders = {
    ['<'] = '{',
    ['>'] = '{',
}

function Encoder.Encode(str, encoded, encoder)
    encoder = ((encoder and coders[encoder]) or encoder) or DEFAULT_ENCODER
    if encoded == encoder then return str end
    local escaped_encoded = gsub(encoded, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
    local escaped_encoder = gsub(encoder, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
    return (gsub((gsub(str, '([<>])'..escaped_encoder, '%1>'..encoder)), escaped_encoded, '<'..encoder))
end

function Encoder.Decode(str, encoded, encoder)
    encoder = ((encoder and coders[encoder]) or encoder) or DEFAULT_ENCODER
    if encoded == encoder then return str end
    local escaped_encoder = gsub(encoder, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
    return (gsub((gsub(str, '<'..escaped_encoder, encoded)), '>'..escaped_encoder, encoder))
end

return Encoder
