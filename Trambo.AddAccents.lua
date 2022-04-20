script_name="@TRAMBO: Add Accents"
script_description="Add accents to characters"
script_author="TRAMBO"
script_version="1.0"

include("karaskel.lua") -- karaskel.lua written by Niels Martin Hansen and Rodrigo Braz Monteiro

--Main 
function main(sub, sel, act)
  l1 = sub[sel[1]]
  l2 = sub[sel[2]]
  
  l2.text = add_accents(l1.text,l2.text)
  sub[sel[2]] = l2
  aegisub.set_undo_point(script_name)
  return sel
end

function get_raw(str)
  local t = {} -- full str
  for c, i in unicode.chars(str) do
    table.insert(t, c)
  end
  
  local p = {} --chars' position
  local n = 1
  while n <= #t do 
    if t[n] == "{" then
      while t[n] ~= "}" do
        n = n + 1
      end
      n = n + 1
    else
      table.insert(p, n)
      n = n + 1
    end
  end  
  return t, p
end

function add_accents(new,old) -- parameters are strings
  local pNew = {}
  tNew, pNew = get_raw(new)
  local pOld = {}
  tOld, pOld = get_raw(old)
  local nText = ""
  local oText = ""
  for i, p in ipairs(pNew) do
    nText = nText .. tNew[p]
  end
  
  for i, p in ipairs(pOld) do
    oText = oText .. tOld[p]
  end
  
  if (#pOld ~= #pNew) then
    aegisub.debug.out("Failed to add accents: Two lines of text must have the same pattern.\n")
    aegisub.debug.out("Line 1: " .. nText .. "\n")
    aegisub.debug.out("Line 2: " .. oText .. "\n")
    aegisub.debug.out("Please edit one of two lines.")
  else
    for i, o in ipairs(pOld) do
     if tNew[pNew[i]] ~= tOld[o] then
      tOld[o] = tNew[pNew[i]]
     end
    end
  end
  
  local res = ""
  for i, c in ipairs(tOld) do
    res = res .. c 
  end
  return res
end

--send to Aegisub's automation list
aegisub.register_macro(script_name,script_description,main,macro_validation)