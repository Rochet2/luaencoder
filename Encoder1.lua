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

--[[
We want to remove 'b' from the string "abcabc"
We encode it by using 'a', '<' and '>'
We replace all 'a' with 'a<'
We replace all 'b' with 'a>'

To decode
We replace all 'a>' with 'b'
We replace all 'a<' with 'a'

We need to make sure '<' and '>' are not the same as 'a' and 'b' given by user
We need to escape user given values for format characters when using them with gsub
At worst encoder and encoded take two times more characters if they exist in the given string
]]

local gsub = gsub or string.gsub
local assert = assert
local Encoder = {}
local DEFAULT_ENCODER = '$'
local coders = {"<",">","{","}"}

local function selectCoders(encoded, encoder)
    local a, b
    for i = 1, #coders do
        if coders[i] ~= encoded and coders[i] ~= encoder then
            if not a then
                a = coders[i]
            else
                b = coders[i]
                break
            end
        end
    end
    return a, b
end

function Encoder.Encode(str, encoded, encoder)
    encoder = encoder or DEFAULT_ENCODER
    assert(encoded ~= encoder)
    local a, b = selectCoders(encoded, encoder)
    local escaped_encoded = gsub(encoded, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
    local escaped_encoder = gsub(encoder, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
    return (gsub((gsub(str, escaped_encoder, encoder..a)), escaped_encoded, encoder..b))
end

function Encoder.Decode(str, encoded, encoder)
    encoder = encoder or DEFAULT_ENCODER
    assert(encoded ~= encoder)
    local a, b = selectCoders(encoded, encoder)
    local escaped_encoder = gsub(encoder, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
    local escaped_a = gsub(a, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
    local escaped_b = gsub(b, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
    return (gsub((gsub(str, escaped_encoder..escaped_b, encoded)), escaped_encoder..escaped_a, encoder))
end

return Encoder
